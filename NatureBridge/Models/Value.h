//
//  Value.h
//  NatureBridge
//
//  Created by Alex Volkovitsky on 12/27/12.
//  Copyright (c) 2012 Alex Volkovitsky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Value : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSManagedObject *field;

@end
