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

@interface ObservationViewController : UITableViewController
    <UIPopoverControllerDelegate>
{
    IBOutlet NumericPadViewController *numPad;
    UIPopoverController *numPadController;
    UIButton *curButton;
    FieldCell *curCell;
    
    Observation *observation;
    NSArray *fieldGroups;
    NSMutableDictionary *fieldsFromFieldGroups;
}

@property (retain, nonatomic) NumericPadViewController *numPad;

- (id) initWithObservation:(Observation *)observation;

- (void)loadNumPad:(UIButton *)sender cell:(FieldCell *)cell;

@end
