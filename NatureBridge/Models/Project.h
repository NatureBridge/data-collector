//
//  Project.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
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
