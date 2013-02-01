//
//  TransmitViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/5/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLog.h"

@class Reachability;

@interface TransmitViewController : UIViewController <UIActionSheetDelegate>
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
