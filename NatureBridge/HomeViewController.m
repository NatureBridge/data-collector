//
//  HomeViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "HomeViewController.h"
#import "TransmitViewController.h"
#import "StationsIndexViewController.h"
#import "StationCreateController.h"
#import "ObservationsIndexViewController.h"
#import "ProjectsIndexViewController.h"
#import "FSProjects.h"
#import "FSObservations.h"
#import "FSStore.h"
#import "NBSettings.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // NOTE: This may be obsolete see: ProjectsIndexViewController
    // Do Projects Schema load
    void (^onProjectLoad)(NSError *error) =
    ^(NSError *error) {
        NSLog(@"HomeVC: error: %@", error);
    };
    [FSProjects load:onProjectLoad];
    
    // NOTE: This may be obsolete see: ProjectsIndexViewController
    // Do any additional setup after loading the view from its nib.
    if([[[FSProjects currentProject] stations] count] > 0) {
        [self updateWarning];
    } else {
        void (^onObservationLoad)(NSError *error) =
        ^(NSError *error) {
            if (error) {
                NSLog(@"HomeVC: error: %@", error);
            } else if([[[FSProjects currentProject] stations] count] > 0) {
                [self updateWarning];
            }
        };
        [FSObservations load:onObservationLoad];
    }
    
    // Scale Text Font
    [NBSettings setButtonFonts:self.view];
    if ([NBSettings isPhone])
        [NBSettings setButtonSize:self.view x:1.6 y:1.2];
    modeLabel.font = [NBSettings font];
    warningLabel.font = [NBSettings font];
    [modeLabel setText:[NBSettings mode]];
    backgroundImage.image = [NBSettings backgroundImage];
/*    float w = ARROW_WIDTH;
    if ([NBSettings isPhone]) w = w / 2;
    float x = projectButton.bounds.size.width - w;
    UIImage *arrow = [UIImage imageNamed:@"NBArrow"];
    [projectButton setImageEdgeInsets:UIEdgeInsetsMake(0, x, 0, 0)];
    [projectButton setImage:arrow forState:UIControlStateNormal];
*/  projectButton.titleLabel.font = [NBSettings font];
    projectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [projectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    NSLog(@"HomeVC: study: %@",[[FSProjects currentProject] label]);
    [projectButton setTitle:[NSString stringWithFormat:@"Study: %@",
            [[FSProjects currentProject] label]] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doAddButton
{
    [NBSettings setViewFlag:NO];
    [[self navigationController] pushViewController:[[StationsIndexViewController alloc] init] animated:YES];
}

- (void)doStationAddButton
{
    [[self navigationController] pushViewController:[[StationCreateController alloc] init] animated:YES];
}

- (void)doEditButton
{
    [NBSettings setViewFlag:YES];
    [[self navigationController] pushViewController:[[ObservationsIndexViewController alloc] init] animated:YES];
}

- (void)doChangeProjectButton
{
    [[self navigationController] pushViewController:[[ProjectsIndexViewController alloc] init] animated:YES];
}

- (void )doTransmitButton
{
    [[self navigationController] pushViewController:[[TransmitViewController alloc] init] animated:YES];
}

- (void) updateWarning
{
    [warningLabel setText:@""];
}

@end
