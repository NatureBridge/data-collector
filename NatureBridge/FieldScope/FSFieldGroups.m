//
//  FSFieldGroups.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSFieldGroups.h"
#import "FSStore.h"

@implementation FSFieldGroups

+ (NSString *)tableName
{
    return @"FieldGroup";
}

/* Support active style find or create syntax, this is to future proof against dynamic schemas
 */
+ (FieldGroup *)findOrCreate:(NSNumber *)remoteId named:(NSString *)name
{
    FieldGroup *fieldGroup = (FieldGroup *)[self findByRemoteId:remoteId];
    if (!fieldGroup) {
        fieldGroup = [NSEntityDescription insertNewObjectForEntityForName:[self tableName]
                                                   inManagedObjectContext:[[FSStore dbStore] context]];
        [fieldGroup setRemoteId:remoteId];
        [fieldGroup setName:name];
    }
    
    return fieldGroup;
}

/* Call FSFields.load instead, it takes care of loading this table
 */
+ (void)load:(void (^)(NSError *))block
{
    [NSException raise:@"Incorrect usage" format:@"FSFieldGroups.load is implemented by FSFields.load, call that instead"];
}

@end
