//
//  ObservationData.m
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import "ObservationData.h"
#import "Field.h"
#import "Observation.h"


@implementation ObservationData

@dynamic stringValue;
@dynamic observation;
@dynamic field;

- (NSString *)value
{
    return [self stringValue];
}
@end
