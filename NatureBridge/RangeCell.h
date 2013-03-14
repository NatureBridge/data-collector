//
//  RangeCell.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "FieldCell.h"

@interface RangeCell : FieldCell
{
    IBOutlet UISlider *slider;
}

@property (nonatomic, strong) UISlider *slider;
@property UILabel *sliderValue;

- (IBAction)sliderValueChanged:(UISlider *)sender;

@end
