//
//  ObservationViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Observation.h"

@interface ObservationViewController : UITableViewController
{
    Observation *observation;
    NSArray *fieldGroups;
    NSMutableDictionary *fieldsFromFieldGroups;
}

-(id) initWithStation:(Station *)station;

@end
