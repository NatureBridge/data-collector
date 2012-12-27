//
//  FSProjects.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Models/Project.h"
#import "FSConnection.h"
#import "FSStore.h"

@interface FSProjects : NSObject

+ (void) loadProjects;
+ (Project *) createProject:(NSString *)projectName;

@end
