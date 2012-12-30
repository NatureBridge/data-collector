//
//  FSStations.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/25/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSStations.h"
#import "FSConnection.h"
#import "FSProjects.h"
#import "FSStore.h"

@implementation FSStations

+ (NSString *)tableName
{
    return @"Station";
}

/* Don't call directly, this is the JSON parser callback from FSStations.load
 */
- (void)readFromJSONDictionary:(NSDictionary *)response
{
    NSArray *stations = [response objectForKey:@"results"];
    for (NSDictionary *station in stations) {
        double longitude = 0;
        double latitude  = 0;
        // Why? Because I have no idea what those POINT things the API spits back are...
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"([-]?+[0-9]+.[0-9]+) ([-]?+[0-9]+.[0-9]+)"
                                                                          options:0
                                                                            error:nil];
        NSString *location = [station objectForKey:@"location"];
        NSArray *matches = [regex matchesInString:location
                                          options:0
                                            range:NSMakeRange(0, [location length])];
        
        if([matches count] > 0) {
            NSTextCheckingResult *result = [matches objectAtIndex:0];
            if ([result numberOfRanges] == 3) {
                longitude = [[location substringWithRange:[result rangeAtIndex:1]] doubleValue];
                latitude  = [[location substringWithRange:[result rangeAtIndex:2]] doubleValue];
            }
        }

        [FSStations createStation:[NSNumber numberWithInt:[[station objectForKey:@"id"] intValue]]
                             name:[station objectForKey:@"name"]
                         latitude:latitude
                        longitude:longitude];
    }
    [[FSStore dbStore] saveChanges];
}

/* THis is where we force the hit to the stations API and preload the allStations array
 */
+ (void)load:(void (^)(NSError *))block
{
    FSStore *dbStore = [FSStore dbStore];
    if (![dbStore allStations]) {
        NSFetchRequest *request = [self buildRequest];
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        [dbStore setAllStations:[[NSMutableArray alloc] initWithArray:[self executeRequest:request]]];
    }
    
    NSURL *url = [NSURL URLWithString:[[FSConnection apiPrefix] stringByAppendingString:@"stations"]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    FSStations *station = [[FSStations alloc] init];
    
    FSConnection *connection = [[FSConnection alloc] initWithRequest:request rootObject:station completion:block];
    
    [connection start];
}

/* This is actually implemented using find or create, so no worries if you call it twice on the same remoteId
 */
+ (Station *)createStation:(NSNumber *)remoteId name:(NSString *)name latitude:(double)latitude longitude:(double)longitude
{
    Station *station = (Station *)[self findByRemoteId:remoteId];
    
    if(!station) {
        station = [NSEntityDescription insertNewObjectForEntityForName:[self tableName]
                                                inManagedObjectContext:[[FSStore dbStore] context]];
        [station setRemoteId:remoteId];
        [station setName:name];
        [station setLatitude:latitude andLongitude:longitude];
        
        NSLog(@"made a %@: %@ with location: %@", [self tableName], station, station.location);
        [[[FSStore dbStore] allStations] addObject:station];
    } else {
        NSLog(@"found an existing station, not creating");
    }
    
    return station;
}

@end
