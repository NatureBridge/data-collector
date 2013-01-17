//
//  InitialSetupNavigationController
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/12/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
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
