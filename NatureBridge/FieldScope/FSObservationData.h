//
//  FSObservationData.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 1/6/13.
//  Copyright (c) 2013 Alex Volkovitsky. All rights reserved.
//

#import "FSTable.h"
#import "Observation.h"
#import "Field.h"
#import "ObservationData.h"

@interface FSObservationData : FSTable

+ (ObservationData *)findOrCreateFor:(Observation *)observation withField:(Field*)field;

@end
