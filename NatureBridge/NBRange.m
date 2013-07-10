//
//  NBRange.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "NBRange.h"
#import "NBSettings.h"

@implementation NBRange

+(NSString *) check:(NSNumber *)value min:(NSNumber *)min max:(NSNumber *)max
{   //NSLog(@"NBRange: check: %@ %@ %@",value,min,max);
    NSString *msg = nil;
    if (value == nil) msg = @"nil";
    if (min != nil && [value compare:min] < 0) msg = @"Too Small";
    if (max != nil && [max compare:value] < 0) msg = @"Too Big";
    if ((msg != nil) && ![NBSettings isPhone]) {
        [self pop:([NSString stringWithFormat:@"Value is %@",msg])];
    }return msg;
}
+(BOOL) alertCheck:(NSNumber *)value min:(NSNumber *)min max:(NSNumber *)max
{   //NSLog(@"NBRange: alertCheck: %@ %@ %@",value,min,max);
    NSString *msg = nil;
    if (value == nil) msg = @"nil";
    if (min != nil && [value compare:min] < 0) msg = @"Value is Too Small";
    if (max != nil && [max compare:value] < 0) msg = @"Value is Too Big";
    if (msg != nil) {
        [self pop:msg];return(NO);
    } return(YES);
}
+(BOOL) checkLatitude:(double)lat andLongitude:(double)lon
{   //NSLog(@"NBRange: checkLocation: %f %f",lat,lon);
    if (lat < [NBSettings minLatitude]) {NSLog(@"LatMin: %f",[NBSettings minLatitude]); return(NO);}
    if (lat > [NBSettings maxLatitude]) {NSLog(@"LatMax: %f",[NBSettings maxLatitude]); return(NO);}
    if (lon < [NBSettings minLongitude]) {NSLog(@"LonMin: %f",[NBSettings minLongitude]); return(NO);}
    if (lon > [NBSettings maxLongitude]) {NSLog(@"LonMax: %f",[NBSettings maxLongitude]); return(NO);}
    return(YES);
}
+(BOOL) alertLatitude:(double)lat andLongitude:(double)lon
{   //NSLog(@"NBRange: alertLocation: %f %f",lat,lon);
    NSString *msg = nil;
    if (lat < [NBSettings minLatitude]) msg = @"Latitude is Too Small";
    if (lat > [NBSettings maxLatitude]) msg = @"Latitude is Too Big";
    if (lon < [NBSettings minLongitude]) msg = @"Longitude is Too Small";
    if (lon > [NBSettings maxLongitude]) msg = @"Longitude is Too Big";
    if (msg != nil) {
        [self pop:msg]; return(NO);
    } return(YES);
}
+(CLLocation *) clipLocation:(CLLocation *)location {
    if (location == nil) return(nil);
    double lat = location.coordinate.latitude;
    double lon = location.coordinate.longitude;
    if (lat < [NBSettings minLatitude]) lat = [NBSettings minLatitude];
    if (lat > [NBSettings maxLatitude]) lat =[NBSettings maxLatitude];
    if (lon < [NBSettings minLongitude]) lon = [NBSettings minLongitude];
    if (lon > [NBSettings maxLongitude]) lon = [NBSettings maxLongitude];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return(loc);
}

+(void) pop:(NSString *)msg
{   //NSLog(@"NBRange: pop: %@",msg);
    UIAlertView *pop;
    pop = [[UIAlertView alloc] initWithTitle:@"ALERT" message:msg
        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [pop show];
}
@end
