//
//  ListCell.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/11/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//
#import "ListCell.h"

@implementation ListCell

@synthesize button;
@synthesize options;

// May not be needed anymore
- (void)layoutSubviews
{   //NSLog(@"ListCell:layoutSubviews");
    [super layoutSubviews];
    [self.button setFrame:CGRectMake(
            self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0,
            CELL_PADDING, INPUT_WIDTH, self.frame.size.height - CELL_PADDING * 2)];
}
// Update Options
- (void)updateValues
{   //NSLog(@"ListCell:updateValues");
    [super updateValues];
    NSSortDescriptor *sortByValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
    [self setOptions:[[self.field values] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByValue]]];
    //for (int i=0; i<[options count]; i++)
    //    NSLog(@"Option:Label %@",[[options objectAtIndex:i] label]);
}
// Add Button to Cell
- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{   //NSLog(@"ListCell:initWithField");
    self = [super initWithField:field forObservation:observation];
    if(self) {
        // Initialization code
        button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        button.tag = 3;        
        button.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button addTarget:self action:@selector(buttonClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [[self contentView] addSubview:button];
    }
    return self;
}
// Respond to Cell Button Click - Popup Action Sheet
- (IBAction)buttonClick:(UIButton *)sender
{   //NSLog(@"ListCell:buttonClick");
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
        delegate:self cancelButtonTitle:nil
        destructiveButtonTitle:nil otherButtonTitles:nil];
    for (int i=0; i<[options count]; i++) {
        [actionSheet addButtonWithTitle:[[options objectAtIndex:i] label]];
    }
    [actionSheet showInView:self.superview];
}
// Respond to Action Sheet Button Click - Save choice
-(void)actionSheet:(UIActionSheet *)actionSheet
                clickedButtonAtIndex:(NSInteger)buttonIndex
{   //NSLog(@"ListCell:clickedButtonAtIndex %i",buttonIndex);
    //button.titleLabel.text = [options objectAtIndex:buttonIndex];
    [button setTitle:[[options objectAtIndex:buttonIndex] label] forState:UIControlStateNormal];
    [[self data] setStringValue:[NSString stringWithFormat:@"%d",buttonIndex]];
}
+ (NSString *)identifier {
    return @"ListCell";
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end