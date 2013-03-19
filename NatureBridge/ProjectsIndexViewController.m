//
//  ProjectsIndexViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "ProjectsIndexViewController.h"
#import "FSProjects.h"
#import "FSStore.h"
#import "FSConnection.h"
#import "NBSettings.h"

@interface ProjectsIndexViewController ()

@end

NSString * const projectKey = @"FSProject";

@implementation ProjectsIndexViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        void (^onProjectLoad)(NSError *error) =
        ^(NSError *error) {
            NSLog(@"error: %@", error);
        };
        [FSProjects load:onProjectLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NBSettings load];
    if (![NBSettings isSiteId]) {
        [self getSiteId];
    }
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[FSStore dbStore] allProjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Project *project = [[[FSStore dbStore] allProjects] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[project label]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [headerView bounds].size.height;
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
    Project *project = [[[FSStore dbStore] allProjects] objectAtIndex:[indexPath row]];
    [[NSUserDefaults standardUserDefaults] setObject:project.name forKey:projectKey];
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

// Request  ID from pop-up Alert
- (void) getSiteId
{
    UIAlertView *alertDialog;
	alertDialog = [[UIAlertView alloc] initWithTitle:@"Please Enter the Site ID."
                                             message:@"\nYou won't see me." delegate:self
                                   cancelButtonTitle: @"OK" otherButtonTitles:nil];
    userInput=[[UITextField alloc] initWithFrame:
               CGRectMake(20.0, 60.0, 240.0, 25.0)];
    [userInput setBackgroundColor:[UIColor whiteColor]];
    [alertDialog addSubview:userInput];
	[alertDialog show];
}

// Accept Site ID Input and get Site Settings
- (void) alertView:(UIAlertView *)alert
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *siteId = userInput.text;
    [NBSettings getSiteSettings:siteId];
    if ([NBSettings isSiteId]) {    // Success load Schemas
        void (^onProjectLoad)(NSError *error) =
        ^(NSError *error) {
            NSLog(@"error: %@", error);
        };
        [FSProjects load:onProjectLoad];
        [self.tableView reloadData];
    } else {
        [self getSiteId]; // Try again
    }
    
}
@end
