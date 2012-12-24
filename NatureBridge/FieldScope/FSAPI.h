//
//  FSAPI.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSAPI : NSObject <NSURLConnectionDelegate>
- (NSString *) apiPrefix;
@end
