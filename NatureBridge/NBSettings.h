//
//  NBSettings.h
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
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
