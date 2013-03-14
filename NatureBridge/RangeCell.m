//
//  RangeCell.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "RangeCell.h"
#import "ObservationViewController.h"
#import "NBSettings.h"

@implementation RangeCell

@synthesize slider;
@synthesize sliderValue;

// Layout Subviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.sliderValue setFrame:CGRectMake(self.contentView.frame.size.width - 50.0 - UNIT_WIDTH - CELL_PADDING * 2.0,
                                          CELL_PADDING,
                                          50.0,
                                          self.frame.size.height - CELL_PADDING * 2.0)];
    [slider setFrame:CGRectMake(self.contentView.frame.size.width -  INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0,
                                CELL_PADDING,
                                INPUT_WIDTH - 50.0 - CELL_PADDING,
                                self.frame.size.height - CELL_PADDING * 2.0)];
}

// Add Slider to Table View Cell
- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{
    self = [super initWithField:field forObservation:observation];
    if(self) {
        // Initialization code - Add Value Field
        [self setSliderValue:[[UILabel alloc] init]];
        sliderValue.textAlignment = NSTextAlignmentRight;
        sliderValue.backgroundColor = [UIColor clearColor];
        [[self contentView] addSubview:sliderValue];
        // Initialization code - Add Slider Field
        slider = [[UISlider alloc] init];
        slider.tag = 3;
        slider.continuous = YES;
        [slider addTarget:self action:@selector(sliderValueChanged:)
         forControlEvents:UIControlEventValueChanged];
        [[self contentView] addSubview:slider];
    }
    return self;
}

// Set Slider Value
- (void)updateValues
{
    [super updateValues];
    [self setSlider];
    [slider sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSlider
{
    NSString *value = [[self data] stringValue];
    self.sliderValue.text = value;
    float inc = [NBSettings sliderInc:self.field.name];
    float min = [self.field.minimum doubleValue];
    float max = [self.field.maximum doubleValue];
    slider.minimumValue = min - inc;
    slider.maximumValue = max + inc;
    if (value.length < 1) {
        slider.value = min - inc;
    } else {
        slider.value = [value doubleValue] + inc;
    }
}

// Respond to Slider Value Change
- (IBAction)sliderValueChanged:(UISlider *)sender
{
    //Check if Edit enabled (May be View Only mode)
    if (![NBSettings editFlag]) {
        [self setSlider];
        return;
    }
    
    // Save new value
    float pos = sender.value;
    float inc = [NBSettings sliderInc:self.field.name];
    NSString *value = @"";
    if (pos > inc) {
        value = [[NSString alloc ] initWithString:[NBSettings round:(pos - inc) for:self.field.name]];
    }
    self.sliderValue.text = value;
    [self.data setStringValue:value];
}

+ (NSString *)identifier
{
    return @"RangeCell";
}
@end
