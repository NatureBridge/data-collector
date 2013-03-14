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
    [[self button] setFrame:CGRectMake(self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0,
                                       CELL_PADDING,
                                       INPUT_WIDTH,
                                       self.frame.size.height - CELL_PADDING * 2)];
    UIImage *arrow = [UIImage imageNamed:@"arrow"];
    [button setImage:arrow forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(CELL_PADDING,
                                                INPUT_WIDTH - ARROW_WIDTH,
                                                CELL_PADDING,
                                                CELL_PADDING)];
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
        [button addTarget:self action:@selector(buttonClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [[self contentView] addSubview:button];
    }
    return self;
}

// Respond to Cell Button Click - Popup Action Sheet
- (IBAction)buttonClick:(UIButton *)sender
{
    //Check if Edit enabled (May be View Only mode)
    if (![NBSettings editFlag]) return;
    // Popup List View
    [(ObservationViewController *)self.superview.nextResponder loadListPad:sender
                                                                      cell:self list:options];
}

+ (NSString *)identifier {
    return @"ListCell";
}
@end