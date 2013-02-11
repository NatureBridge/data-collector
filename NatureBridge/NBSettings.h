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
+(NSString *) mode;
+(NSString *) siteURL;
+(NSDictionary *) sliderFields;
+(BOOL) isSlider:(NSString*)name;
+(float) sliderInc:(NSString*)name;
+(NSString*) round:(float)value for:(NSString*)name;
+(int) decPlacesIn:(NSString*)string;
+(BOOL) viewFlag;
+(void) setViewFlag:(BOOL)flag;
+(BOOL) editFlag;
+(void) setEditFlag:(BOOL)flag;

@end
