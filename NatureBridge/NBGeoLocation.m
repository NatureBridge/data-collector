//
//  NBGeoLocation.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//
#import "NBGeoLocation.h"
#import "NBGeoLocationDelegate.h"
#import "NBRange.h"

@implementation NBGeoLocation

static CLLocationManager *locationManager;
static id <NBGeoLocationDelegate> caller;
static CLLocation *curLocation;
static NSString *timeOut = @"TimeOut";

// Start Location Manager
-(void) start:(id)byObject
{   //NSLog(@"NBGeoLocation: Start Location Manager by: %@",[byObject class]);
    caller = byObject;
    curLocation = nil;
    [caller alert:@"Geolocation" msg:@"Searching for the current location."];
    // Create the manager object
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    // Set Accuracy to save power
    locationManager.desiredAccuracy = 100.0;	//Meters
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    // Set Time Limit to save power
    [self performSelector:@selector(timeOut:)
       withObject:timeOut afterDelay:30];	//Secs
    //NSLog(@"NBGeoLocation: Start done.");
}
// Location Manager Succeeded
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    curLocation = [NBRange clipLocation:manager.location];
    //NSLog(@"NBGeoLocation: didUpdateToLocation: %@",curLocation);
    [NSObject cancelPreviousPerformRequestsWithTarget:self
        selector:@selector(timeOut:) object:timeOut];
    [self resp:[NBGeoLocation textLocation:curLocation]];
}
// Location Manager Error
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    //NSLog(@"NBGeoLocation: didFailWithError: %@",error);
    [NSObject cancelPreviousPerformRequestsWithTarget:self
        selector:@selector(timeOut:) object:timeOut];
    if ([error code] != kCLErrorDenied){
        [self resp:@"Location Services Not Enabled."]; return; }
    if ([error code] != kCLErrorNetwork) {
        [self resp:@"Network Services Not Available."]; return; }
    [self resp:@"Location Services Error."];
}
// Timeout
- (void) timeOut:(NSString *)msg {
   //NSLog(@"NBGeoLocation: timeOut.");
   [self resp:@"Location Services Time Out."];
}
#pragma mark - Location Manager delegate end.

// Location Manager Response: Success, Error or Time Out
- (void) resp:(NSString *)msg {
    //NSLog(@"NBGeoLocation: Resp: %@",msg);
    //NSLog(@"NBGeoLocation: Location Manager Stop.");
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
    [caller alert:msg];
}
// Location Manager Stop - Return result to caller
- (void) stop {
    //NSLog(@"NBGeoLocation: Stop: Return to caller.");
    if (locationManager) {
        //NSLog(@"NBGeoLocation: Location Manager Stop.");
        [locationManager stopUpdatingLocation];
        locationManager.delegate = nil;
        locationManager = nil; }
    double lat=0, lon=0;
    if (curLocation) {
        lat = curLocation.coordinate.latitude;
        lon = curLocation.coordinate.longitude; }
    // Return Location via Delegate method
    [caller setGeoLocation:lat lon:lon];
}
// Get Text Format: 99° 99' 99" N, 99° 99' 99" W
+(NSString *) textLocation:(CLLocation*)location {
    double lat = location.coordinate.latitude;
    double lon = location.coordinate.longitude;
    return([NBGeoLocation textLatitude:(double)lat
                          andLongitude:(double)lon]);
}
+(NSString *) textLatitude:(double)lat andLongitude:(double)lon
{    NSString *text = [NSString stringWithFormat:@"%@, %@",
                       [NBGeoLocation getText:'H' value:lat],
                       [NBGeoLocation getText:'V' value:lon] ];
    return(text);
}
+ (NSString *) getText:(char)axis value:(double)value {
    double num,rem;
    int middle, deg, row1, row2;
    NSString *text;
    char dir, less, more;
    if (axis == 'H')  {middle=90;  less='S'; more='N';}
    else              {middle=180; less='E'; more='W';}
    if (value < 0)  {num = -value;  dir = less;}
    else            {num = value;   dir = more;}
    deg = (int)num;
    rem = fmod(num,1) + 0.00014;  // Round up to nearest sec
    row1 = (int)(rem * 60);
    row2 = (int)(rem * 3600) - row1*60;
    text = [NSString stringWithFormat:@"%d° %d' %d\" %c",
            deg,row1,row2,dir];
    //NSLog(@"LocationCell: getText: %d,%d,%d: %@",deg,row1,row2,text);
    return(text);
}
@end