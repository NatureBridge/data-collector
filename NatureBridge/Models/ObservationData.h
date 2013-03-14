//
//  ObservationData.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Field, Observation;

@interface ObservationData : NSManagedObject

@property (nonatomic, retain) NSString * stringValue;
@property (nonatomic, retain) Observation *observation;
@property (nonatomic, retain) Field *field;

- (NSString *)value;

@end
