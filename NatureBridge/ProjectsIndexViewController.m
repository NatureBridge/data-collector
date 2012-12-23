//
//  ProjectsIndexViewController.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/19/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "ProjectsIndexViewController.h"

@interface ProjectsIndexViewController ()

@end

@implementation ProjectsIndexViewController

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
    // Do any additional setup after loading the view from its nib.
    [dbStore loadProjects];
    NSLog(@"Loaded %d projects", [dbStore->allProjects count]);
    [[self navigationItem] setTitle:@"Projects"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
