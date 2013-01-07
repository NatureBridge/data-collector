//
//  FSLogin.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSLogin : NSObject
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@property (nonatomic, copy) NSMutableURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(NSError *err);

- (id) initWithBlock:(void (^)(NSError *))block;

@end
