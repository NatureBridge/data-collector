//
//  FSConnection.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/25/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//
//  This file manages the HTTP connection to FieldScope

#import <Foundation/Foundation.h>
#import "JSONSerializable.h"
#import "FSTable.h"
#import "Project.h"

@interface FSConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) FSHandler completionBlock;
@property (nonatomic, strong) id <JSONSerializable> rootObject;

- (id) initWithRequest:(NSURLRequest *)req rootObject:obj completion:block;
- (void) start;

+ (NSString *) apiPrefix:(Project *)project;
+ (NSString *) apiPrefix;
+ (NSHTTPCookie *) sessionCookie;
+ (void)destroySessionCookie;
+ (BOOL) authenticated;

@end
