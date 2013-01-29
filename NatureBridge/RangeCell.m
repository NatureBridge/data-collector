//
//  RangeCell.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/2/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//
#import "RangeCell.h"
#import "NBSettings.h"

@implementation RangeCell

//@synthesize slider;
@synthesize sliderValue;

// Layout Subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.sliderValue setFrame:CGRectMake(self.contentView.frame.size.width -
            50.0 - UNIT_WIDTH - CELL_PADDING * 2.0, CELL_PADDING,   50.0,
            self.frame.size.height - CELL_PADDING * 2.0)];
    [slider setFrame:CGRectMake(self.contentView.frame.size.width -
            INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0, CELL_PADDING,
            INPUT_WIDTH - 50.0 - CELL_PADDING,
            self.frame.size.height - CELL_PADDING * 2.0)];
}
// Add Slider to Table View Cell
- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{   //NSLog(@"RangeCell: initWithField");
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
{   //NSLog(@"RangeCell: updateValues");
   [super updateValues];
    NSString *value = [[self data] stringValue];
    //NSLog(@"RangeCell: getValue: %@",value);
    self.sliderValue.text = value;
    float inc = [NBSettings sliderInc:self.field.name];
    float min = [self.field.minimum doubleValue];
    float max = [self.field.maximum doubleValue];
    //NSLog(@"RangeCell: min:%f max:%f inc:%f",min,max,inc);
    slider.minimumValue = min - inc;
    slider.maximumValue = max + inc;
    if (value.length < 1)
        slider.value = min - inc;
    else
        slider.value = [value doubleValue] + inc;
    [slider sendActionsForControlEvents:UIControlEventValueChanged];
}
// Respond to Slider Value Change
- (IBAction)sliderValueChanged:(UISlider *)sender
{   float pos = sender.value;
    //NSLog(@"RangeCell: slideValueChanged:%f",pos);
    float inc = [NBSettings sliderInc:self.field.name];
    NSString *value = @"";
    if (pos > inc) value = [[NSString alloc ] initWithString:
        [NBSettings round:(pos - inc) for:self.field.name]];
    self.sliderValue.text = value;
    //NSLog(@"RangeCell: saveValue: %@",value);
    [self.data setStringValue:value];
}
+ (NSString *)identifier {
    return @"RangeCell";
}
@end
