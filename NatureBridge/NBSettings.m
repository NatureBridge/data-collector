//
//  NBSettings.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/27/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//

#import "NBSettings.h"

@implementation NBSettings

static BOOL viewFlag;
static BOOL editFlag;

static NSMutableDictionary *sliderFields;

+(void) initialize
{
    sliderFields = [[NSMutableDictionary alloc] initWithCapacity:20];
    
    [sliderFields setValue:@"5" forKey:@"CanopyCover"];
    [sliderFields setValue:@"5" forKey:@"CloudCover"];
    [sliderFields setValue:@"5" forKey:@"DissolvedOxygenSaturation"];
    [sliderFields setValue:@"50" forKey:@"LakeDepth"];
    [sliderFields setValue:@"0.1" forKey:@"WaterVelocity"];
    [sliderFields setValue:@"1" forKey:@"Nitrate"];
    [sliderFields setValue:@"0.1" forKey:@"Nitrites"];
    [sliderFields setValue:@"0.1" forKey:@"Precipitation"];
    [sliderFields setValue:@"1" forKey:@"RelativeHumidity"];
}

+ (NSDictionary*) initialDefaults
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Yes", @"testFlag",
            @"http://test.fieldscope.org/api", @"testURL",
            @"http://fieldscope.org/api", @"productionURL",
            nil];
}

+(void) load
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings registerDefaults:[self initialDefaults]];
}

+(NSString *) mode {
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"testFlag"] isEqualToString:@"No"]) {
        return @"Production Mode";
    } else {
        return @"Test Mode";
    }
}

+(NSString *) siteURL
{
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"testFlag"] isEqualToString:@"No"]) {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"productionURL"];
    } else {
        return [[NSUserDefaults standardUserDefaults] stringForKey:@"testURL"];
    }
}

+(NSDictionary *) sliderFields
{
    return sliderFields;
}

+(BOOL) isSlider:(NSString*)name
{
    return [sliderFields valueForKey:name] != nil;
}

+(float) sliderInc:(NSString*)name
{
    NSString *inc = [sliderFields valueForKey:name];
    return([inc floatValue]);
}

+(NSString*) round:(float)value for:(NSString*)name
{
    NSString *inc = [sliderFields valueForKey:name];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:[self decPlacesIn:inc]];
    [formatter setRoundingIncrement:[NSNumber numberWithFloat:[inc floatValue]]];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    return string;
}

+(int)decPlacesIn:(NSString*)string
{
    int dp = 0;
	for(int i=0;i<string.length;i++) {
		if([string characterAtIndex:i] == '.') {
            dp = string.length - i - 1;
        }
    }
    return(dp);
}

+(BOOL) viewFlag
{
    return viewFlag;
}

+(void) setViewFlag:(BOOL)flag
{
    viewFlag = flag;
}

+(BOOL) editFlag
{
    return editFlag;
}

+(void) setEditFlag:(BOOL)flag
{
    editFlag = flag;
}
@end
