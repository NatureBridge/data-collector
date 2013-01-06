//
//  TransmitViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/5/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "TransmitViewController.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import "FSStations.h"
#import "FSObservations.h"
#import "FSConnection.h"

@interface TransmitViewController ()

@end

@implementation TransmitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Field Scope"];
    }
    return self;
}

-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];

    if ([reach isReachable]) {
        [self updateWarning];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"fieldscope.org"];
    
    // set the blocks
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    if([FSConnection authenticated]) {
        [authenticationLabel setText:@"Logged in"];
        [loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateWarning
{
    [warningLabel setText:@"Please select an action. This will connect to the FieldScope server."];
    [warningLabel setTextColor:[UIColor darkGrayColor]];
}

- (void)doLogin
{
    if([FSConnection authenticated]) {
        //doLogout
    } else {
        [[self navigationController] pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
}

- (void)doStationUpdate
{
    [stationButton setTitle:@"Updating..." forState:UIControlStateNormal];
    void (^onStationLoad)(NSError *error) =
    ^(NSError *error) {
        if (error) {
            [errorLabel setText:[error description]];
        }
        [stationButton setTitle:@"Stations updated" forState:UIControlStateNormal];
    };
    [FSStations load:onStationLoad];
}

- (void)doObservationUpdate
{
    [observationButton setTitle:@"Updating..." forState:UIControlStateNormal];
    void (^onObservationUpload)(NSError *error) =
    ^(NSError *error) {
        if (error) {
            [errorLabel setText:[error description]];
        }
        [observationButton setTitle:@"Observations uploaded" forState:UIControlStateNormal];
    };
    [FSObservations upload:onObservationUpload];
}

@end
