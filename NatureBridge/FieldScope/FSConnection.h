//
//  FSConnection.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
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
