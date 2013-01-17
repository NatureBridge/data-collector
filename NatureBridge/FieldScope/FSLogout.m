//
//  FSLogout.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/7/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "FSLogout.h"
#import "FSConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation FSLogout

- (id) initWithBlock:(void (^)(NSError *, NSString *))block
{
    self = [super init];
    if(self) {
        NSURL *url = [NSURL URLWithString:[[FSConnection apiPrefix] stringByAppendingString:@"logout"]];
        [self setRequest:[NSMutableURLRequest requestWithURL:url]];
        [self setCompletionBlock:block];
        
        [[self request] setHTTPMethod:@"POST"];
        [[self request] setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [[self request] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

- (void)start
{
    container = [[NSMutableData alloc] init];
    internalConnection = [[NSURLConnection alloc] initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if (!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    
    [sharedConnectionList addObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [container appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self completionBlock])
        [self completionBlock](nil, [[NSString alloc] initWithData:container encoding:NSUTF8StringEncoding]);
    
    [sharedConnectionList removeObject:self];
}

@end
