//
//  FSStations.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/25/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//
//  This file deals with parsing FieldScope API responses for stations#index

#import "FSTable.h"
#import "JSONSerializable.h"
#import "Station.h"

@interface FSStations : FSTable <JSONSerializable>

@property Project *project;

- (Station *) createStation:(NSNumber *)remoteId name:(NSString *)name latitude:(double)latitude longitude:(double)longitude;

@end
