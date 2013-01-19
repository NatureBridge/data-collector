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
{
    NSURLConnection *internalConnection;
    NSMutableData *container;
}

@property (nonatomic, copy) NSMutableURLRequest *request;
@property (nonatomic, copy) void (^completionBlock)(NSString *name, NSError *err, NSString *response);
@property Observation *observation;

- (id)initWithBlock:(void (^)(NSString *name, NSError *error, NSString *response))block observation:(Observation *)observation;
- (void)start;

+ (Observation *) createObservation:(Station *)station;
+ (void) deleteObservation:(Observation *)observation;

+ (NSArray *) observations;
+ (void)upload:(void (^)(NSString *name, NSError *error, NSString *response))block;

@end
