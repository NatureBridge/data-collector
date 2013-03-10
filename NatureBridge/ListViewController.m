//
//  ListViewController.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
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
