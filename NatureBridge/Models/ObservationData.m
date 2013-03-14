//
//  ObservationData.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
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
