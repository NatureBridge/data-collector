//
//  NumberCell.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "NumberCell.h"
#import "ObservationViewController.h"
#import "NBSettings.h"

@implementation NumberCell

@synthesize button;

// Layout Subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    [[self button] setFrame:CGRectMake(self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2,
                                       CELL_PADDING,
                                       INPUT_WIDTH / 3,
                                       self.frame.size.height - CELL_PADDING * 2)];
    UIImage *arrow = [UIImage imageNamed:@"arrow"];
    [button setImage:arrow forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(CELL_PADDING,
                                                (INPUT_WIDTH / 3) - ARROW_WIDTH,
                                                CELL_PADDING,
                                                CELL_PADDING)];
}

// Add Button to Table View Cell
- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{
    self = [super initWithField:field forObservation:observation];
    if (self) {
        button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        button.tag = 3;
        button.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [[self contentView] addSubview:button];
    }
    return self;
}

// Set Button Value
- (void)updateValues
{
    [super updateValues];
    NSString *value = [[self data] stringValue];
    [button setTitle:value forState:UIControlStateNormal];
}

// Respond to Cell Button Click - Popup Numeric Pad
- (IBAction)buttonClick:(UIButton *)sender
{
    //Check if Edit enabled (May be View Only mode)
    if (![NBSettings editFlag]) {
      return;
    }
    
    // Popup NumericPad View
    [(ObservationViewController *)self.superview.nextResponder loadNumPad:sender cell:self];
}

+ (NSString *)identifier
{
    return @"NumberCell";
}
@end
