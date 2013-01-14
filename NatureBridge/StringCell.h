//
//  StringCell.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/2/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "FieldCell.h"

@interface StringCell : FieldCell <UITextFieldDelegate>

@property UITextField *stringField;

@end
