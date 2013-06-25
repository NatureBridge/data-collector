//
//  StationsIndexViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "StationsIndexViewController.h"
#import "ObservationViewController.h"
#import "Station.h"
#import "FSProjects.h"
#import "FSObservations.h"
#import "LocationCell.h"
#import "NBGeoLocation.h"
#import "NBSettings.h"

@interface StationsIndexViewController ()

@end

@implementation StationsIndexViewController

static bool recent;
static bool near;
static NSArray *nameIndex;
static NSArray *allStations;
static NSArray *recentStations;

@synthesize stations;
@synthesize popupVC;

- (id)initWithStyle:(UITableViewStyle)style
{   //NSLog(@"StationsIndexVC initWithStyle");
    self = [super initWithStyle:style];
    // Sort All Stations to Name sequence
    [[self navigationItem] setTitle:@"Locations"];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    allStations = [[[FSProjects currentProject] stations]
        sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
    // Create All Stations Search Index
    NSMutableArray *index  =  [NSMutableArray arrayWithCapacity:26];
    char nc, sc = 'A';
    [index addObject:[[NSString alloc] initWithFormat:@"%c",sc]];
    NSInteger row=99;
    for (row=0; row<allStations.count; row++) {
        nc = [[[allStations objectAtIndex:row] name] characterAtIndex:0];
        if (nc > sc) {
            sc = nc;
            [index addObject:[[NSString alloc] initWithFormat:@"%c",sc]];
    }   }
    nameIndex = [[NSArray alloc] initWithArray:index];
    // Get Recent Stations in Name sequence
    NSMutableArray *recents = [NSMutableArray arrayWithCapacity:20];
    NSArray *names = [NBSettings getNames];
    int np=0, nm = [names count];
    if (nm > 0) {
        names = [names sortedArrayUsingSelector:@selector(compare:)];
        NSString *name = [names objectAtIndex:0];
        for (Station *station in allStations) {
            if ([[station name] isEqualToString:name]) {
                    [recents addObject:station];
                    np++; if (np >= nm) break;
                    name = [names objectAtIndex:np];
    }   }   }
    recentStations = [[NSArray alloc] initWithArray:recents];
    return self;
}
- (void)viewDidLoad
{   //NSLog(@"StationsIndexVC viewDidLoad");
    [super viewDidLoad];
    recentButton = [[UIBarButtonItem alloc] initWithTitle:@"All >"
        style:UIBarButtonItemStylePlain target:self action:@selector(doRecent)];
    nearButton = [[UIBarButtonItem alloc] initWithTitle:@"Name >"
        style:UIBarButtonItemStylePlain target:self action:@selector(doNear)];
    NSArray *rightButtons = [NSArray arrayWithObjects:recentButton,nearButton,nil];
    [[self navigationItem] setRightBarButtonItems:rightButtons];
    recent = false;
    near = false;
    self.stations = allStations;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self stations] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    Station *station = [[self stations] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[station name]];
    [[cell detailTextLabel] setText:[station prettyLocation]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (near) return(nil);
    if (recent) return(nil);
    return(nameIndex);
}
#pragma mark - Table view data source end
                      
#pragma mark - Table view delegate

// Find Section selected by the index
- (NSInteger)tableView:(UITableView *)tableView
        sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{   //NSLog(@"StationsIndexVC: sectionIndex: %@ %d",title,index);
    [self performSelector:@selector(doFind:)
               withObject:title afterDelay:0.1];	//Secs
    return(0);
}
// Row Selected - Create Observation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     [
     *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    Station *station =  [[self stations] objectAtIndex:[indexPath row]];
    [NBSettings addName:[station name]];
    Observation *observation = [FSObservations createObservation:station];
    [[self navigationController] pushViewController:[[ObservationViewController alloc]
        initWithObservation:observation] animated:YES];
}
#pragma mark - Table View Delegates End

// Find Row that starts with and scroll to it. 
- (void) doFind:(NSString *)start
{   //NSLog(@"StationsIndexVC doFind: %@",start);
    NSInteger row=99;
    Station *station;
    for (row=0; row<stations.count; row++) {
        station = [stations objectAtIndex:row];
        if ([[station name] compare:start] > 0) break;
    }NSInteger section=0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [[self tableView] scrollToRowAtIndexPath:indexPath
        atScrollPosition:UITableViewScrollPositionTop animated:false];
}
// Request Display: All/Recent Stations
- (IBAction) doRecent
{   //NSLog(@"StationsIndexVC doRecent/All");
    if (recent) {
        recent = false;
        [recentButton setTitle:@"All  >"];
        self.stations = allStations;
    } else {
        recent = true;
        [recentButton setTitle:@"Recent  >"];
        self.stations = recentStations;
    }
    [[self tableView] reloadData];
}

// Request Display: Name/Near sorted Stations
- (IBAction) doNear
{   //NSLog(@"StationsIndexVC doNear/Name");
    if (near) {
        near = false;
        [nearButton setTitle:@"Name >"];
        // Sort Stations by Name
        [self sortStations];
    } else {
        near = true;
        [nearButton setTitle:@"Near >"];
        // Call NBGeoLocation to get current location
        geoLocator = [NBGeoLocation alloc];
        [geoLocator start:self];
    }
}

#pragma mark - NBGeoLocationDelegate

// Pop Up Alert Message
-(void) alert:(NSString *)title msg:(NSString *)msg
{   //NSLog(@"StationsIndexVC: Alert: %@ %@",title,msg);
    if (alert == nil) {
        alert = [[UIAlertView alloc] initWithTitle:title
                message:msg delegate:self
                cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else
        [alert setMessage:msg];
}
-(void) alert:(NSString *)msg
{   //NSLog(@"StationsIndexVC: Alert: %@",msg);
    [alert setMessage:msg];
}
// Alert Dismissed by Button Click
- (void)alertView:(UIAlertView *)alertView
        clickedButtonAtIndex:(NSInteger)index
{   //NSLog(@"StationsIndexVC: Alert clickedButtonAtIndex: %d",index);
    alert.hidden = YES;
    alert = nil;
    if (geoLocator)
        [geoLocator stop];
    geoLocator = nil;
}
// Return from NBGeoLocation
-(void) setGeoLocation:(double)newLat lon:(double)newLon;
{   //NSLog(@"StationIndexVC: setGeoLocation: %f %f",newLat,newLon);
    if ((newLat != 0) || (newLon != 0)) {   // GeoLocation success
        CLLocation *location = [[CLLocation alloc]
                initWithLatitude:newLat longitude:newLon];
        [Station setCurLocation:location];
        [self sortStations];    //Sort stations by Near
    } else { // Geo Location failed
        // Allow time for Alert to disappear.
        [self performSelector:@selector(goManual:)
                   withObject:nil afterDelay:0.2];
    }
}
#pragma mark - NBGeoLocationDelegate end.

// Request Current Location Manually
-(void) goManual:(NSString *)msg
{   //NSLog(@"StationIndexVC: goManual %@",nearButton.customView);
    locationCell = [[LocationCell alloc] init];
    [locationCell getLocation:self toRect:CGRectMake(620,0,50,1)
        curLat:[NBSettings midLatitude] curLon:[NBSettings midLongitude]];
}

#pragma mark - LocationCellDelegate
-(void) displayPopup:(FieldCell *)cell rect:(CGRect)rect
               arrow:(UIPopoverArrowDirection)direction
{   //NSLog(@"StationsIndexVC: displayPopup.");
    popUpController=[[UIPopoverController alloc]
                     initWithContentViewController:popupVC];
    [popUpController presentPopoverFromRect:rect inView:self.view
                   permittedArrowDirections:direction animated:YES];
    popUpController.delegate=self;
    //NSLog(@"StationsIndexVC: ViewController to set size");
    [popupVC load:cell];
}
-(void) dismissPopup
{   //NSLog(@"StationsIndexVC:  dismissPopup.");
    [popUpController dismissPopoverAnimated:YES];
    popUpController = nil;
    //NSLog(@"StationsIndexVC: dismissPopup done.");
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)sender
{   //NSLog(@"StationIndexVC: popoverControllerDidDismissPopover.");
}
-(void) setInputLocation:(double)newLat lon:(double)newLon;
{   //NSLog(@"StationIndexVC: setInputLocation: %f %f",newLat,newLon);
    CLLocation *location = [[CLLocation alloc]
            initWithLatitude:newLat longitude:newLon];
    [Station setCurLocation:location];
    [self sortStations];    //Sort stations by Near
}
#pragma mark - LocationCellDelegate done.

// Sort Stations by name or distance
- (void) sortStations
{   //NSLog(@"StationsIndexVC sortStations.");
    NSString *key = @"name";
    if (near) key = @"distance";
    //NSLog(@"StationsIndexVC sortStations: %@ %d",key,recent);
    NSSortDescriptor *sortKey = [NSSortDescriptor alloc];
    sortKey = [sortKey initWithKey:key ascending:YES];
    // Sort All Stations
    allStations = [allStations
        sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortKey]];
    // Sort Recent Stations
    recentStations = [recentStations
        sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortKey]];
    // Redisplay the Table View
    if (recent) self.stations = recentStations;
    else        self.stations = allStations;
    [[self tableView] reloadData];
    // Scroll to top if have rows
    if (self.stations.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //NSLog(@"StationsIndexVC scroll to top: %@",indexPath);
        [[self tableView] scrollToRowAtIndexPath:indexPath
            atScrollPosition:UITableViewScrollPositionTop animated:false];
    }
}
@end
