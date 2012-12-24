//
//  FSAPI.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSAPI.h"

@implementation FSAPI
- (NSString *) apiPrefix
{
    return [NSString stringWithFormat:@"http://test.fieldscope.org/api/%@/",
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"FSProject"] lowercaseString]];
}
@end
