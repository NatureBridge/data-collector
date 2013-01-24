//
//  NumericPadViewController.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/23/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "NumericPadViewController.h"

@implementation NumericPadViewController

@synthesize result;
@synthesize value;

- (void)viewDidLoad {
    NSLog(@"NBNumPad: load: %@",value);
    result.text = value;
    self.contentSizeForViewInPopover=CGSizeMake(380.0,300.0);
    [super viewDidLoad];
}
-(IBAction) d0:(id *)sender {
    [value appendString:@"0"];
    result.text = value;
}
-(IBAction) d1:(id *)sender {
    [value appendString:@"1"];
    result.text = value;
}
-(IBAction) d2:(id *)sender {
    [value appendString:@"2"];
    result.text = value;
}
-(IBAction) d3:(id *)sender {
    [value appendString:@"3"];
    result.text = value;
}
-(IBAction) d4:(id *)sender {
    [value appendString:@"4"];
    result.text = value;
}
-(IBAction) d5:(id *)sender {
    [value appendString:@"5"];
    result.text = value;
}
-(IBAction) d6:(id *)sender {
    [value appendString:@"6"];
    result.text = value;
}
-(IBAction) d7:(id *)sender {
    [value appendString:@"7"];
    result.text = value;
}
-(IBAction) d8:(id *)sender {
    [value appendString:@"8"];
    result.text = value;
}
-(IBAction) d9:(id *)sender {
    [value appendString:@"9"];
    result.text = value;
}
-(IBAction) minus:(id *)sender {
    //NSLog(@"NBNumPad: minus");
    if (value.length < 1) {
        [value setString:@"-"];
        result.text = value;
    }
}
-(IBAction) point:(id *)sender {
    //NSLog(@"NBNumPad: point");
    if ([value rangeOfString:@"."].location == NSNotFound) {
        [value appendString:@"."];
        result.text = value;
    }
}
-(IBAction) back:(id *)sender {
    //NSLog(@"NBNumPad: back: %i %@",value.length,value);
    if (value.length > 0) {
        [value setString:[value substringToIndex:(value.length-1)]];
        result.text = value;
    }
}
-(IBAction) save:(id *)sender {
    NSLog(@"NBNumPad: save: %@",value);
    UIPopoverController *popUp = [self valueForKey:@"popoverController"];
    [popUp dismissPopoverAnimated:YES];
    [popUp.delegate popoverControllerDidDismissPopover:popUp];
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
}
@end
