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

@property (nonatomic, retain) NSDate * collectionDate;
@property (nonatomic, retain) Station *station;
@property (nonatomic, retain) NSSet *observationData;

- (NSString *) formattedDate;
- (NSString *) formattedUTCDate;
- (NSString *) stationName;

@end

@interface Observation (CoreDataGeneratedAccessors)

- (void)addObservationDataObject:(NSManagedObject *)value;
- (void)removeObservationDataObject:(NSManagedObject *)value;
- (void)addObservationData:(NSSet *)values;
- (void)removeObservationData:(NSSet *)values;

@end
