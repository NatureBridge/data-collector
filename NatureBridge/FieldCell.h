//
//  FieldCell.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <UIKit/UIKit.h>
#import "Field.h"
#import "ObservationData.h"

#define CELL_PADDING 10.0
#define INPUT_WIDTH 320.0 // Try not change this one, it's more or less fixed by IOS
#define UNIT_WIDTH 70.0
#define ARROW_WIDTH 20.0

@interface FieldCell : UITableViewCell

@property Field *field;
@property Observation *observation;
@property ObservationData *data;
@property UILabel *labelField;
@property UILabel *unitField;

- (id)initWithField:(Field *)field forObservation:(Observation *)observation;
- (void)updateValues;
+ (NSString *)identifier;
+ (CGFloat)cellHeight;

@end
