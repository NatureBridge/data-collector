//
//  NBRange.h
//  NatureBridge
//
//  Created by Richard F Emmett on 1/26/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBRange : UIViewController
{
}

+(BOOL) check:(NSNumber *)value min:(NSNumber *)min max:(NSNumber *)max;
+(void) pop:(NSString *)msg;

@end
