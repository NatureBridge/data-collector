//
//  FSProjects.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "FSProjects.h"
#import "FSConnection.h"
#import "FSStore.h"
#import "NBSettings.h"

@implementation FSProjects

+ (NSString *)tableName
{
    return @"Project";
}

/* We pull the project from SQL because NSUserDefaults doesn't let us store arbitrary objects
 * also, I don't trust the allProjects array, bah humbug
 */
+ (Project *)currentProject
{
    static Project *currentProject = nil;
    NSString *currentProjectName = [[NSUserDefaults standardUserDefaults] objectForKey:@"FSProject"];
    if (!currentProject || [currentProject name] != currentProjectName) {
        NSFetchRequest *request = [self buildRequest];
        [request setPredicate:[NSPredicate predicateWithFormat:@"name like %@", currentProjectName]];
        
        currentProject = [[self executeRequest:request] objectAtIndex:0];
    }
    return currentProject;
}

/* No API endpoint here :(
 */
+ (void) load:(FSHandler)block
{
    FSStore *dbStore = [FSStore dbStore];
    if (![dbStore allProjects]) {
        NSFetchRequest *request = [self buildRequest];
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
                
        [dbStore setAllProjects:[[NSMutableArray alloc] initWithArray:[self executeRequest:request]]];
    }
    
    // Seed data
    if ([[dbStore allProjects] count] == 0) {
        //NSLog(@"FSProjects: load.");
        NSDictionary *projects = [NBSettings projects];
        for (NSString *key in [projects allKeys])
            [self createProject:key label:[projects objectForKey:key]];
        [dbStore saveChanges];
    }
}

/* NOT SAFE to call this muliple times, no find or create here, but then again, why are you even calling this?
 */
+ (Project *) createProject:(NSString *)name label:(NSString *)label
{
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:[self tableName]
                                                     inManagedObjectContext:[[FSStore dbStore] context]];
    [project setName:name];
    [project setLabel:label];
    [[[FSStore dbStore] allProjects] addObject:project];
    return project;
}

@end
