//
//  FSStore.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//
//  This file manages the database connection through CoreData

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FSStore : NSObject

@property NSManagedObjectModel *model;
@property NSManagedObjectContext *context;
@property NSMutableArray *allProjects;

+ (FSStore *)dbStore;
- (BOOL) saveChanges;

@end
