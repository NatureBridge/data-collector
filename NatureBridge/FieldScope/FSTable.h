//
//  FSTable.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FSTable <NSObject>

+ (void) load:(void (^)(NSError *err))block;

@end
