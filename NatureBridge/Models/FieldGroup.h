//
//  FieldGroup.h
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

@class Field, Project;

@interface FieldGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * remoteId;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *fields;
@property (nonatomic, retain) NSNumber * ordinal;
@end

@interface FieldGroup (CoreDataGeneratedAccessors)

- (void)addFieldsObject:(Field *)value;
- (void)removeFieldsObject:(Field *)value;
- (void)addFields:(NSSet *)values;
- (void)removeFields:(NSSet *)values;

@end
