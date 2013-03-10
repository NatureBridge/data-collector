//
//  FSStations.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//
//  This file deals with parsing FieldScope API responses for stations#index

#import "FSTable.h"
#import "JSONSerializable.h"
#import "Station.h"

@interface FSStations : FSTable <JSONSerializable>

@property Project *project;

- (Station *) createStation:(NSNumber *)remoteId name:(NSString *)name latitude:(double)latitude longitude:(double)longitude;

@end
