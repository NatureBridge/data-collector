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
#import "FieldGroup.h"
#import "Field.h"
#import "Value.h"
#import "Station.h"

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
{   //NSLog(@"FSProjects: load.");
    FSStore *dbStore = [FSStore dbStore];
    // If are no projects
    if (![dbStore allProjects]) {
        NSFetchRequest *request = [self buildRequest];
        [request setSortDescriptors:[NSArray arrayWithObject:
                    [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        [dbStore setAllProjects:[[NSMutableArray alloc] initWithArray:[self executeRequest:request]]];
    }
    // Seed data
    if ([[dbStore allProjects] count] < 1) {
        NSDictionary *projects = [NBSettings projects];
        for (NSString *key in [projects allKeys]) {
            [self createProject:key label:[projects objectForKey:key]];
        }
        [dbStore saveChanges];
    }
    // Eric change add 3 lines
    if (block != nil) {
        block(nil);
    }
}

/* NOT SAFE to call this muliple times, no find or create here, but then again, why are you even calling this?
 */
+ (Project *) createProject:(NSString *)name label:(NSString *)label
{   //NSLog(@"FSProjects. createProject: %@",name);
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:[self tableName]
                                                     inManagedObjectContext:[[FSStore dbStore] context]];
    [project setName:name];
    [project setLabel:label];
    [[[FSStore dbStore] allProjects] addObject:project];
    return project;
}
+ (void) deleteProject:(Project *)project
{   //NSLog(@"FSProjects: delete: %@",project.label);
    for (FieldGroup *group in [project fieldGroups]) {
        //NSLog(@"\tGroup: %@",group.name);
        for (Field *field in [group fields]) {
            //NSLog(@"\t\tField: %@",field.label);
            if ([[field values] count] > 0) {
                for (Value *value in [field values]) {
                    //NSLog(@"\t\t\tValue: %@",value.label);
                    [[[FSStore dbStore] context] deleteObject:value]; }
            }[[[FSStore dbStore] context] deleteObject:field];
        }[[[FSStore dbStore] context] deleteObject:group];
    }
    //NSLog(@"Delete Stations.");
    for (Station *station in [project stations]) {
        //NSLog(@"\tStation: %@",station.name);
        [[[FSStore dbStore] context] deleteObject:station];
    }
    [[[FSStore dbStore] context] deleteObject:project];
    //NSLog(@"Projects saveChanges.");
    [[FSStore dbStore] saveChanges];
}
+ (void) deleteAll
{   //NSLog(@"FSProjects: deleteAll.");
    for (Project *project in [[FSStore dbStore] allProjects]) {
        [FSProjects deleteProject:project];
    }
    [[FSStore dbStore] setAllProjects:nil];
}
@end
