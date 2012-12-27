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
@dynamic remoteId;
@dynamic location;
@dynamic project;
@dynamic observations;

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    [self setPrimitiveValue:loc forKey:@"location"];
}

- (void)setLatitude:(double)latitude andLongitude:(double)longitude
{
    [self setLatitude:[NSNumber numberWithDouble:latitude]];
    [self setLongitude:[NSNumber numberWithDouble:longitude]];
}

@end
