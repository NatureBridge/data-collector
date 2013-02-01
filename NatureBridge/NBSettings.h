//
//  NBSettings.h
//  NatureBridge
//
//  Created by Richard F Emmett on 1/27/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBSettings : NSObject

+(void) load;
+(NSDictionary *) sliderFields;
+(bool) isSlider:(NSString*)name;
+(float) sliderInc:(NSString*)name;
+(NSString*) round:(float)value for:(NSString*)name;
+(int)decPlacesIn:(NSString*)string;

@end
