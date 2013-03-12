//
//  FieldCell.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
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
