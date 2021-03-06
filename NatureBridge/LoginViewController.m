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
#import "NBSettings.h"

@interface LoginViewController ()

@end

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
        style:UIBarButtonItemStylePlain target:self
        action:@selector(doContinueButton)];
    [[self navigationItem] setRightBarButtonItem:nextButton];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
        style:UIBarButtonItemStylePlain target:self
        action:@selector(doBack)];
    [[self navigationItem] setLeftBarButtonItem:backButton];

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
    if (!([[usernameField text] length] > 0 && [[passwordField text] length] > 0)) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[usernameField text] forKey:@"FSUsername"];
    
    void (^onLogin)(NSError *, NSString *) =
    ^(NSError *error, NSString *response) {
        //NSLog(@"LoginViewController: Error: %@  Response: %@",error,response);
        UIActionSheet *actionSheet;
        if([response isEqualToString:@"Unauthorized"]) {
            actionSheet = [[UIActionSheet alloc]
                initWithTitle:@"Invalid Username and/or Password."
                delegate:self cancelButtonTitle:nil
                destructiveButtonTitle:@"OK" otherButtonTitles:nil];
        } else
            actionSheet = [[UIActionSheet alloc]
                initWithTitle:response
                delegate:self cancelButtonTitle:nil
                destructiveButtonTitle:nil otherButtonTitles:@"OK",nil];
        [actionSheet showInView:self.view];
        if (error) {
            NSLog(@"LoginVC: error: %@", error);
        }
    };
    
    FSLogin *connection = [[FSLogin alloc] initWithBlock:onLogin username:[usernameField text] password:[passwordField text]];
    [connection start];
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{  
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction) doBack {
    [[self navigationController] dismissViewControllerAnimated:YES
                                                    completion:nil];
}
@end
