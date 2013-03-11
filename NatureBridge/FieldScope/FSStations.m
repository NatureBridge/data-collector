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

@synthesize request;
@synthesize completionBlock;
@synthesize station;

+ (NSString *)tableName
{
    return @"Station";
}

- (id)initWithBlock:(FSLoggingHandler)block station:(Station *)newStation;
{
    self = [super init];
    if (self) {
        [self setStation:newStation];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"name=%@&x=%f&y=%f&is_public=true",
                                 [station name],
                                 [[station longitude] doubleValue],
                                 [[station latitude] doubleValue]];
                
        NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String]
                                             length:[jsonRequest length]];
        
        Project *project = [station project];
        NSURL *url = [NSURL URLWithString:[[FSConnection apiPrefix:project] stringByAppendingString:@"stations"]];
        
        [self setRequest:[NSMutableURLRequest requestWithURL:url]];
        [self setCompletionBlock:block];
        [[self request] setHTTPMethod:@"POST"];
        [[self request] setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [[self request] setHTTPBody: requestData];
    }
    return self;
}

- (void)start
{
    container = [[NSMutableData alloc] init];
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    statusCode = [httpResponse statusCode];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *name = [[NSString alloc]  initWithFormat:@"%@ %@",
                      [station name], [station prettyLocation]];
    NSError *error = nil;
    NSString *response = [[NSString alloc] initWithData:container encoding:NSUTF8StringEncoding];

    if (statusCode >= 200 && statusCode < 300) {
        [station setRemoteId:[NSNumber numberWithInt:[response integerValue]]];
    } else {
        error = [NSError errorWithDomain:@"HTTP" code:statusCode userInfo:nil];
    }
    
    if ([self completionBlock]) {
        [self completionBlock](name, error, response);
    }
}

+ (NSArray *)stations
{
    NSFetchRequest *request = [self buildRequest];
    [request setPredicate:[NSPredicate predicateWithFormat:@"remoteId = NULL"]];
    
    return [self executeRequest:request];
}

+ (void)upload:(FSLoggingHandler)block
{
    for(Station * station in [self stations]) {
        FSStations *connection = [[self alloc] initWithBlock:block station:station];
        [connection start];
    }
}

/* Don't call directly, this is the JSON parser callback from FSStations.load
 */
- (void)readFromJSONDictionary:(NSDictionary *)response
{
    for (NSDictionary *newStation in [response objectForKey:@"results"]) {
        double longitude = 0;
        double latitude  = 0;
        // Why? Because I have no idea what those POINT things the API spits back are...
        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"([-]?+[0-9]+.[0-9]+) ([-]?+[0-9]+.[0-9]+)"
                                                                          options:0
                                                                            error:nil];
        NSString *location = [newStation objectForKey:@"location"];
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
        
        [self createStation:[NSNumber numberWithInt:[[newStation objectForKey:@"id"] intValue]]
                       name:[newStation objectForKey:@"name"]
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
    Station *newStation = (Station *)[FSStations findByRemoteId:remoteId];
    
    if(!newStation) {
        newStation = [NSEntityDescription insertNewObjectForEntityForName:[FSStations tableName]
                                                inManagedObjectContext:[[FSStore dbStore] context]];
        [newStation setRemoteId:remoteId];
        [newStation setName:name];
        [newStation setLatitude:latitude andLongitude:longitude];
        [newStation setProject:[self project]];
    }
    
    return station;
}

@end
