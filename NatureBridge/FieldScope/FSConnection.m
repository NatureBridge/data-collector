//
//  FSConnection.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/25/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSConnection.h"
#import "FSProjects.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation FSConnection

+ (NSString *)sessionCookie
{
    static NSString *cookie = nil;
    return cookie;
}

+ (BOOL)authenticated
{
    return [[self sessionCookie] length] > 0 ? YES : NO;
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

+ (NSString *) apiPrefix
{
    NSString *projectURL = [[[FSProjects currentProject] name] stringByReplacingOccurrencesOfString:@" "
                                                                                      withString:@"_"];
    // TODO: remove the test for production
    return [NSString stringWithFormat:@"http://test.fieldscope.org/api/%@/", projectURL];
}

@end
