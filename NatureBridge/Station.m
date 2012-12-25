//
//  Station.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "Station.h"
#import "Project.h"

@implementation Station

@dynamic name;
@dynamic station_schema_id;
@dynamic remote_id;
@dynamic latitude;
@dynamic longitude;
@synthesize location;
@dynamic project;

- (id)init
{
    self = [super init];
    if (self) {
        //location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    }
    return self;
}

@end
