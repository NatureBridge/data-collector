//
//  ObservationsIndexViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "ObservationsIndexViewController.h"
#import "StationsIndexViewController.h"
#import "ObservationViewController.h"
#import "FSStore.h"
#import "FSProjects.h"
#import "Observation.h"
#import "Station.h"

@interface ObservationsIndexViewController ()

@end

@implementation ObservationsIndexViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Observations"];
        
        // Filter Stations that have Observations only
        NSSet *allStations = [[FSProjects currentProject] stations];
        NSMutableSet *hitStations = [NSMutableSet setWithCapacity:100];
        for (Station *station in allStations) {
            if ([[station observations] count] > 0) {
                [hitStations addObject:station];
                //NSLog(@"Station has Observation: %@",[station name]);
            }
        }
        // Continue with Filtered Stations
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        //stations = [[[FSProjects currentProject] stations] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
        stations = [hitStations sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]];
        observationsFromStations = [[NSMutableDictionary alloc] init];
        for (Station *station in stations) {
            NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"collectionDate" ascending:YES];
            NSArray *observations = [[station observations] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
            [observationsFromStations setObject:observations forKey:[station name]];
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
    //                                                              style:UIBarButtonItemStylePlain
    //                                                             target:self
    //                                                             action:@selector(onAddButtonClick)];
    //[[self navigationItem] setRightBarButtonItem:addButton];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [stations count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    Station *station = [stations objectAtIndex:section];
    return [[observationsFromStations objectForKey:[station name]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Station *station = [stations objectAtIndex:section];
    if ([[observationsFromStations objectForKey:[station name]] count] > 0) {
        return [station name];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell..
    Station *station = [stations objectAtIndex:[indexPath section]];
    Observation *observation = [[observationsFromStations objectForKey:[station name]] objectAtIndex:[indexPath row]];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *stringFromDate = [formatter stringFromDate:[observation collectionDate]];
    
    [[cell textLabel] setText:stringFromDate];
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
    Station *station = [stations objectAtIndex:[indexPath section]];
    Observation *observation = [[observationsFromStations objectForKey:[station name]] objectAtIndex:[indexPath row]];
    
    [[self navigationController] pushViewController:[[ObservationViewController alloc] initWithObservation:observation]
                                           animated:YES];
}

@end
