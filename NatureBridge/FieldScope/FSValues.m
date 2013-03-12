//
//  FSValues.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSValues.h"

@implementation FSValues

+ (NSString *)tableName
{
    return @"Value";
}

/* Call FSFields.load instead, it takes care of loading this table
 */
+ (void)load:(void (^)(NSError *))block
{
    [NSException raise:@"Incorrect usage" format:@"FSValues.load is implemented by FSFields.load, call that instead"];
}
@end
