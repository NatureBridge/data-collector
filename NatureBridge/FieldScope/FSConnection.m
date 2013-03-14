//
//  FSConnection.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "FSConnection.h"
#import "FSProjects.h"
#import "NBSettings.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation FSConnection

+ (NSHTTPCookie *)sessionCookie
{
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([[cookie name] isEqualToString:@"sessionid"]) {
            return cookie;
        }
    }
    return nil;
}

+ (void)destroySessionCookie
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:[self sessionCookie]];
}

+ (BOOL)authenticated
{
    return [[[self sessionCookie] expiresDate] earlierDate:[NSDate date]] > 0 ? YES : NO;
}

- (id) initWithRequest:(NSURLRequest *)req rootObject:(id)obj completion:(id)block
{
    self = [super init];
    if (self) {
        [self setRequest:req];
        [self setRootObject:obj];
        [self setCompletionBlock:block];
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
    if ([self rootObject])
        [[self rootObject] readFromJSONDictionary:[NSJSONSerialization JSONObjectWithData:container options:0 error:nil]];
    
    if ([self completionBlock])
        [self completionBlock](nil);
    
    [sharedConnectionList removeObject:self];
}

+ (NSString *) apiPrefix:(Project *)project
{
    NSString *projectURL = [[project name] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return [NSString stringWithFormat:@"%@/%@/",[NBSettings siteURL],projectURL];
}

+ (NSString *)apiPrefix
{
    return [self apiPrefix:[FSProjects currentProject]];
}

@end
