//
//  ObservationViewController.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/30/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Station.h"

@interface ObservationViewController : UIViewController
{
    Station *station;
}

-(id) initWithStation:(Station *)station;

@end
