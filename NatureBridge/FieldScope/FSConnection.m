//
//  FSConnection.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/25/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation FSConnection
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
    NSString *projectName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"FSProject"] lowercaseString];
    NSString *projectURL = [projectName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    return [NSString stringWithFormat:@"http://test.fieldscope.org/api/%@/", projectURL];
}

@end
