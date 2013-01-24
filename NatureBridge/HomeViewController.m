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
#import "NumericPadViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize numPad;

-(IBAction) loadNumPad:(id)sender {
    button = (UIButton *)sender;
    NSString *text = button.titleLabel.text;
    if (text == nil) text = @"";
    NSLog(@"Caller: loadNumPad: %@",text);
    if (numPad.value == nil)
        numPad.value = [[NSMutableString alloc]initWithCapacity:10];
    [numPad.value setString:text];
    numPad.result.text = text;
    if (numPadController == nil) {
        numPadController=[[UIPopoverController alloc]
                          initWithContentViewController:numPad];
        [numPadController presentPopoverFromRect:[sender frame] inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        numPadController.delegate=self;
    }
}
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)sender {
    NSString *text = [[NSString alloc] initWithString:numPad.value];
    NSLog(@"Caller: dismissNumPad: %@",text);
    [button setTitle:text forState:UIControlStateNormal];
    numPadController = nil;
}


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
    [projectLabel setText:[@"Current Project: " stringByAppendingString:[[FSProjects currentProject] label]]];
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
