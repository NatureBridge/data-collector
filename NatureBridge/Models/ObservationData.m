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
@dynamic numberValue;
@dynamic observation;
@dynamic field;

- (NSString *)value
{
    if ([[[self field] type] isEqualToString:@"Number"]) {
        return [NSString stringWithFormat:@"%@", [self numberValue]];
    } else {
        return [self stringValue];
    }
}
@end
