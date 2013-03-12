//
//  NumericPadViewController.h
//  NatureBridge
//
//  Created by Richard F Emmett on 1/23/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface NumericPadViewController : UIViewController {
    IBOutlet UILabel *valueFld;
    IBOutlet UILabel *unitsFld;
    NSMutableString *value;
    NSString *units;
    NSNumber *min;
    NSNumber *max;
}
-(IBAction) digit0:(id *)sender;
-(IBAction) digit1:(id *)sender;
-(IBAction) digit2:(id *)sender;
-(IBAction) digit3:(id *)sender;
-(IBAction) digit4:(id *)sender;
-(IBAction) digit5:(id *)sender;
-(IBAction) digit6:(id *)sender;
-(IBAction) digit7:(id *)sender;
-(IBAction) digit8:(id *)sender;
-(IBAction) digit9:(id *)sender;
-(IBAction) minus:(id *)sender;
-(IBAction) point:(id *)sender;
-(IBAction) back:(id *)sender;
-(IBAction) save:(id *)sender;

@property (nonatomic,retain) UILabel *valueFld;
@property (nonatomic,retain) UILabel *unitsFld;
@property (nonatomic,retain) NSMutableString *value;
@property (nonatomic,retain) NSString *units;
@property (nonatomic,retain) NSNumber *min;
@property (nonatomic,retain) NSNumber *max;
@end
