//
//  StationsIndexViewController.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <UIKit/UIKit.h>
#import "PopupViewController.h"
#import "NBGeoLocation.h"
#import "LocationCell.h"

@class PopupViewController;

@interface StationsIndexViewController : UITableViewController
    <UIAlertViewDelegate, UIPopoverControllerDelegate,
    NBGeoLocationDelegate, LocationCellDelegate>
{
    UIBarButtonItem *recentButton;
    UIBarButtonItem *nearButton;
    UITextField *findInput;
    IBOutlet PopupViewController *popupVC;
    UIPopoverController *popUpController;
    UIAlertView *alert;
    NBGeoLocation *geoLocator;
    LocationCell *locationCell;
}
@property NSArray *stations;
@property (retain, nonatomic) PopupViewController *popupVC;

- (IBAction) doRecent;

@end
