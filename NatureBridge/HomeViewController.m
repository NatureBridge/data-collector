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
#import "FSProjects.h"
#import "FSObservations.h"
#import "FSStore.h"
#import "NBSettings.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    [modeLabel setText:[NBSettings mode]];
    
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
    float x = projectButton.bounds.size.width - ARROW_WIDTH;
    UIImage *arrow = [UIImage imageNamed:@"NBArrow"];
    [projectButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, x, 0.0, 0.0)];
    [projectButton setImage:arrow forState:UIControlStateNormal];
    projectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [projectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -x, 0, 5)];
    [projectButton setTitle:[[FSProjects currentProject] label]
                   forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doAddButton
{
    [NBSettings setViewFlag:NO];
    [[self navigationController] pushViewController:[[StationsIndexViewController alloc] init] animated:YES];
}

- (void)doEditButton
{
    [NBSettings setViewFlag:YES];
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
    [warningLabel setText:@""];
}

@end
