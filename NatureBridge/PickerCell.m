//
//  PickerCell.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/2/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "PickerCell.h"

@implementation PickerCell

@synthesize pickerView;
@synthesize values;

+ (CGFloat)cellHeight
{
    return 216.0 + CELL_PADDING * 2;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.pickerView setFrame:CGRectMake(self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0,
                                         CELL_PADDING,
                                         self.pickerView.frame.size.width,
                                         self.pickerView.frame.size.height)];
}

- (id)initWithField:(Field *)field
{
    self = [super initWithField:field];
    if(self) {
        // Initialization code
        NSSortDescriptor *sortByValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:YES];
        [self setValues:[[field values] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByValue]]];
        [self setPickerView:[[UIPickerView alloc] init]];
        pickerView.tag = 3;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        [[self contentView] addSubview:pickerView];
    }
    return self;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    return;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [values count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[values objectAtIndex:row] label];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 300.0;
}

+ (NSString *)identifier
{
    return @"PickerCell";
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
