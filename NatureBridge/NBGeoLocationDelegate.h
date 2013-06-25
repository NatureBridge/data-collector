//
//  NBGeoLocationDelegate.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol NBGeoLocationDelegate <NSObject>

// Define Required Methods
@required

-(void) alert:(NSString *)title msg:(NSString *)msg;
-(void) alert:(NSString *)msg;

-(void) setGeoLocation:(double)newLat lon:(double)newLon;

// Define Optional Methods
@optional

@end