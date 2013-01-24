//
//  HomeViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/5/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NumericPadViewController;

@interface HomeViewController : UIViewController
    <UIPopoverControllerDelegate>
{
    IBOutlet UILabel *warningLabel;
    IBOutlet UILabel *projectLabel;
    IBOutlet NumericPadViewController *numPad;
    UIPopoverController *numPadController;
    UIButton *button;  // Save button to return value
}
@property (retain, nonatomic) NumericPadViewController *numPad;

- (IBAction) doAddButton;
- (IBAction) doEditButton;
- (IBAction) doChangeProjectButton;
- (IBAction) doTransmitButton;
- (void) updateWarning;
-(IBAction) loadNumPad:(id)sender;

@end
