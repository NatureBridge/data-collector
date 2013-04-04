//
//  TransmitViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "TransmitViewController.h"
#import "LoginViewController.h"
#import "Reachability.h"
#import "FSStations.h"
#import "FSObservations.h"
#import "FSConnection.h"
#import "FSLogout.h"
#import "NBSettings.h"

@implementation TransmitViewController

NSString *authenticatedMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"National Geographic FieldScope"];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    if ([NBSettings mode] != authenticatedMode) {
         [FSConnection destroySessionCookie];
    }
    
    if([FSConnection authenticated]) {
        [authenticationLabel setText:[@"Logged in as: " stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"FSUsername"]]];
        [authenticationLabel setTextColor:[UIColor darkGrayColor]];
        [loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
    
    [self updateButtons];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [NBLog archive];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateWarning
{
    [warningLabel setText:@"Please select an action. This will connect to National Geographic's FieldScope server."];
    [warningLabel setTextColor:[UIColor darkGrayColor]];
}

- (void)doLogin
{
    if ([FSConnection authenticated]) {
        void (^onLogout)(NSError *, NSString *) = ^(NSError *error, NSString *response) {
            NSLog(@"TransmitViewController:");
            if (error) {
                NSLog(@"error: %@", error);
            } else {
                [FSConnection destroySessionCookie];
                [authenticationLabel setText:@"Not Authenticated"];
                [authenticationLabel setTextColor:[UIColor redColor]];
                [loginButton setTitle:@"Login" forState:UIControlStateNormal];
            }
        };
        FSLogout *connection = [[FSLogout alloc] initWithBlock:onLogout];
        [connection start];
    } else {
        authenticatedMode = [NBSettings mode];
        [[self navigationController] presentModalViewController:[[LoginViewController alloc] init] animated:YES];
    }
    [self updateButtons];
}

- (void) updateButtons {
    BOOL authenticated = [FSConnection authenticated];
    [stationButton setEnabled:authenticated];
    [observationButton setEnabled:authenticated];
}

// Ugh... there has GOT to be a better way of doing this... too tired to figure it out
NSUInteger stationCount;
NSUInteger stationToSend;

- (void)doStationUpload
{
    log = [[NBLog alloc] init];
    [log create:@"TRANSMIT LOG" in:textView];
    [log header:@"Upload Locations"];
    stationToSend = [[FSStations stations] count];
    if (stationToSend < 1) {
        [log add:@"Nothing to Upload"];
        [log close];
        return;
    }
    stationCount = 0;
    FSLoggingHandler onStationUpload =
    ^(NSString *name, NSError *error, NSString *response) {
        [log add:name];
        if([response isEqualToString:@"Forbidden"]) {
            response = @"Invalid username and/or password.";
        }
        if (error) {
            [errorLabel setText:[error description]];
            [log data:[NSString stringWithFormat:
                       @"Error: HTTP Status: %d  Response: %@",[error code], response]];
        } else {
            [log data:[NSString stringWithFormat:
                       @"Success: HTTP Status: %d Response: %@",[error code], response]];
            stationCount++;
        }
        if (response) {
            [errorLabel setText:response];
        }
        stationToSend--;
        if (stationToSend < 1) {
            [log add:[NSString stringWithFormat:@"%d Locations Uploaded", stationCount]];
            [log close];
        }
    };
    [FSStations upload:onStationUpload];
}

- (void)doStationUpdate
{
    [self doStationUpload];     
    //[log header:@"Update Locations"];
    [stationButton setTitle:@"Updating..." forState:UIControlStateNormal];
    void (^onStationLoad)(NSError *error) = ^(NSError *error) {

        if (error) {
            [errorLabel setText:[error description]];
            [log data:[NSString stringWithFormat:
                    @"Error: Response: %@",[error description]]];

        }
        [stationButton setTitle:@"Locations updated" forState:UIControlStateNormal];
        //[log add:@"Locations updated"];
    };
    [FSStations load:onStationLoad];

}

// Ugh... there has GOT to be a better way of doing this... too tired to figure it out
NSUInteger count;
NSUInteger toSend;

- (void)doObservationUpdate
{
    log = [[NBLog alloc] init];
    [log create:@"TRANSMIT LOG" in:textView];
    [log header:@"Update Observations"];
    toSend = [[FSObservations observations] count];
    if (toSend < 1) {
        [observationButton setTitle:@"Nothing to Upload" forState:UIControlStateNormal];
        [log add:@"Nothing to Upload"];
        [log close];
        return;
    }
    [observationButton setTitle:@"Updating..." forState:UIControlStateNormal];
    count = 0; 
    FSLoggingHandler onObservationUpload =
                ^(NSString *name, NSError *error, NSString *response) {
        [log add:name];
        if (error) {
            [errorLabel setText:[error description]];
            if([response isEqualToString:@"Forbidden"])  {
                response = @"Invalid username and/or password."; }
            [log data:[NSString stringWithFormat:
                 @"Error: HTTP Status: %d  Response: %@",[error code], response]];
        } else {
            [log data:[NSString stringWithFormat:
                @"Success: HTTP Status: %d Response: %@",[error code], response]];
            count++;
        }
        if (response) {
            [errorLabel setText:response];
        }
        [observationButton setTitle:[NSString stringWithFormat:@"%d Observations Uploaded", count] forState:UIControlStateNormal];
        toSend--;
        if (toSend < 1) {
            [log add:[NSString stringWithFormat:@"%d Observations Uploaded", count]];
            [log close];
        }
    };
    [FSObservations upload:onObservationUpload];
}

- (void)doViewPastLogs
{
    if (log == nil) {
        log = [[NBLog alloc] init];
    }
    [log listLogs:self.view in:textView];
}
@end
