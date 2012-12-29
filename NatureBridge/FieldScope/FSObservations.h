//
//  FSObservations.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTable.h"
#import "Observation.h"
#import "Station.h"

@interface FSObservations : NSObject <FSTable>

+ (Observation *) createObservation:(Station *)station;

@end
