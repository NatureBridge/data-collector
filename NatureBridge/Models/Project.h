//
//  Project.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Station;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSSet *stations;
@property (nonatomic, retain) NSSet *fieldGroups;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addStationsObject:(Station *)value;
- (void)removeStationsObject:(Station *)value;
- (void)addStations:(NSSet *)values;
- (void)removeStations:(NSSet *)values;

- (void)addField_groupsObject:(NSManagedObject *)value;
- (void)removeFieldGroupsObject:(NSManagedObject *)value;
- (void)addFieldGroups:(NSSet *)values;
- (void)removeFieldGroups:(NSSet *)values;

@end
