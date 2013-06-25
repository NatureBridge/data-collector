//
//  FSLogin.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "FSLogin.h"
#import "FSConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation FSLogin

- (id) initWithBlock:(void (^)(NSError *, NSString *))block username:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if(self) {
        NSString *jsonRequest = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
        NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
        
        NSURL *url = [NSURL URLWithString:[[FSConnection apiPrefix] stringByAppendingString:@"login"]];
        [self setRequest:[NSMutableURLRequest requestWithURL:url]];
        [self setCompletionBlock:block];
        
        [[self request] setHTTPMethod:@"POST"];
        [[self request] setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [[self request] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [[self request] setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [[self request] setHTTPBody: requestData];
        
        NSLog(@"%@", [self request]);
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
