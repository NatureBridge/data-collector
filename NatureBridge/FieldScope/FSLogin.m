//
//  FSLogin.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSLogin.h"

@implementation FSLogin
#warning "This class won't work until API CSRF is disabled :(

- (void) doLogin
{
    response = [[NSMutableData alloc] init];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\"}", @"olympic.fieldscope.org@naturebridge.org", @"science13"];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    NSURL *url = [NSURL URLWithString:[[self apiPrefix] stringByAppendingString:@"login"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];

    NSLog(@"%@", request);
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [response appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSLog(@"%@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
}

- (void) connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", [error localizedDescription]);
}
@end
