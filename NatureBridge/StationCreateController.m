//
//  StationCreateController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 3/10/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "StationCreateController.h"
#import "FSProjects.h"
#import "FSStations.h"
#import "FSStore.h"
#import "LocationCell.h"
#import "NBSettings.h"
#import "NBGeoLocation.h"
#import "NBRange.h"

@interface StationCreateController ()

@end

@implementation StationCreateController

static double lat = 0; //89.0 +59.0/60 + 59.0/3600;    //21.0 +22.0/60 + 23.0/3600;
static double lon = 0; //179.0 +59.0/60 + 59.0/3600;   //(31.0 +32.0/60 + 33.0/3600);

@synthesize popupVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{   //NSLog(@"StationCreateVC: viewDidLoad.");
    [super viewDidLoad];
    [[self navigationItem] setTitle:@"Create Location"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
        initWithTitle:@"Save" style:UIBarButtonItemStylePlain
        target:self action:@selector(onSave)];
    [[self navigationItem] setRightBarButtonItem:saveButton];
    locationField.titleLabel.textAlignment = NSTextAlignmentLeft;
    [locationField setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    UIImage *arrow = [UIImage imageNamed:@"arrow"];
    [locationField setImage:arrow forState:UIControlStateNormal];
    [locationField setImageEdgeInsets:UIEdgeInsetsMake(5,280,5,5)];
    // Call NBGeoLocation to try to get current location
    geoLocator = [[NBGeoLocation alloc] init];
    [geoLocator start:self];
}

#pragma mark - NBGeoLocationDelegate

// Pop Up Alert Message
-(void) alert:(NSString *)title msg:(NSString *)msg
{   //NSLog(@"StationCreateVC: Alert: %@ %@",title,msg);
    if (alert == nil) {
        alert = [[UIAlertView alloc] initWithTitle:title
                    message:msg delegate:self
                    cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else
       [alert setMessage:msg];
}
-(void) alert:(NSString *)msg
{   //NSLog(@"StationCreateVC: Alert: %@",msg);
        [alert setMessage:msg];
}
// Alert Dismissed by Button Click
- (void)alertView:(UIAlertView *)alertView
        clickedButtonAtIndex:(NSInteger)index
{   //NSLog(@"StationCreateVC: Alert clickedButtonAtIndex: %d",index);
    alert = nil;
    if (geoLocator)
        [geoLocator stop];
    geoLocator = nil;
}
// Return from NBGeoLocation
- (void) setGeoLocation:(double)newLat lon:(double)newLon
{   //NSLog(@"StationCreateVC: setGeoLocation: %f %f",lat,lon);
    lat = newLat; lon = newLon;
    if ((lat == 0) && (lon == 0)) {
        lat = [NBSettings midLatitude];
        lon = [NBSettings midLongitude];
    }NSString *text =
        [NBGeoLocation textLatitude:lat andLongitude:lon];
   [locationField setTitle:text forState:UIControlStateNormal];
}
#pragma mark - NBGeoLocationDelegate end.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onSave
{   // Verify New Location is within this Site
    if (![NBRange alertLatitude:lat andLongitude:lon])
        return;
    Station *station = [NSEntityDescription
        insertNewObjectForEntityForName:[FSStations tableName]
        inManagedObjectContext:[[FSStore dbStore] context]];
    [station setName:[nameField text]];
    [station setLatitude:lat andLongitude:lon];
    [station setProject:[FSProjects currentProject]];
    if([[station name] length] == 0) {
        [station setName:[NSString stringWithFormat:@"ø %@", [station prettyLocation]]];
    }
    [[FSStore dbStore] saveChanges];
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{   [textField resignFirstResponder];
    return YES;
}
// Edit Location Manually
- (IBAction) getLocation:(id)sender {
    //NSLog(@"StationCreateVC: getLocation");
    locationCell = [[LocationCell alloc] init];
    [locationCell getLocation:self toRect:locationField.frame
        curLat:lat curLon:lon];
}
#pragma mark - LocationCellDelegate
-(void) displayPopup:(FieldCell *)cell rect:(CGRect)rect
               arrow:(UIPopoverArrowDirection)direction
{   //NSLog(@"StationCreateVC: displayPopup.");
    popUpController=[[UIPopoverController alloc]
                     initWithContentViewController:popupVC];
    [popUpController presentPopoverFromRect:rect inView:self.view
                   permittedArrowDirections:direction animated:YES];
    popUpController.delegate=self;
    //NSLog(@"StationCreateVC: ViewController to set size");
    [popupVC load:cell];
}
-(void) dismissPopup
{   //NSLog(@"StationCreateVC:  dismissPopup.");
    [popUpController dismissPopoverAnimated:YES];
    popUpController = nil;
    //NSLog(@"StationCreateVC: dismissPopup done.");
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)sender
{   //NSLog(@"StationCreateVC: popoverControllerDidDismissPopover.");
}
-(void) setInputLocation:(double)newLat lon:(double)newLon
{   //NSLog(@"StationCreateVC: setInputLocation %f %f",newLat,newLon);
    lat = newLat;   lon = newLon;
    NSString *text =
        [NBGeoLocation textLatitude:newLat andLongitude:newLon];
    [locationField setTitle:text forState:UIControlStateNormal];
}
#pragma mark - LocationCellDelegate end.


@end
