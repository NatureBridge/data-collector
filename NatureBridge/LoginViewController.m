//
//  LoginControllerViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/18/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "LoginViewController.h"
#import "SchoolViewController.h"

@interface LoginViewController ()

@end

NSString * const usernameKey = @"FSUsername";
NSString * const passwordKey = @"FSPassword";

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[self navigationItem] setTitle:@"Login"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    [[NSUserDefaults standardUserDefaults] setObject:self->usernameField.text forKey:usernameKey];
    [[NSUserDefaults standardUserDefaults] setObject:self->passwordField.text forKey:passwordKey];
    
    SchoolViewController *projectVC = [[SchoolViewController alloc] init];
    [[self navigationController] pushViewController:projectVC animated:YES];
}

@end
