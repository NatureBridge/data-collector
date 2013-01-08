//
//  FSLogout.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/7/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSLogout : NSObject
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@property (nonatomic, copy) NSMutableURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(NSError *err, NSString *response);

- (id) initWithBlock:(void (^)(NSError *error, NSString *response))block;
@end
