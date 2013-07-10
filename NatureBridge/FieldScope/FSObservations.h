//
//  FSObservations.h
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

@interface FSObservations : FSTable
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
    int statusCode;
}

@property (nonatomic, copy) NSMutableURLRequest *request;
@property (nonatomic, copy) FSLoggingHandler completionBlock;
@property Observation *observation;

- (id)initWithBlock:(FSLoggingHandler)block observation:(Observation *)observation;
- (void)start;

+ (Observation *) createObservation:(Station *)station;
+ (void) deleteObservation:(Observation *)observation;
+ (void) deleteAll;

+ (NSArray *) observations;
+ (void)upload:(FSLoggingHandler)block;

@end
