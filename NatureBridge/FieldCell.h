//
//  FieldCell.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Field.h"

@interface FieldCell : UITableViewCell

@property Field *field;
@property UILabel *labelField;
@property UILabel *unitField;

- (id)initWithField:(Field *)field;
- (void)updateValues;
+ (NSString *)identifier;
+ (CGFloat) cellHeight;

@end
