//
//  RangeCell.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/2/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "RangeCell.h"

@implementation RangeCell

//@synthesize slider;
@synthesize sliderValue;

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    self.sliderValue.text = [NSString stringWithFormat:@"%.1f", sender.value];
    NSNumber *num = [NSNumber numberWithFloat:sender.value];
    [self.data setNumberValue:num];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.sliderValue setFrame:CGRectMake(self.contentView.frame.size.width - 50.0 - UNIT_WIDTH - CELL_PADDING * 2.0,
                                          CELL_PADDING,
                                          50.0,
                                          self.frame.size.height - CELL_PADDING * 2.0)];
    
    [slider setFrame:CGRectMake(self.contentView.frame.size.width - INPUT_WIDTH - UNIT_WIDTH - CELL_PADDING * 2.0,
                                          CELL_PADDING,
                                          INPUT_WIDTH - 50.0 - CELL_PADDING,
                                          self.frame.size.height - CELL_PADDING * 2.0)];
    
}


- (id)initWithField:(Field *)field forObservation:(Observation *)observation
{
    self = [super initWithField:field forObservation:observation];
    if(self) {
        // Initialization code
        [self setSliderValue:[[UILabel alloc] init]];
        sliderValue.textAlignment = NSTextAlignmentRight;
        sliderValue.backgroundColor = [UIColor clearColor];
        [[self contentView] addSubview:sliderValue];
        
        slider = [[UISlider alloc] init];
        slider.tag = 3;
        slider.continuous = YES;
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [[self contentView] addSubview:slider];
    }
    return self;
}

- (void)updateValues
{
    [super updateValues];
    if(![[self data] numberValue]) {
        [[self data] setNumberValue:[NSNumber numberWithDouble:[self.field.minimum doubleValue]]];
    }
    slider.minimumValue = [self.field.minimum doubleValue];
    slider.maximumValue = [self.field.maximum doubleValue];
    slider.value = [[[self data] numberValue] doubleValue];
    [slider sendActionsForControlEvents:UIControlEventValueChanged];
}

+ (NSString *)identifier
{
    return @"RangeCell";
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
