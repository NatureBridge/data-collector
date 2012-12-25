//
//  FSConnection.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/25/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../JSONSerializable.h"

@interface FSConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *internalConnection;
    NSMutableData *container;   
}

@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(NSError *err);
@property (nonatomic, strong) id <JSONSerializable> rootObject;

- (id) initWithRequest:(NSURLRequest *)req rootObject:obj completion:block;
- (void) start;

@end
