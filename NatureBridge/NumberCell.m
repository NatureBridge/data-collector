//
//  NumberCell.m
//  NatureBridge
//
//  Created by Richard F Emmett.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//
#import "NumberCell.h"
#import "ObservationViewController.h"

@implementation NumberCell

@synthesize button;

// Layout Subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [[self button] setFrame:CGRectMake(self.contentView.frame.size.width
            - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2, CELL_PADDING,
            INPUT_WIDTH / 3, self.frame.size.height - CELL_PADDING * 2)];
}
// Add Button to Table View Cell
- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{   //NSLog(@"NumberCell: initWithField");
    self = [super initWithField:field forObservation:observation];
    if (self) {
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
// Set Button Value
- (void)updateValues
{   //NSLog(@"NumberCell: updateValues");
    [super updateValues];
    NSString *value = [[self data] stringValue];
    //NSLog(@"NumberCell: getValue: %@",value);
    [button setTitle:value forState:UIControlStateNormal];
}
// Respond to Cell Button Click - Popup Numeric Pad
- (IBAction)buttonClick:(UIButton *)sender
{   //NSLog(@"NumberCell: buttonClick %@",self.superview); // TableView
    [(ObservationViewController *)self.superview.nextResponder
     loadNumPad:sender cell:self];
}
+ (NSString *)identifier {
    return @"NumberCell";
}
@end
