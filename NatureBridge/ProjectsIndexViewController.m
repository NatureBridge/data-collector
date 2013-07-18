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
#import "NBLog.h"

#import "FSObservations.h"



@interface ProjectsIndexViewController ()

@end

NSString * const projectKey = @"FSProject";

@implementation ProjectsIndexViewController

static NSDictionary *siteList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        void (^onProjectLoad)(NSError *error) =
        ^(NSError *error) {
            if (error)
                NSLog(@"ProjectsIndexVC: error: %@", error);
        };
        [FSProjects load:onProjectLoad];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *projectBtn = [[UIBarButtonItem alloc] initWithTitle:@"Project  >"
        style:UIBarButtonItemStylePlain
        target:self action:@selector(newSiteId)];
    [[self navigationItem] setRightBarButtonItem:projectBtn];
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
// Request Site ID from pop-up ActionSheet List
- (void) getSiteId
{   //NSLog(@"ProjectIndexVC: getSiteId.");
    UIAlertView *alertView;
	alertView = [[UIAlertView alloc]
        initWithTitle:@"Please Select the Project." message:nil
        delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    siteList = [NBSettings loadSiteList];
    NSString *siteName;
    for (siteName in [siteList allValues]) {
        [alertView addButtonWithTitle:siteName]; }
	[alertView show];
}
// Accept Site ID Input and get Site Settings
- (void) alertView:(UIAlertView *)alert
        clickedButtonAtIndex:(NSInteger)buttonIndex
{   //NSLog(@"ProjectIndexVC: buttonClick: %d",buttonIndex);
    if (buttonIndex > siteList.count-1) {
        [self getSiteId]; return; } // Try again
    NSString *siteId = [[siteList allKeys] objectAtIndex:buttonIndex];
    //NSLog(@"ProjectIndexVCs: buttonClick: %@",siteId);
    [NBSettings getSiteSettings:siteId];
    if ([NBSettings isSiteId]) {    // Success load Projects for Site
        void (^onProjectLoad)(NSError *error) = ^(NSError *error) {
            if (error)
                NSLog(@"ProjectsIndexVC: error: %@", error);
        };
        [FSProjects load:onProjectLoad];
        [self.tableView reloadData];
    } else {
        [self getSiteId]; // Try again
    }
}
// Request New Site ID from pop-up ActionSheet List - FUTURE
- (void) newSiteId
{   //NSLog(@"ProjectIndexVC: newSiteId.");
    //NSLog(@"Delete Observations.");
    [FSObservations deleteAll];
    //NSLog(@"Delete Projects.");
    [FSProjects deleteAll];
    //NSLog(@"Reset Transmit Log.");
    [NBLog reset];
    //NSLog(@"Reset Settings.");
    [NBSettings reset];
    [self getSiteId];
}
@end
