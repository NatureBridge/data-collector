//
//  FieldGroup.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FieldGroup.h"
#import "Field.h"
#import "Project.h"
#import "FSProjects.h"


@implementation FieldGroup

@dynamic name;
@dynamic remoteId;
@dynamic project;
@dynamic fields;

- (void) awakeFromInsert
{
    [super awakeFromInsert];
    
    [self setProject:[FSProjects currentProject]];
}

@end
