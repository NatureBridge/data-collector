//
//  HomeNavViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "HomeNavViewController.h"
#import "HomeViewController.h"

@interface HomeNavViewController ()

@end

@implementation HomeNavViewController

- (id) init
{
    return [super initWithRootViewController:[[HomeViewController alloc] init]];
}

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
- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{   NSLog(@"HomeNavVC: pushVC: %@",viewController.class);
    [super pushViewController:viewController animated:animated];
    [self setNavBar];
}
- (UIViewController *) popViewControllerAnimated:(BOOL)animated
{   NSLog(@"HomeNavVC: popVC: %@",self.visibleViewController.class);
    UIViewController *popViewController = [super popViewControllerAnimated:animated];
    [self setNavBar];
    return(popViewController);
}
- (void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{   NSLog(@"HomeNavVC: dismissVC: %@",self.visibleViewController.class);
    [super dismissViewControllerAnimated:flag completion:completion];
    [self setNavBar];
}
- (void) setNavBar
{   NSLog(@"HomeNavVC: setNavBar: %@",self.visibleViewController.class);
    if ([self.visibleViewController.class isSubclassOfClass:HomeViewController.class])
        [self setNavigationBarHidden:YES];
    else
        [self setNavigationBarHidden:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
