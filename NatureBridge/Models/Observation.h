//
//  Observation.h
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
