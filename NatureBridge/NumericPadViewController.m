//
//  NumericPadViewController.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/23/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "NumericPadViewController.h"
#import "NBRange.h"

@implementation NumericPadViewController

@synthesize valueFld;
@synthesize unitsFld;
@synthesize value;
@synthesize units;
@synthesize min;
@synthesize max;

- (void)viewDidLoad {
    //NSLog(@"NBNumPad: load: %@",value);
    valueFld.text = value;
    unitsFld.text = units;
    self.contentSizeForViewInPopover=CGSizeMake(380.0,300.0);
    [super viewDidLoad];
}
-(IBAction) digit0:(id *)sender {
    [value appendString:@"0"];
    valueFld.text = value;
}
-(IBAction) digit1:(id *)sender {
    [value appendString:@"1"];
    valueFld.text = value;
}
-(IBAction) digit2:(id *)sender {
    [value appendString:@"2"];
    valueFld.text = value;
}
-(IBAction) digit3:(id *)sender {
    [value appendString:@"3"];
    valueFld.text = value;
}
-(IBAction) digit4:(id *)sender {
    [value appendString:@"4"];
    valueFld.text = value;
}
-(IBAction) digit5:(id *)sender {
    [value appendString:@"5"];
    valueFld.text = value;
}
-(IBAction) digit6:(id *)sender {
    [value appendString:@"6"];
    valueFld.text = value;
}
-(IBAction) digit7:(id *)sender {
    [value appendString:@"7"];
    valueFld.text = value;
}
-(IBAction) digit8:(id *)sender {
    [value appendString:@"8"];
    valueFld.text = value;
}
-(IBAction) digit9:(id *)sender {
    [value appendString:@"9"];
    valueFld.text = value;
}
-(IBAction) minus:(id *)sender {
    //NSLog(@"NBNumPad: minus");
    if (value.length < 1) {
        [value setString:@"-"];
        valueFld.text = value;
    }
}
-(IBAction) point:(id *)sender {
    //NSLog(@"NBNumPad: point");
    if ([value rangeOfString:@"."].location == NSNotFound) {
        [value appendString:@"."];
        valueFld.text = value;
    }
}
-(IBAction) back:(id *)sender {
    //NSLog(@"NBNumPad: back: %i %@",value.length,value);
    if (value.length > 0) {
        [value setString:[value substringToIndex:(value.length-1)]];
        valueFld.text = value;
    }
}
-(IBAction) save:(id *)sender {
    //NSLog(@"NBNumPad: save: %@",value);
    if ([value length] > 0) {
        // Range Check Value
        NSNumber *number = [[NSNumber alloc] initWithFloat:[value floatValue]];
        if ( ! [NBRange check:number min:min  max:max])
            return; }
    // Dismiss Numeric Pad Pop Up
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
