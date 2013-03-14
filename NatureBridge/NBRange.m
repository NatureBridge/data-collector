//
//  NBRange.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "NBRange.h"

@implementation NBRange

+(BOOL) check:(NSNumber *)value min:(NSNumber *)min max:(NSNumber *)max
{
    if (value == nil) {
        [self pop:(@"Value is null")];
        return NO;
    }
    if (min != nil && [value compare:min] < 0) {
        [self pop:(@"Value is too small")];
        return NO;
    }
    if (max != nil && [max compare:value] < 0) {
        [self pop:(@"Value is too big") ];
        return NO;
    }
    return YES;
}

+(void) pop:(NSString *)msg
{
    UIAlertView *pop;
    pop = [[UIAlertView alloc] initWithTitle:@"ALERT"
                                     message:msg
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
    [pop show];
}

@end
