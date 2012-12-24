//
//  FSStation.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSStation.h"

@implementation FSStation
- (void) doIndex
{
    response = [[NSMutableData alloc] init];    
    NSURL *url = [NSURL URLWithString:[[self apiPrefix] stringByAppendingString:@"stations"]];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"%@", request);
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [response appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn {
    NSLog(@"Stations response: %@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
}

- (void) connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed: %@", [error localizedDescription]);
}
@end
