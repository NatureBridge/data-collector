//
//  FSFieldGroups.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSFieldGroups.h"
#import "FieldGroup.h"
#import "FSStore.h"

@implementation FSFieldGroups

+ (NSString *)tableName
{
    return @"FieldGroup";
}

+ (FieldGroup *)findOrCreate:(NSNumber *)remoteId named:(NSString *)name
{
    FieldGroup *fieldGroup = (FieldGroup *)[self findByRemoteId:remoteId];
    if (!fieldGroup) {
        fieldGroup = [NSEntityDescription insertNewObjectForEntityForName:@"FieldGroup"
                                                   inManagedObjectContext:[[FSStore dbStore] context]];
        [fieldGroup setRemoteId:remoteId];
        [fieldGroup setName:name];
        
        NSLog(@"made a fieldGroup: %@", fieldGroup);
    }
    
    return fieldGroup;
}

@end
