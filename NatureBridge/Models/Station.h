//
//  Station.h
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
#import <CoreLocation/CoreLocation.h>

@class Observation, Project;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * remoteId;
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *observations;

- (void)setLatitude:(double)latitude andLongitude:(double)longitude;
- (NSString *)prettyLocation;

@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addObservationsObject:(Observation *)value;
- (void)removeObservationsObject:(Observation *)value;
- (void)addObservations:(NSSet *)values;
- (void)removeObservations:(NSSet *)values;

@end
