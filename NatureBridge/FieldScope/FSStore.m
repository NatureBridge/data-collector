//
//  FSStore.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/22/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSStore.h"

@class Project;

@interface FSStore ()
- (NSString *) itemArchivePath;
@end

@implementation FSStore

@synthesize model;
@synthesize context;
@synthesize allProjects;

/* Return the one and only true instance of the class
 */
+ (FSStore *)dbStore
{
    static FSStore *dbStore = nil;
    if (!dbStore) {
        dbStore = [[super allocWithZone:nil] init];
    }
    return dbStore;
}

/* Little hack here to make sure we NEVER have more than one instance of this class... god help us all if we do
 */
+ (id)allocWithZone:(NSZone *)zone
{
    return [self dbStore];
}

/* This opens the connection to SQL and keeps it open forever
 */
- (id) init
{
    self = [super init];
    
    if (self) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:[NSURL fileURLWithPath:[self itemArchivePath]]
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        [context setUndoManager:nil];
    }
    
    return self;
}

/* This is where we deal with the tricky issue of persistence, call this often any time you feel like it
 */
- (BOOL) saveChanges
{
    NSError *error = nil;
    BOOL successful = [context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

// private
- (NSString *) itemArchivePath
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

@end
