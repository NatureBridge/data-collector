//
//  Observation.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Station;

@interface Observation : NSManagedObject

@property (nonatomic, retain) NSDate * collection_date;
@property (nonatomic, retain) Station *station;
@property (nonatomic, retain) NSSet *observation_data;
@end

@interface Observation (CoreDataGeneratedAccessors)

- (void)addObservation_dataObject:(NSManagedObject *)value;
- (void)removeObservation_dataObject:(NSManagedObject *)value;
- (void)addObservation_data:(NSSet *)values;
- (void)removeObservation_data:(NSSet *)values;

@end
