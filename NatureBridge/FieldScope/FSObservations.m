//
//  FSObservations.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSObservations.h"
#import "FSStore.h"
#import "FSStations.h"

@implementation FSObservations
+ (void)load:(void (^)(NSError *))block
{
    FSStore *dbStore = [FSStore dbStore];
    if (![dbStore allObservations]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[[[dbStore model] entitiesByName] objectForKey:@"Observation"]];
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"collectionDate" ascending:YES]]];
        
        NSError *error = nil;
        NSArray *result = [[dbStore context] executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        [dbStore setAllObservations:[[NSMutableArray alloc] initWithArray:result]];
    }
    
    // Seed data
    if (![dbStore allStations]) {
        void (^onStationLoad)(NSError *error) =
        ^(NSError *error) {
            if (error) {
                NSLog(@"station loading error: %@", error);
            } else if ([[dbStore allObservations] count] == 0) {
                [self createObservation:[[dbStore allStations] objectAtIndex:0]];
                [dbStore saveChanges];
            }
            block(error);
        };
        [FSStations load:onStationLoad];
    } else {
        NSError *error = nil;
        block(error);
    }
}

+ (Observation *)createObservation:(Station *)station
{
    Observation *observation = [NSEntityDescription insertNewObjectForEntityForName:@"Observation"
                                                             inManagedObjectContext:[[FSStore dbStore] context]];
    [observation setStation:station];
    [[[FSStore dbStore] allObservations] addObject:observation];
    return observation;
}
@end
