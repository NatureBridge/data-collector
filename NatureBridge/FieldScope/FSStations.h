//
//  FSStations.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/25/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//
//  This file deals with parsing FieldScope API responses for stations#index

#import <Foundation/Foundation.h>
#import "FSTable.h"
#import "JSONSerializable.h"
#import "Station.h"

@interface FSStations : NSObject <JSONSerializable, FSTable>

+ (void) load:(void (^)(NSError *err))block;
+ (Station *) createStation:(NSNumber *)remoteId name:(NSString *)name latitude:(double)latitude longitude:(double)longitude;

@end
