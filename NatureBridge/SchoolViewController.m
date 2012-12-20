//
//  SchoolViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/19/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "SchoolViewController.h"
#import "ProjectsIndexViewController.h"

@interface SchoolViewController ()

@end

@implementation SchoolViewController

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
    [[self navigationItem] setTitle:@"School"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction) doContinueButton
{
    ProjectsIndexViewController *projectVC = [[ProjectsIndexViewController alloc] init];
    [[self navigationController] pushViewController:projectVC animated:YES];
}

@end
