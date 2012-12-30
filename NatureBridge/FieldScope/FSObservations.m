//
//  FSObservations.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSObservations.h"
#import "FSStore.h"
#import "FSFields.h"
#import "FSStations.h"

@implementation FSObservations

+ (NSString *)tableName
{
    return @"Observation";
}

/* This is the baddest of the load functions, we preload basically every table here and force hits to two API endpoints
 * Please please please have connectivity when running this for the first time (Not necessary for successive calls)
 */
+ (void)load:(void (^)(NSError *))block
{
    FSStore *dbStore = [FSStore dbStore];
    if (![dbStore allObservations]) {
        NSFetchRequest *request = [self buildRequest];
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"collectionDate"
                                                                                           ascending:YES]]];
        
        [dbStore setAllObservations:[[NSMutableArray alloc] initWithArray:[self executeRequest:request]]];
    }
    
    // Preload schema (FieldGroup, Field, and Value tables)
    void (^onSchemaLoad)(NSError *error) =
    ^(NSError *error) {
        if (error) {
            NSLog(@"schema loading error: %@", error);
        }
    };
    [FSFields load:onSchemaLoad];

    // Seed data
    if (![dbStore allStations]) {
        void (^onStationLoad)(NSError *error) =
        ^(NSError *error) {
            if (error) {
                NSLog(@"station loading error: %@", error);
            } else if ([[dbStore allObservations] count] == 0) {
                // Make a blank observation to test the view, TODO: remove this for production
                [self createObservation:[[dbStore allStations] objectAtIndex:0]];
                [dbStore saveChanges];
            }
            block(error);
        };
        // Preload stations
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
