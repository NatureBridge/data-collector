//
//  FSObservationData.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "FSObservationData.h"
#import "FSStore.h"

@implementation FSObservationData

+ (NSString *)tableName
{
    return @"ObservationData";
}

+ (ObservationData *)findByObservation:(Observation *)observation andField:(Field *)field
{
    for(ObservationData *data in [observation observationData])
    {
        if([[[data field] objectID] isEqual:[field objectID]]) {
            return data;
        }
    }
    return nil;
}

+ (ObservationData *)findOrCreateFor:(Observation *)observation withField:(Field *)field
{
    ObservationData *data = [self findByObservation:observation andField:field];
    if(!data) {
        data = [NSEntityDescription insertNewObjectForEntityForName:[self tableName]
                                             inManagedObjectContext:[[FSStore dbStore] context]];
        
        // mandatory fields
        [data setField:field];
        [data setObservation:observation];
    }
    return data;
}

@end
