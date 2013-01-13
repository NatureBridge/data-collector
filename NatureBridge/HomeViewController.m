//
//  HomeViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/5/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "HomeViewController.h"
#import "TransmitViewController.h"
#import "StationsIndexViewController.h"
#import "ObservationsIndexViewController.h"
#import "ProjectsIndexViewController.h"
#import "FSObservations.h"
#import "FSStore.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([[[FSStore dbStore] allStations] count] > 0) {
        [self updateWarning];
    } else {
        void (^onObservationLoad)(NSError *error) =
        ^(NSError *error) {
            if (error) {
                NSLog(@"error: %@", error);
            } else if([[[FSStore dbStore] allStations] count] > 0) {
                [self updateWarning];
            }
        };
        [FSObservations load:onObservationLoad];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doAddButton
{
    [[self navigationController] pushViewController:[[StationsIndexViewController alloc] init] animated:YES];
}

- (void)doEditButton
{
    [[self navigationController] pushViewController:[[ObservationsIndexViewController alloc] init] animated:YES];
}

- (void)doChangeProjectButton
{
    [[self navigationController] pushViewController:[[ProjectsIndexViewController alloc] init] animated:YES];
}

- (void )doTransmitButton
{
    [[self navigationController] pushViewController:[[TransmitViewController alloc] init] animated:YES];
}

- (void) updateWarning
{
    [warningLabel setText:@"You are ready to go into the field."];
    [warningLabel setTextColor:[UIColor darkGrayColor]];
}

@end
