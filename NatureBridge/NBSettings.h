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

@interface NBSettings: NSObject

+(void) load;
+(void) reset;

+(BOOL) isPhone;
+(BOOL) isLandscape;
+(UIFont *) font;
+(UIFont *) textFont;
+(UIFont *) cellFont;
+(void) setButtonFonts:(UIView *)view;
+(void) setButtonSize:(UIView *)view x:(double)x y:(double)y;
+(void) setLabelFonts:(UIView *)view;

+(void) loadApplicationSettings;
+(NSDictionary *) loadSiteList;
+(BOOL) isSiteId;
+(void) getSiteSettings:(NSString *)siteId;
+(void) getBackgroundImage:(NSString *)siteId;
+(void) loadSiteSettings;

+(NSString *) siteId;
+(NSString *) siteLabel;
+(NSString *) mode;
+(NSString *) siteURL;
+(double) minLatitude;
+(double) maxLatitude;
+(double) midLatitude;
+(double) minLongitude;
+(double) maxLongitude;
+(double) midLongitude;
+(NSDictionary *) projects;
+(NSDictionary *) sliderFields;
+(UIImage *) backgroundImage;

+(BOOL) isSlider:(NSString*)name;
+(float) sliderInc:(NSString*)name;
+(NSString*) round:(float)value for:(NSString*)name;
+(int) decPlacesIn:(NSString*)string;
+(BOOL) viewFlag;
+(void) setViewFlag:(BOOL)flag;
+(BOOL) editFlag;
+(void) setEditFlag:(BOOL)flag;

+(NSMutableArray *) getNames;
+(void) addName:(NSString*)name;

@end