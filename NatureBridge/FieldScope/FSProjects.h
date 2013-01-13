//
//  FSProjects.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSTable.h"
#import "Project.h"

@interface FSProjects : FSTable

+ (Project *) currentProject;
+ (Project *) createProject:(NSString *)name label:(NSString *)label;

@end
