//
//  RootViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/23/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "RootViewController.h"
#import "InitialSetupNavigationController.h"
#import "HomeNavViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    UIViewController *presentedVC = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FSProject"]) {
        presentedVC = [[HomeNavViewController alloc] init];
    } else {
        presentedVC = [[InitialSetupNavigationController alloc] init];
    }
    [self presentViewController:presentedVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
