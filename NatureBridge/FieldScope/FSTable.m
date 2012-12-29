//
//  FSTable.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSTable.h"
#import "FSStore.h"

@implementation FSTable

+ (FSTable *)findByRemoteId:(NSNumber *)remoteId
{
    NSFetchRequest *request = [self buildRequest];
    [request setPredicate:[NSPredicate predicateWithFormat:@"remoteId = %@", remoteId]];
    
    NSArray *result = [self executeRequest:request];
    return [result count] > 0 ? [[self executeRequest:request] objectAtIndex:0] : nil;
}

+ (NSString *) tableName
{
    [NSException raise:@"Incomplete implementation" format:@"Expected tableName to be implemted by subclass"];
    return nil;
}

+ (void) load:(void (^)(NSError *err))block;
{
    [NSException raise:@"Incomplete implementation" format:@"Expected load to be implemted by subclass"];
}

+ (NSFetchRequest *)buildRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[[[[FSStore dbStore] model] entitiesByName] objectForKey:[self tableName]]];
    
    return request;
}

+ (NSArray *)executeRequest:(NSFetchRequest *)request
{
    NSError *error = nil;
    NSArray *result = [[[FSStore dbStore] context] executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
    return result;
}

@end
