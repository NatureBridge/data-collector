//
//  PickerCell.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/2/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "FieldCell.h"

@interface PickerCell : FieldCell <UIPickerViewDelegate, UIPickerViewDataSource>

@property UIPickerView *pickerView;
@property NSArray *values;

@end