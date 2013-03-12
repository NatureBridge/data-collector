//
//  ObservationViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Observation.h"
#import "FieldCell.h"

@class NumericPadViewController;
@class ListViewController;

@interface ObservationViewController : UITableViewController
    <UIPopoverControllerDelegate>
{
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
