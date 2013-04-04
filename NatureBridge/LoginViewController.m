//
//  LoginControllerViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "LoginViewController.h"
#import "FSLogin.h"

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

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction) doLogin
{
    if (!([[usernameField text] length] > 0 && [[passwordField text] length] > 0)) {
        return;
    }
    // Hide the keyboard
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    [[NSUserDefaults standardUserDefaults] setObject:[usernameField text] forKey:@"FSUsername"];
    
    void (^onLogin)(NSError *, NSString *) =
    ^(NSError *error, NSString *response) {
        if([response isEqualToString:@"Unauthorized"]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Invalid username and/or password."
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:@"Ok"
                                                            otherButtonTitles:nil];
            [actionSheet showInView:self.view];
            if (error) {
                NSLog(@"error: %@", error);
            }
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    };
    
    FSLogin *connection = [[FSLogin alloc] initWithBlock:onLogin username:[usernameField text] password:[passwordField text]];
    [connection start];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction) doCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
