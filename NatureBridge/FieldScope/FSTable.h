//
//  FSTable.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^FSHandler)(NSError *err);
typedef void (^FSLoggingHandler)(NSString *name, NSError *error, NSString *response);

@interface FSTable : NSObject

// required
+ (NSString *)tableName;
+ (void) load:(FSHandler)block;

// shared
+ (FSTable *)findByRemoteId:(NSNumber *)remoteId;
+ (NSFetchRequest *)buildRequest;
+ (NSArray *)executeRequest:(NSFetchRequest *)request;

@end
