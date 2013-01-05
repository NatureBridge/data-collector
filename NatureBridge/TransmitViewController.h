//
//  TransmitViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/5/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface TransmitViewController : UIViewController
{
    IBOutlet UILabel *warningLabel;
    IBOutlet UILabel *errorLabel;
    IBOutlet UIButton *stationButton;
    IBOutlet UIButton *observationButton;
}

- (void) updateWarning;

- (IBAction)doStationUpdate;
- (IBAction)doObservationUpdate;

@end
