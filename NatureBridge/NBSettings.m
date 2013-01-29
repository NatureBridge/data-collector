//
//  NBSettings.m
//  NatureBridge
//
//  Created by Richard F Emmett on 1/27/13.
//  Copyright (c) 2013 Richard F Emmett. All rights reserved.
//

#import "NBSettings.h"

@implementation NBSettings

static NSMutableDictionary *sliderFields;

+(void) initialize {
    sliderFields = [[NSMutableDictionary alloc] initWithCapacity:20];
    [sliderFields setValue:@"5" forKey:@"CanopyCover"];
    [sliderFields setValue:@"5" forKey:@"CloudCover"];
    [sliderFields setValue:@"5" forKey:@"DissolvedOxygenSaturation"];
    [sliderFields setValue:@"50" forKey:@"LakeDepth"];
    [sliderFields setValue:@"0.25" forKey:@"WaterVelocity"];
    [sliderFields setValue:@"0.5" forKey:@"Nitrate"];
    [sliderFields setValue:@"0.5" forKey:@"Nitrites"];
    //NSLog(@"NBSettings: init: %@",sliderFields);
}
+(void) load{
    
}
+(NSDictionary *) sliderFields{
    return sliderFields;
}
+(bool) isSlider:(NSString*)name{
    if ([sliderFields valueForKey:name] == nil)
        return(false);
    return(true);
}
+(float) sliderInc:(NSString*)name{
    NSString *inc = [sliderFields valueForKey:name];
    return([inc floatValue]);
}
+(NSString*) round:(float)value for:(NSString*)name {
    //NSLog(@"NBSettings: round:%f for:%@",value,name);
    NSString *inc = [sliderFields valueForKey:name];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:[self decPlacesIn:inc]];
    [formatter setRoundingIncrement:[NSNumber numberWithFloat:[inc floatValue]]];
    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
    //NSLog(@"NBSettings: round:%f inc:%@ str:%@",value,inc,string);
    return(string);
}
+(int)decPlacesIn:(NSString*)string {
    int dp = 0;
	for(int i=0;i<string.length;i++)
		if([string characterAtIndex:i] == '.')
            dp = string.length - i - 1;
    //NSLog(@"NBSettings: decPlaceIn:%@ %i",string,dp);
    return(dp);
}
@end
