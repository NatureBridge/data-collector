//
//  Observation.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "Observation.h"
#import "Station.h"

@implementation Observation

@dynamic collectionDate;
@dynamic station;
@dynamic observationData;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    [self setCollectionDate:[NSDate date]];
}

- (NSString *)formattedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[self collectionDate]];
}
- (NSString *)formattedUTCDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [dateFormatter stringFromDate:[self collectionDate]];
}

- (NSString *)stationName
{
    return [self station].name;
}
@end
