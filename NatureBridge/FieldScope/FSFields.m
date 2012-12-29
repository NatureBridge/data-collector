//
//  FSFields.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSFields.h"
#import "FSFieldGroups.h"
#import "FSConnection.h"
#import "FSStore.h"
#import "FieldGroup.h"
#import "Field.h"

@implementation FSFields

+ (NSString *)tableName
{
    return @"Field";
}

- (void)readFromJSONDictionary:(NSDictionary *)response
{
    NSLog(@"received %@ schemas from API server", [response objectForKey:@"count"]);
    for (NSDictionary *schema in [response objectForKey:@"results"]) {
        if (![[schema objectForKey:@"type"] isEqual:@"Observation"]) {
            continue;
        }
        for (NSDictionary *field_group in [schema objectForKey:@"field_groups"]) {
            //NSLog(@"%@", field_group);
            NSNumber *remoteId = [NSNumber numberWithInt:[[field_group objectForKey:@"id"] intValue]];
            FieldGroup *fieldGroup = [FSFieldGroups findOrCreate:remoteId
                                                           named:[field_group objectForKey:@"label"]];
            NSLog(@"Made (or found) a field group: %@", fieldGroup);
        }
    }
//    for (NSDictionary *station in stations) {
//        double longitude = 0;
//        double latitude  = 0;
//        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"([-]?+[0-9]+.[0-9]+) ([-]?+[0-9]+.[0-9]+)"
//                                                                          options:0
//                                                                            error:nil];
//        NSString *location = [station objectForKey:@"location"];
//        NSArray *matches = [regex matchesInString:location
//                                          options:0
//                                            range:NSMakeRange(0, [location length])];
//        
//        if([matches count] > 0) {
//            NSTextCheckingResult *result = [matches objectAtIndex:0];
//            if ([result numberOfRanges] == 3) {
//                longitude = [[location substringWithRange:[result rangeAtIndex:1]] doubleValue];
//                latitude  = [[location substringWithRange:[result rangeAtIndex:2]] doubleValue];
//            }
//        }
//        
//        [FSStations createStation:[NSNumber numberWithInt:[[station objectForKey:@"id"] intValue]]
//                             name:[station objectForKey:@"name"]
//                         latitude:latitude
//                        longitude:longitude];
//    }
    [[FSStore dbStore] saveChanges];
}

+ (void)load:(void (^)(NSError *))block
{
    FSStore *dbStore = [FSStore dbStore];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[[[dbStore model] entitiesByName] objectForKey:@"FieldGroup"]];
    
    NSError *error = nil;
    NSArray *result = [[dbStore context] executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if([result count] == 0) {
        NSURL *url = [NSURL URLWithString:[[FSConnection apiPrefix] stringByAppendingString:@"schemas.json"]];
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        FSFields *rootObject = [[FSFields alloc] init];
        
        FSConnection *connection = [[FSConnection alloc] initWithRequest:request rootObject:rootObject completion:block];
        
        [connection start];
    }
}

@end
