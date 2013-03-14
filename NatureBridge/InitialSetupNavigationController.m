//
//  InitialSetupNavigationController
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "InitialSetupNavigationController.h"
#import "ProjectsIndexViewController.h"

@interface InitialSetupNavigationController ()

@end

@implementation InitialSetupNavigationController

- (id)init
{
    return [super initWithRootViewController:[[ProjectsIndexViewController alloc] init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
