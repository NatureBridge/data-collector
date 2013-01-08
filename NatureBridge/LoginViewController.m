//
//  LoginControllerViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/18/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "LoginViewController.h"
#import "FSLogin.h"

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
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Login"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doContinueButton)];
    [[self navigationItem] setRightBarButtonItem:nextButton];
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
    
    void (^onLogin)(NSError *, NSString *) =
    ^(NSError *error, NSString *response) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:response
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:@"Ok"
                                                        otherButtonTitles:nil];
        [actionSheet showInView:self.view];

        if (error) {
            NSLog(@"error: %@", error);
        }
    };
    
    [[FSLogin alloc] initWithBlock:onLogin];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
