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
#import "Observation.h"
#import "FieldCell.h"

@class NumericPadViewController;
@class ListViewController;

@interface ObservationViewController : UITableViewController
    <UIPopoverControllerDelegate>
{
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *saveButton;
    UIBarButtonItem *backButton;
    UIBarButtonItem *editButton;
    
    IBOutlet NumericPadViewController *numPad;
    IBOutlet ListViewController *listPad;
    UIPopoverController *popUpController;
    UIButton *curButton;
    FieldCell *curCell;
    
    Observation *observation;
    NSArray *fieldGroups;
    NSMutableDictionary *fieldsFromFieldGroups;
}

@property (retain, nonatomic) NumericPadViewController *numPad;
@property (retain, nonatomic) ListViewController *listPad;

- (id) initWithObservation:(Observation *)observation;

-(void) loadNumPad:(UIButton *)sender cell:(FieldCell *)cell;
-(void) loadListPad:(UIButton *)button cell:(FieldCell *)cell list:(NSArray *)options;

@end
