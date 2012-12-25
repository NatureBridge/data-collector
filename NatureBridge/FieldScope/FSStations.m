//
//  FSStations.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/25/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSStations.h"

@implementation FSStations

- (void)readFromJSONDictionary:(NSDictionary *)response
{
#warning incomplete
    NSLog(@"received %@ stations from API server", [response objectForKey:@"count"]);
    NSArray *stations = [response objectForKey:@"results"];
    for (NSDictionary *station in stations) {
        [[FSStore dbStore] createStation:[station objectForKey:@"name"] longitude:0 latitude:0];
    }
}

@end
