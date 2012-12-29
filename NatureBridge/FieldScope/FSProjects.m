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

+ (NSFetchRequest *)buildRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[[[[FSStore dbStore] model] entitiesByName] objectForKey:@"Project"]];

    return request;
}

+ (NSArray *)executeRequest:(NSFetchRequest *)request
{
    NSError *error = nil;
    NSArray *result = [[[FSStore dbStore] context] executeFetchRequest:request error:&error];
    if (!result) {
        [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
    }
    return result;
}

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

+ (Project *) createProject:(NSString *)projectName
{
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:@"Project"
                                                     inManagedObjectContext:[[FSStore dbStore] context]];
    [project setName:projectName];
    [[[FSStore dbStore] allProjects] addObject:project];
    return project;
}

@end
