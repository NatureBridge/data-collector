//
//  FSObservationData.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "FSTable.h"
#import "Observation.h"
#import "Field.h"
#import "ObservationData.h"

@interface FSObservationData : FSTable

+ (ObservationData *)findOrCreateFor:(Observation *)observation withField:(Field*)field;

@end
