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
        double longitude = 0;
        double latitude  = 0;
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
        
        [[FSStore dbStore] createStation:[station objectForKey:@"name"] latitude:latitude longitude:longitude];
    }
}

@end
