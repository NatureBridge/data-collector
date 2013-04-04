//
//  HomeViewController.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <UIKit/UIKit.h>

#define ARROW_WIDTH 20.0

@interface HomeViewController : UIViewController
{
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UILabel *warningLabel;
    IBOutlet UIButton *projectButton;
    IBOutlet UILabel *modeLabel;
    UITextField *userInput;
    BOOL initialized;
}
- (IBAction) doAddButton;
- (IBAction) doStationAddButton;
- (IBAction) doEditButton;
- (IBAction) doChangeProjectButton;
- (IBAction) doTransmitButton;
- (void) updateWarning;

@end
