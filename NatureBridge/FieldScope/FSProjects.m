//
//  FSProjects.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSProjects.h"

@implementation FSProjects

+ (void) loadProjects
{
    FSStore *dbStore = [FSStore dbStore];
    if (![dbStore allProjects]) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[[[dbStore model] entitiesByName] objectForKey:@"Project"]];
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        NSError *error = nil;
        NSArray *result = [[dbStore context] executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        [dbStore setAllProjects:[[NSMutableArray alloc] initWithArray:result]];
    }
    
    // Seed data
    if ([[dbStore allProjects] count] == 0) {
        [self createProject:@"Olympic"];
        [self createProject:@"Olympic Weather"];
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
