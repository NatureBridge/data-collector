//
//  ObservationData.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Field, Observation;

@interface ObservationData : NSManagedObject

@property (nonatomic, retain) NSString * string_value;
@property (nonatomic, retain) NSNumber * number_value;
@property (nonatomic, retain) Observation *observation;
@property (nonatomic, retain) Field *field;

@end