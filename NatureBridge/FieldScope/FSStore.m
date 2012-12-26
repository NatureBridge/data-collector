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
- (NSString *) apiPrefix;
- (NSString *) itemArchivePath;
@end

@implementation FSStore
+ (FSStore *)dbStore
{
    static FSStore *dbStore = nil;
    if (!dbStore) {
        dbStore = [[super allocWithZone:nil] init];
    }
    return dbStore;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self dbStore];
}

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

- (BOOL) saveChanges
{
    NSError *error = nil;
    BOOL successful = [context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void) loadProjects
{
    if (!allProjects) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[[model entitiesByName] objectForKey:@"Project"]];
        [request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        allProjects = [[NSMutableArray alloc] initWithArray:result];
    }
    
    // Seed data
    if ([allProjects count] == 0) {
        [self createProject:@"Olympic"];
    }
}

- (Project *) createProject:(NSString *)projectName
{
    Project *project = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:context];
    [project setName:projectName];
    [allProjects addObject:project];
    return project;
}

- (void)loadStations:(void (^)(NSError *))block
{
    if (!allStations) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[[model entitiesByName] objectForKey:@"Station"]];
        //[request setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        allStations = [[NSMutableArray alloc] initWithArray:result];
    }
    
    NSURL *url = [NSURL URLWithString:[[self apiPrefix] stringByAppendingString:@"stations"]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    FSStations *station = [[FSStations alloc] init];
    
    FSConnection *connection = [[FSConnection alloc] initWithRequest:request rootObject:station completion:block];
    
    [connection start];
}

- (Station *)findStation:(NSNumber *)remote_id
{
    BOOL (^search)(id obj, NSUInteger idx, BOOL *stop) = ^BOOL(id station, NSUInteger idx, BOOL *stop) {
        return [[station remote_id] isEqualToNumber:remote_id];
    };
    NSUInteger index = [allStations indexOfObjectPassingTest:search];
    return index < [allStations count] ? allStations[index] : nil;
}

- (Station *)createStation:(NSNumber *)remote_id name:(NSString *)name latitude:(double)latitude longitude:(double)longitude
{
    Station *station = [self findStation:remote_id];
    
    if(!station) {
        station = [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:context];
        [station setRemote_id:remote_id];
        [station setName:name];
        [station setLatitude:latitude andLongitude:longitude];
        
        NSLog(@"made a station: %@ with location: %@", station, station.location);
        [allStations addObject:station];
    } else {
        NSLog(@"found an existing station, not creating");
    }

    return station;
}

// private

- (NSString *) itemArchivePath
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (NSString *) apiPrefix
{
    return [NSString stringWithFormat:@"http://test.fieldscope.org/api/%@/",
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"FSProject"] lowercaseString]];
}

@end
