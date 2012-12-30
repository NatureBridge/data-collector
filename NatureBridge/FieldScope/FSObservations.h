//
//  FSObservations.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/29/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "FSTable.h"
#import "Observation.h"

@interface FSObservations : FSTable

+ (Observation *) createObservation:(Station *)station;
+ (void) deleteObservation:(Observation *)observation;

@end
