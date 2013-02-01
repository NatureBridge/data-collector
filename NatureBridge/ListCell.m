//
//  ListCell.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/11/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//
#import "ListCell.h"
#import "Value.h"

@implementation ListCell

@synthesize button;
@synthesize options;

// Layout Subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [[self button] setFrame:CGRectMake(self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0,
                                       CELL_PADDING,
                                       INPUT_WIDTH,
                                       self.frame.size.height - CELL_PADDING * 2)];
}

// Update Options and Set Button Value
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
        button.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [button addTarget:self
                   action:@selector(buttonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [[self contentView] addSubview:button];
    }
    return self;
}

// Respond to Cell Button Click - Popup Action Sheet
- (IBAction)buttonClick:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@""]; //Add Blank Option
    for (Value *value in options) {
        [actionSheet addButtonWithTitle:[value label]];
    }
    [actionSheet showInView:self.superview];
}

// Respond to Action Sheet Button Click - Save option chosen
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 0) return; // Handle click outside Action Sheet
    NSString *label = @"";
    NSString *value=@"";
    if (buttonIndex > 0) {
        label = [[options objectAtIndex:buttonIndex-1] label];
        value = [NSString stringWithFormat:@"%d",buttonIndex-1];
    }
    [button setTitle:label forState:UIControlStateNormal];
    [[self data] setStringValue:value];
}

+ (NSString *)identifier {
    return @"ListCell";
}
@end