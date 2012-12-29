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

NSString * const instructorKey = @"FSInstructor";
NSString * const schoolNameKey = @"FSSchoolName";

@implementation SchoolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"School"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    [[NSUserDefaults standardUserDefaults] setObject:self->instructorField.text forKey:instructorKey];
    [[NSUserDefaults standardUserDefaults] setObject:self->schoolField.text forKey:schoolNameKey];
    
    ProjectsIndexViewController *projectVC = [[ProjectsIndexViewController alloc] init];
    [[self navigationController] pushViewController:projectVC animated:YES];
}

@end
