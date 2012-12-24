//
//  FSStation.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSAPI.h"

@interface FSStation : FSAPI <NSURLConnectionDelegate>
{
    NSURLConnection *connection;
    NSMutableData *response;
}
- (void) doIndex;
@end
