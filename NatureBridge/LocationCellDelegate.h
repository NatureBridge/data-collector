//
//  LocationCellDelegate.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//
#import <Foundation/Foundation.h>
#import "FieldCell.h"

@protocol LocationCellDelegate <NSObject>

// Define Required Methods
@required

-(UIView *) view;

-(void) displayPopup:(FieldCell *)cell rect:(CGRect)rect
               arrow:(UIPopoverArrowDirection)direction;

-(void) dismissPopup;

-(void) setInputLocation:(double)newLat lon:(double)newLon;

// Define Optional Methods
@optional

@end