//
//  FSTable.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
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
