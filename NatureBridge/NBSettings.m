//
//  NBSettings.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/27/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//

#import "NBSettings.h"

@implementation NBSettings

static NSString *testFlag = @"Yes";
static NSString *testURL = @"http://test.fieldscope.org/api";
static NSString *productionURL = @"http://test.fieldscope.org/api";

static bool viewFlag;
static bool editFlag;


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
+ (NSDictionary*) initialDefaults {
    NSArray *keys = [[NSArray alloc] initWithObjects:
        @"testFlag", @"testURL", @"productionURL", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:
        @"Yes", @"http://test.fieldscope.org/api",
        @"http://fieldscope.org/api", nil];
    return [[NSDictionary alloc] initWithObjects:values forKeys:keys];
}
+(void) load
{   NSLog(@"Settings: load.");
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings registerDefaults:[self initialDefaults]];
    testFlag = [settings stringForKey:@"testFlag"];
    testURL = [settings stringForKey:@"testURL"];
    productionURL = [settings stringForKey:@"productionURL"];
    NSLog(@"Settings: %@\n\t%@\n\t%@",testFlag,testURL,productionURL);
}
+(NSString *) mode {
    if ([testFlag isEqualToString:@"No"])
        return(@"Production Mode");
    else
        return(@"Test Mode");
}
+(NSString *) siteURL {
    if ([testFlag isEqualToString:@"No"])
        return(productionURL);
    else
        return(testURL);
}
+(NSDictionary *) sliderFields{
    return sliderFields;
}
+(BOOL) isSlider:(NSString*)name {
    if ([sliderFields valueForKey:name] == nil) {
        return NO;
    }
    return YES;
}
+(float) sliderInc:(NSString*)name {
    NSString *inc = [sliderFields valueForKey:name];
    return([inc floatValue]);
}
+(NSString*) round:(float)value for:(NSString*)name {
    NSString *inc = [sliderFields valueForKey:name];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:[self decPlacesIn:inc]];
    [formatter setRoundingIncrement:[NSNumber numberWithFloat:[inc floatValue]]];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    return string;
}
+(int)decPlacesIn:(NSString*)string {
    int dp = 0;
	for(int i=0;i<string.length;i++) {
		if([string characterAtIndex:i] == '.') {
            dp = string.length - i - 1;
        }
    }
    return(dp);
}
+(BOOL) viewFlag {
    return viewFlag;
}
+(void) setViewFlag:(BOOL)flag {
    viewFlag = flag;
}
+(BOOL) editFlag {
    return editFlag;
}
+(void) setEditFlag:(BOOL)flag {
    editFlag = flag;
}
@end
