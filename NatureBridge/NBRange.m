//
//  NBRange.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/26/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
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
