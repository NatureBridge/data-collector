//
//  Station.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "Station.h"
#import "Observation.h"
#import "FSProjects.h"

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

- (NSString *)prettyLocation
{
    double latitude = [[self latitude] doubleValue];
    double longitude = [[self longitude] doubleValue];
    
    int latSeconds = (int)round(abs(latitude * 3600));
    int latDegrees = latSeconds / 3600;
    latSeconds = latSeconds % 3600;
    int latMinutes = latSeconds / 60;
    latSeconds %= 60;
    
    int longSeconds = (int)round(abs(longitude * 3600));
    int longDegrees = longSeconds / 3600;
    longSeconds = longSeconds % 3600;
    int longMinutes = longSeconds / 60;
    longSeconds %= 60;
    
    char latDirection = (latitude >= 0) ? 'N' : 'S';
    char longDirection = (longitude >= 0) ? 'E' : 'W';
        
    return [NSString stringWithFormat:@"%i° %i' %i\" %c, %i° %i' %i\" %c", latDegrees, latMinutes, latSeconds, latDirection, longDegrees, longMinutes, longSeconds, longDirection];
}

@end
