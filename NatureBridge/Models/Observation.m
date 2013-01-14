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
    [dateFormatter setDateFormat:@"YYYY-MM-DD HH:mm:SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
    return [dateFormatter stringFromDate:[self collectionDate]];
}

@end
