//
//  RangeCell.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/2/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "FieldCell.h"

@interface RangeCell : FieldCell
{
    IBOutlet UISlider *slider;
}

//@property (nonatomic, strong) UISlider *slider;
@property UILabel *sliderValue;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end
