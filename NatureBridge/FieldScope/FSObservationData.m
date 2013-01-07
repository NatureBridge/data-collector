//
//  FSObservationData.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/6/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
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
    NSLog(@">>>Found data: %@", data);
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
