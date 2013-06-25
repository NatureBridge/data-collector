//
//  ObservationViewController.h
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
#import "Observation.h"
#import "FieldCell.h"

@class PopupViewController;

@interface ObservationViewController : UITableViewController <UIPopoverControllerDelegate>
{
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *saveButton;
    UIBarButtonItem *backButton;
    UIBarButtonItem *editButton;

    IBOutlet PopupViewController *popupVC;
    UIPopoverController *popUpController;
    
    Observation *observation;
    NSArray *fieldGroups;
    NSMutableDictionary *fieldsFromFieldGroups;
}

@property (retain, nonatomic) PopupViewController *popupVC;

- (id) initWithObservation:(Observation *)observation;

-(void) displayPopup:(FieldCell *)cell rect:(CGRect)rect
               arrow:(UIPopoverArrowDirection)direction;
-(void) dismissPopup;

@end
