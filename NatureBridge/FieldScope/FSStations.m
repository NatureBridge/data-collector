//
//  FSStations.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
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
        
        [self createStation:[NSNumber numberWithInt:[[station objectForKey:@"id"] intValue]]
                       name:[station objectForKey:@"name"]
                   latitude:latitude
                  longitude:longitude];
    }
    [[FSStore dbStore] saveChanges];
}

/* This is where we force the hit to the stations API
 */
+ (void)load:(void (^)(NSError *))block
{
    for(Project *project in [[FSStore dbStore] allProjects]) {
        NSURL *url = [NSURL URLWithString:[[FSConnection apiPrefix:project] stringByAppendingString:@"stations"]];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        FSStations *rootObject = [[FSStations alloc] init];
        [rootObject setProject:project];
        
        FSConnection *connection = [[FSConnection alloc] initWithRequest:request rootObject:rootObject completion:block];
        
        [connection start];
    }
}

/* This is actually implemented using find or create, so no worries if you call it twice on the same remoteId
 */
- (Station *)createStation:(NSNumber *)remoteId name:(NSString *)name latitude:(double)latitude longitude:(double)longitude
{
    Station *station = (Station *)[FSStations findByRemoteId:remoteId];
    
    if(!station) {
        station = [NSEntityDescription insertNewObjectForEntityForName:[FSStations tableName]
                                                inManagedObjectContext:[[FSStore dbStore] context]];
        [station setRemoteId:remoteId];
        [station setName:name];
        [station setLatitude:latitude andLongitude:longitude];
        [station setProject:[self project]];
    }
    
    return station;
}

@end
