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

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *stations;
@property (nonatomic, retain) NSSet *field_groups;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addStationsObject:(Station *)value;
- (void)removeStationsObject:(Station *)value;
- (void)addStations:(NSSet *)values;
- (void)removeStations:(NSSet *)values;

- (void)addField_groupsObject:(NSManagedObject *)value;
- (void)removeField_groupsObject:(NSManagedObject *)value;
- (void)addField_groups:(NSSet *)values;
- (void)removeField_groups:(NSSet *)values;

@end
