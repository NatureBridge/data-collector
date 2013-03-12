//
//  HomeNavViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/5/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
