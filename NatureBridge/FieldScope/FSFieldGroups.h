//
//  FSFieldGroups.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSTable.h"
#import "FieldGroup.h"

@interface FSFieldGroups : FSTable

+ (FieldGroup *)findOrCreate:(NSNumber *)remoteId named:(NSString *)name;

@end
