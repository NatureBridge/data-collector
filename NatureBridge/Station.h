//
//  Station.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONSerializable.h"

@class Project;

@interface Station : NSManagedObject

@property (nonatomic, retain) NSNumber * name;
@property (nonatomic, retain) NSString * station_schema_id;
@property (nonatomic, retain) NSNumber * remote_id;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property CLLocation *location;
@property (nonatomic, retain) Project *project;

@end
