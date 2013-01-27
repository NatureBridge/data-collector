//
//  NBRange.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/26/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//

#import "NBRange.h"

@implementation NBRange

+(bool) check:(NSNumber *)value min:(NSNumber *)min max:(NSNumber *)max {
    //NSLog(@"NBRange: check:%@ min:%@ max:%@",value,min,max);
    if (value == nil) {
        [self pop:(@"Value is null")];
        return(false); }
    if (min != nil)
        if ([value compare:min] < 0) {
            [self pop:(@"Value is too small")];
            return(false); }
    if (max != nil)
        if ([max compare:value] < 0) {
            [self pop:(@"Value is too big") ];
            return(false); }
    return(true);
}
+(void) pop:(NSString *)msg {
    //NSLog(@"NBRange: pop:%@",msg);
    UIAlertView *pop;
    pop = [[UIAlertView alloc]
           initWithTitle:@"ALERT" message:msg
           delegate:nil cancelButtonTitle:@"OK"
           otherButtonTitles:nil];
    [pop show];
}

@end
