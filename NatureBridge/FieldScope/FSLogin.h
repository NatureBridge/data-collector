//
//  FSLogin.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSLogin : NSObject
{
    NSURLConnection *connection;
    NSMutableData *response;
}
- (void) doLogin;
@end
