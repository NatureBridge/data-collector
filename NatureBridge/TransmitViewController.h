//
//  TransmitViewController.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <UIKit/UIKit.h>
#import "NBLog.h"

@class Reachability;

@interface TransmitViewController : UIViewController
{
    IBOutlet UILabel *warningLabel;
    IBOutlet UILabel *authenticationLabel;
    IBOutlet UILabel *errorLabel;
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *stationButton;
    IBOutlet UIButton *observationButton;
    IBOutlet UITextView *textView;
    NBLog *log;
}

- (void) updateWarning;
- (IBAction)doLogin;
- (IBAction)doStationUpdate;
- (IBAction)doObservationUpdate;
- (IBAction)doViewPastLogs;

@end
