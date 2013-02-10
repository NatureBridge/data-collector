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
            [log data:[NSString stringWithFormat:
                    @"Error: Response: %@",[error description]]];

        }
        [stationButton setTitle:@"Locations updated" forState:UIControlStateNormal];
        [log add:@"Locations updated"];
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
    toSend=[[FSObservations observations] count];
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
