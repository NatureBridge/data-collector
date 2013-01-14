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
#import "FSProjects.h"
#import "FSConnection.h"
#import "ObservationData.h"

@implementation FSObservations

@synthesize request;
@synthesize completionBlock;
@synthesize observation;

- (id)initWithBlock:(void (^)(NSError *error, NSString *response))block observation:(Observation *)newObservation;
{
    self = [super init];
    if (self) {
        [self setObservation:newObservation];

        NSString *jsonRequest = [NSString stringWithFormat:@"station_id=%@&collection_date=%@", [[observation station] remoteId], [observation formattedDate]];
        
        for(ObservationData *data in [observation observationData]) {
            if([[data value] length] > 0) {
                jsonRequest = [jsonRequest stringByAppendingFormat:@"&%@=%@", [[data field] name], [data value]];
            }
        }
        
        //jsonRequest = [jsonRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String]
                                             length:[jsonRequest length]];
        
        Project *project = [[observation station] project];
        NSURL *url = [NSURL URLWithString:[[FSConnection apiPrefix:project] stringByAppendingString:@"observations"]];
        
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:container encoding:NSUTF8StringEncoding];
    if ([self completionBlock])
        [self completionBlock](nil, response);
    
    if (![response isEqualToString:@"Bad Request"]) {
        [[self class] deleteObservation:[self observation]];
    }
}

+ (NSString *)tableName
{
    return @"Observation";
}

+ (NSArray *)observations
{
    NSFetchRequest *request = [self buildRequest];
    [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"collectionDate"
                                                                                       ascending:YES]]];
    
    return [self executeRequest:request];
}

/* This is the baddest of the load functions, we preload basically every table here and force hits to two API endpoints
 * Please please please have connectivity when running this for the first time (Not necessary for successive calls)
 */
+ (void)load:(void (^)(NSError *))block
{
    // Preload schema (FieldGroup, Field, and Value tables)
    void (^onSchemaLoad)(NSError *error) =
    ^(NSError *error) {
        if (error) {
            NSLog(@"schema loading error: %@", error);
        }
    };
    [FSFields load:onSchemaLoad];

    // Seed data
    if ([[[FSProjects currentProject] stations] count] < 1) {
        void (^onStationLoad)(NSError *error) =
        ^(NSError *error) {
            if (error) {
                NSLog(@"station loading error: %@", error);
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

+ (void)upload:(void (^)(NSError *error, NSString *response))block
{
    for(Observation * observation in [self observations]) {
        FSObservations *connection = [[self alloc] initWithBlock:block observation:observation];
        [connection start];
    }
}

+ (Observation *)createObservation:(Station *)station
{
    Observation *observation = [NSEntityDescription insertNewObjectForEntityForName:@"Observation"
                                                             inManagedObjectContext:[[FSStore dbStore] context]];
    [observation setStation:station];

    return observation;
}

+ (void)deleteObservation:(Observation *)observation
{
    for(ObservationData *data in [observation observationData]) {
        [[[FSStore dbStore] context] deleteObject:data];
    }
    [[[FSStore dbStore] context] deleteObject:observation];
    [[FSStore dbStore] saveChanges];
}
@end
