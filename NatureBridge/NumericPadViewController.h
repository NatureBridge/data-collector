//
//  NumericPadViewController.h
//  NatureBridge
//
//  Created by Richard F Emmett on 1/23/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NumericPadViewController : UIViewController {
    IBOutlet UILabel *result;
    NSMutableString *value;
}
-(IBAction) d0:(id *)sender;
-(IBAction) d1:(id *)sender;
-(IBAction) d2:(id *)sender;
-(IBAction) d3:(id *)sender;
-(IBAction) d4:(id *)sender;
-(IBAction) d5:(id *)sender;
-(IBAction) d6:(id *)sender;
-(IBAction) d7:(id *)sender;
-(IBAction) d8:(id *)sender;
-(IBAction) d9:(id *)sender;
-(IBAction) minus:(id *)sender;
-(IBAction) point:(id *)sender;
-(IBAction) back:(id *)sender;
-(IBAction) save:(id *)sender;

@property (nonatomic,retain) UILabel *result;
@property (nonatomic,retain) NSMutableString *value;
@end
