//
//  Field.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
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
@property (nonatomic, retain) NSManagedObject *fieldGroup;
@property (nonatomic, retain) NSSet *values;
@property (nonatomic, retain) NSSet *observationData;
@property (nonatomic, retain) NSNumber * ordinal;
@end

@interface Field (CoreDataGeneratedAccessors)

- (void)addValuesObject:(Value *)value;
- (void)removeValuesObject:(Value *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

- (void)addObservationDataObject:(NSManagedObject *)value;
- (void)removeObservationDataObject:(NSManagedObject *)value;
- (void)addObservationData:(NSSet *)values;
- (void)removeObservationData:(NSSet *)values;

@end
