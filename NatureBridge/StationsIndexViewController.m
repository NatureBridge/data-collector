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

@interface StationsIndexViewController ()

@end

@implementation StationsIndexViewController

@synthesize stations;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Locations"];
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        [self setStations:[[[FSProjects currentProject] stations]
                           sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *findButton = [[UIBarButtonItem alloc] initWithTitle:@"Find"
        style:UIBarButtonItemStylePlain target:self action:@selector(doFind)];
    [[self navigationItem] setRightBarButtonItem:findButton];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Station *station = [[self stations] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[station name]];
    [[cell detailTextLabel] setText:[station prettyLocation]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    Observation *observation = [FSObservations createObservation:[[self stations] objectAtIndex:[indexPath row]]];
    
    [[self navigationController] pushViewController:[[ObservationViewController alloc] initWithObservation:observation]
                                           animated:YES];
}
// Request Find Text from Pop-up Alert
- (IBAction) doFind {
    UIAlertView *alertDialog;
	alertDialog = [[UIAlertView alloc] initWithTitle:@"Please Enter Start Letters."
                                             message:@"\nYou won't see me." delegate:self
                                   cancelButtonTitle: @"OK" otherButtonTitles:nil];
    findInput=[[UITextField alloc] initWithFrame:
               CGRectMake(20.0, 60.0, 240.0, 25.0)];
    [findInput setBackgroundColor:[UIColor whiteColor]];
    [alertDialog addSubview:findInput];
	[alertDialog show];
}

// Accept Find Text and scroll the Table View
- (void) alertView:(UIAlertView *)alert
        clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *start = findInput.text;
    NSInteger row=99;
    Station *station;
    // Find first Station that start with find text
    for (row=0; row<stations.count; row++) {
        station = [stations objectAtIndex:row];
        if ([[station name] compare:start] > 0) break;
    }
    NSInteger section=0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [[self tableView] scrollToRowAtIndexPath:indexPath
        atScrollPosition:UITableViewScrollPositionTop animated:false];
}
@end
