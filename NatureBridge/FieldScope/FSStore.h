//
//  FSStore.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/22/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//
//  This file manages the database connection through CoreData

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FSConnection.h"

@interface FSStore : NSObject

@property NSManagedObjectModel *model;
@property NSManagedObjectContext *context;
@property NSMutableArray *allProjects;
@property NSMutableArray *allStations;

+ (FSStore *)dbStore;
- (BOOL) saveChanges;

@end
