//
//  FSProjects.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSProjects.h"
#import "FSConnection.h"
#import "FSStore.h"

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
+ (void) load:(void (^)(NSError *err))block
{
    FSStore *dbStore = [FSStore dbStore];
    if (![dbStore allProjects]) {
        NSFetchRequest *request = [self buildRequest];
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
                
        [dbStore setAllProjects:[[NSMutableArray alloc] initWithArray:[self executeRequest:request]]];
    }
    
    // Seed data
    if ([[dbStore allProjects] count] == 0) {
        [self createProject:@"Olympic"];
        [self createProject:@"Olympic Weather"];
        [dbStore saveChanges];
    }
}

/* NOT SAFE to call this muliple times, no find or create here, but then again, why are you even calling this?
 */
+ (Project *) createProject:(NSString *)projectName
{
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:[self tableName]
                                                     inManagedObjectContext:[[FSStore dbStore] context]];
    [project setName:projectName];
    [[[FSStore dbStore] allProjects] addObject:project];
    return project;
}

@end
