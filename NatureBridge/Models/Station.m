//
//  Station.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "Station.h"
#import "Observation.h"
#import "Project.h"


@implementation Station

@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic remote_id;
@dynamic station_schema_id;
@dynamic location;
@dynamic project;
@dynamic observations;

- (void)setLatitude:(double)latitude andLongitude:(double)longitude
{
    [self setLatitude:[NSNumber numberWithDouble:latitude]];
    [self setLongitude:[NSNumber numberWithDouble:longitude]];
    [self setLocation:[[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]]];
}

@end
