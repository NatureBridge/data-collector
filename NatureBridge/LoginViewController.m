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
    if (!([[usernameField text] length] > 0 && [[passwordField text] length] > 0)) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[usernameField text] forKey:@"FSUsername"];
    
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
    
    FSLogin *connection = [[FSLogin alloc] initWithBlock:onLogin username:[usernameField text] password:[passwordField text]];
    [connection start];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
