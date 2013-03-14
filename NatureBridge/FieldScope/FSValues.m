//
//  FSValues.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
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
