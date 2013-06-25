//
//  ListCell.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "ListCell.h"
#import "Value.h"
#import "ObservationViewController.h"
#import "NBSettings.h"

@implementation ListCell

@synthesize button;
@synthesize options;

// Layout Subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self button] setFrame:[self inputFrame]];
    UIImage *arrow = [UIImage imageNamed:@"arrow"];
    [button setImage:arrow forState:UIControlStateNormal];
    [button setImageEdgeInsets:[self listArrowInsets]];
}

// Update Options and Set Current Button Value
- (void)updateValues
{
    [super updateValues];
    NSSortDescriptor *sortByValue = [[NSSortDescriptor alloc]
                                     initWithKey:@"value" ascending:YES];
    [self setOptions:[[self.field values] sortedArrayUsingDescriptors:
                      [NSArray arrayWithObject:sortByValue]]];
    NSString *value=@"";
    if ([[[self data] stringValue] length] > 0) {
        int buttonIndex = [[[self data] stringValue] integerValue];
        value = [[[self options] objectAtIndex:buttonIndex] label];
    }
    [[self button] setTitle:value forState:UIControlStateNormal];
}

// Add Button to Table View Cell
- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{
    self = [super initWithField:field forObservation:observation];
    if(self) {
        // Initialization code
        button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        button.tag = 3;
        button.titleLabel.font = [NBSettings cellFont];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [button addTarget:self action:@selector(editCell:)
         forControlEvents:UIControlEventTouchUpInside];
        [[self contentView] addSubview:button];
    }
    return self;
}

// Respond to Edit Cell click - Popup Action Sheet
- (IBAction)editCell:(UIButton *)sender
{   //NSLog(@"ListCell: editCell.");
    //Check if Edit enabled (May be View Only mode)
    if (![NBSettings editFlag])
        return;
    // iPad: Popup Window for Action Sheet
    if (![NBSettings isPhone]) {
        [(ObservationViewController *)self.superview.nextResponder
            displayPopup:self rect:sender.frame
            arrow:UIPopoverArrowDirectionLeft];
    // iPhone: Display Action Sheet at bottom
    } else {
        [self displayInputForm:self];
    }
}
// Display Input Form (Option List) in Action Sheet
- (CGSize)displayInputForm:(UIView *)view
{   //NSLog(@"ListCell: displayInput.");
    int len = options.count;
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@""]; //Add Blank Option
    for (Value *option in options) {
        [actionSheet addButtonWithTitle:[option label]];
    }
    [actionSheet showInView:view];
    [actionSheet setBackgroundColor:[UIColor lightGrayColor]];
    CGSize size = CGSizeMake(380,55*(len+1));
    return(size);
}
// Respond to Option Selected click - Save Field Value
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{   //NSLog(@"ListCell: buttonClicked: %d",buttonIndex);
    NSString *text = @"";
    NSString *value=@"";
    if (buttonIndex > 0) {
        text = [[options objectAtIndex:buttonIndex-1] label];
        value = [NSString stringWithFormat:@"%d",buttonIndex-1];
    }
    if (value != nil) {
        [button setTitle:text forState:UIControlStateNormal];
        [[self data] setStringValue:value];
    }
    //NSLog(@"ListCell: value:%@ text:%@",value,text);
    // iPad: Dismiss Popup
    if (![NBSettings isPhone]) 
        [(ObservationViewController *)self.superview.nextResponder dismissPopup];
}

+ (NSString *)identifier {
    return @"ListCell";
}
@end