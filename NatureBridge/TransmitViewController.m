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
#import "FSLogout.h"

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
    log = [[NBLog alloc] init];
    [log create:textView name:@"TRANSMIT LOG"];
    
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"fieldscope.org"];
    
    // set the blocks
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];

    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    
    if([FSConnection authenticated]) {
        [authenticationLabel setText:[@"Logged in as: " stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"FSUsername"]]];
        [authenticationLabel setTextColor:[UIColor darkGrayColor]];
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
        void (^onLogout)(NSError *, NSString *) =
        ^(NSError *error, NSString *response) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:response
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:@"Ok"
                                                            otherButtonTitles:nil];
            [actionSheet showInView:self.view];
            
            if (error) {
                NSLog(@"error: %@", error);
            } else {
                [FSConnection destroySessionCookie];
            }
        };
        FSLogout *connection = [[FSLogout alloc] initWithBlock:onLogout];
        [connection start];
    } else {
        [[self navigationController] pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [authenticationLabel setText:@"Not Authenticated"];
    [authenticationLabel setTextColor:[UIColor redColor]];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
}

- (void)doStationUpdate
{
    [log header:@"Update Locations"];
    [stationButton setTitle:@"Updating..." forState:UIControlStateNormal];
    void (^onStationLoad)(NSError *error) = ^(NSError *error) {

        if (error) {
            [errorLabel setText:[error description]];
            [log error:[error description]];
        }
        [stationButton setTitle:@"Locations updated" forState:UIControlStateNormal];
        [log add:@"Locations updated"];
    };
    [FSStations load:onStationLoad];

}
// Ugh... there has GOT to be a better way of doing this... too tired to figure it out
NSUInteger count = 0;

- (void)doObservationUpdate
{
    [log header:@"Update Observations"];
    if ([[FSObservations observations] count] < 1) {
        [observationButton setTitle:@"Nothing to Upload" forState:UIControlStateNormal];
        [log add:@"Nothing to Upload"];
        return;
    }
    
    [observationButton setTitle:@"Updating..." forState:UIControlStateNormal];
    count = 0;
    FSLoggingHandler onObservationUpload =
    ^(NSString *name, NSError *error, NSString *response) {
        [log add:name];
        if (error) {
            [errorLabel setText:[error description]];
            [log error:[error description]];
        } else {
            count++;
        }
        if (response) {
            [errorLabel setText:response];
            [log response:response];
        }
        [observationButton setTitle:[NSString stringWithFormat:@"%d Observations Uploaded", count] forState:UIControlStateNormal];
        [log add:[NSString stringWithFormat:@"%d Observations Uploaded", count]];
    };
    [FSObservations upload:onObservationUpload];
}
@end
