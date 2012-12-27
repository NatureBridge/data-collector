//
//  Field.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Value;

@interface Field : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * maximum;
@property (nonatomic, retain) NSNumber * minimum;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * units;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSManagedObject *field_group;
@property (nonatomic, retain) NSSet *values;
@property (nonatomic, retain) NSSet *observation_data;
@end

@interface Field (CoreDataGeneratedAccessors)

- (void)addValuesObject:(Value *)value;
- (void)removeValuesObject:(Value *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

- (void)addObservation_dataObject:(NSManagedObject *)value;
- (void)removeObservation_dataObject:(NSManagedObject *)value;
- (void)addObservation_data:(NSSet *)values;
- (void)removeObservation_data:(NSSet *)values;

@end
