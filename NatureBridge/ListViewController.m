//
//  ListViewController.m
//  NatureBridge
//
//  Created by Richard F Emmett on 2/4/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//

#import "ListViewController.h"
#import "Value.h"

@interface ListViewController ()

@end

@implementation ListViewController

@synthesize text, value;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)load:(NSArray *)options {
    int len = options.count;
    optionLst = options;
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:self
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@""]; //Add Blank Option
    for (Value *option in options) {
        [actionSheet addButtonWithTitle:[option label]];
    }
    [actionSheet showInView:self.view];
    [actionSheet setBackgroundColor:[UIColor lightGrayColor]];
    self.contentSizeForViewInPopover=CGSizeMake(380.0,55.0*(len+1));
    value = @"";
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    text = @"";
    value=@"";
    if (buttonIndex > 0) {
        text = [[optionLst objectAtIndex:buttonIndex-1] label];
        value = [NSString stringWithFormat:@"%d",buttonIndex-1];
    }
    UIPopoverController *popUp = [self valueForKey:@"popoverController"];
    [popUp dismissPopoverAnimated:YES];
    [popUp.delegate popoverControllerDidDismissPopover:popUp];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
