//
//  FSTable.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FSTable : NSObject

// required
+ (NSString *)tableName;
+ (void) load:(void (^)(NSError *err))block;

// shared
+ (FSTable *)findByRemoteId:(NSNumber *)remoteId;
+ (NSFetchRequest *)buildRequest;
+ (NSArray *)executeRequest:(NSFetchRequest *)request;

@end
