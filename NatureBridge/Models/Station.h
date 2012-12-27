//
//  Station.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@class Observation, Project;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * remote_id;
@property (nonatomic, retain) NSString * station_schema_id;
@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *observations;
@end

@interface Station (CoreDataGeneratedAccessors)

- (void)addObservationsObject:(Observation *)value;
- (void)removeObservationsObject:(Observation *)value;
- (void)addObservations:(NSSet *)values;
- (void)removeObservations:(NSSet *)values;

- (void)setLatitude:(double)latitude andLongitude:(double)longitude;

@end
