//
//  HomeViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "HomeViewController.h"
#import "TransmitViewController.h"
#import "StationsIndexViewController.h"
#import "StationCreateController.h"
#import "ObservationsIndexViewController.h"
#import "ProjectsIndexViewController.h"
#import "FSProjects.h"
#import "FSObservations.h"
#import "FSStore.h"
#import "NBSettings.h"

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    initialized = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self continueSetup];
}

- (void) continueSetup
{
    if (![NBSettings isSiteId]) {
        [self getSiteId];
    } else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FSProject"]) {
        ProjectsIndexViewController *projectList = [[ProjectsIndexViewController alloc] init];
        projectList.onProjectSelected = ^() {
            [self continueSetup];
        };
        [[self navigationController] presentViewController:projectList animated:YES completion:nil];
    } else if (!initialized) {
        // NOTE: This may be obsolete see: ProjectsIndexViewController
        // Do Projects Schema load
        void (^onProjectLoad)(NSError *error) =
        ^(NSError *error) {
            NSLog(@"error: %@", error);
        };
        [FSProjects load:onProjectLoad];
        
        // NOTE: This may be obsolete see: ProjectsIndexViewController
        // Do any additional setup after loading the view from its nib.
        if([[[FSProjects currentProject] stations] count] > 0) {
            [self updateWarning];
        } else {
            void (^onObservationLoad)(NSError *error) =
            ^(NSError *error) {
                if (error) {
                    NSLog(@"error: %@", error);
                } else if([[[FSProjects currentProject] stations] count] > 0) {
                    [self updateWarning];
                }
            };
            [FSObservations load:onObservationLoad];
        }
        [modeLabel setText:[NBSettings mode]];
        backgroundImage.image = [NBSettings backgroundImage];
        float x = projectButton.bounds.size.width - ARROW_WIDTH;
        UIImage *arrow = [UIImage imageNamed:@"NBArrow"];
        [projectButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, x, 0.0, 0.0)];
        [projectButton setImage:arrow forState:UIControlStateNormal];
        projectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [projectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        NSLog(@"project %@",[[FSProjects currentProject] label]);
        [projectButton setTitle:[NSString stringWithFormat:@"Project: %@", [[FSProjects currentProject] label]] forState:UIControlStateNormal];
        initialized = YES;
    }
}

- (void)doAddButton
{
    [NBSettings setViewFlag:NO];
    [[self navigationController] pushViewController:[[StationsIndexViewController alloc] init] animated:YES];
}

- (void)doStationAddButton
{
    [[self navigationController] pushViewController:[[StationCreateController alloc] init] animated:YES];
}

- (void)doEditButton
{
    [NBSettings setViewFlag:YES];
    [[self navigationController] pushViewController:[[ObservationsIndexViewController alloc] init] animated:YES];
}

- (void)doChangeProjectButton
{
    ProjectsIndexViewController *projectList = [[ProjectsIndexViewController alloc] init];
    projectList.onProjectSelected = ^() {
        NSLog(@"project %@",[[FSProjects currentProject] label]);
        [projectButton setTitle:[NSString stringWithFormat:@"Project: %@", [[FSProjects currentProject] label]] forState:UIControlStateNormal];
    };
    [[self navigationController] presentViewController:projectList animated:YES completion:nil];
}

- (void )doTransmitButton
{
    [[self navigationController] pushViewController:[[TransmitViewController alloc] init] animated:YES];
}

- (void) updateWarning
{
    [warningLabel setText:@""];
}

// Request  ID from pop-up Alert
- (void) getSiteId
{
    UIAlertView *alertDialog;
	alertDialog = [[UIAlertView alloc] initWithTitle:@"Please Enter the Site ID."
                                             message:@"\nYou won't see me."
                                            delegate:self
                                   cancelButtonTitle: @"OK"
                                   otherButtonTitles:nil];
    userInput=[[UITextField alloc] initWithFrame:CGRectMake(20.0, 60.0, 240.0, 25.0)];
    [userInput setBackgroundColor:[UIColor whiteColor]];
    [alertDialog addSubview:userInput];
	[alertDialog show];
}

// Accept Site ID Input and get Site Settings
- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [userInput resignFirstResponder];
    NSString *siteId = userInput.text;
    [NBSettings getSiteSettings:siteId];
    if ([NBSettings isSiteId]) {    // Success load Schemas
        void (^onProjectLoad)(NSError *error) = ^(NSError *error) {
            NSLog(@"error: %@", error);
            [self continueSetup];
        };
        [FSProjects load:onProjectLoad];
        //[self.tableView reloadData];
    } else {
        [self getSiteId]; // Try again
    }
}

@end
