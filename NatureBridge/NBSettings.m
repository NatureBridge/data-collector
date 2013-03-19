//
//  NBSettings.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "NBSettings.h"

@implementation NBSettings

// Application iPad Settings
static NSUserDefaults *settings;
static NSString *testMode;
static NSString *siteId;
static NSString *homeURL;

// Site Configuration Fields
static NSDictionary *site;
static NSString *siteName;
static NSString *siteLabel = @"Site Unknown";
static NSString *testURL = @"http://test.fieldscope.org/api";
static NSString *productionURL = @"http://fieldscope.org/api";
static NSDictionary *projects;
static NSDictionary *sliders;

// Current Status Fields
static BOOL viewFlag;
static BOOL editFlag;

// Load Settings
+(void) load {
    //NSLog(@"NBSettings: load.");
    [self loadApplicationSettings];
    if ([self isSiteId]) {
        [self loadSiteSettings];
    }
}

// Load Application Settings from iPad Settings
+ (void) loadApplicationSettings
{
    settings = [NSUserDefaults standardUserDefaults];
    [settings registerDefaults:[NSDictionary
                                dictionaryWithObjectsAndKeys:
                                @"Yes", @"testFlag", @"", @"siteId",
                                @"http://naturebridge.org/datacollector/", @"homeURL", nil]];
    testMode = [settings stringForKey:@"testFlag"];
    siteId = [settings stringForKey:@"siteId"];
    homeURL = [settings stringForKey:@"homeURL"];
}

+(BOOL) isSiteId
{
    if (!siteId) return NO;
    if ([siteId isEqualToString:@""]) return NO;
    return YES;
}

// Get SiteSettings from HomeURL/SiteId.plist
+(void) getSiteSettings:(NSString *)siteId
{
    NSString *data; NSError *error;
    // Read Site Settings from: HomeURL/SiteId.plist
    NSString *urlName = [[NSString alloc]
                         initWithFormat:@"%@%@.plist",homeURL,siteId];
    NSURL *url = [NSURL URLWithString:urlName];
    data = [NSString stringWithContentsOfURL:url
                                    encoding:NSUTF8StringEncoding error:&error];
    if (!data) {
        NSLog(@ "ReadFromURL: Error: %@",[error localizedDescription]);
        return;
    }
    // Write Site Settings to: FileCache/Sitesettings.plist
    NSString *fileName = getFileName(@"SiteSettings.plist");
    if (![data writeToFile:fileName atomically:YES
                  encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@ "WriteToFile: Error: %@",[error localizedDescription]);
        return;
    }
    
    [self getBackgroundImage:siteId];
    [settings setObject:siteId forKey:@"siteId"];
    [self loadSiteSettings];
}

// Get Background Image from HomeURL/SiteId.jpg
+(void) getBackgroundImage:(NSString *)siteId
{
    NSData *data; NSError *error;
    // Read Background Image from: HomeURL/SiteId.jpg
    NSString *urlName = [[NSString alloc]
                         initWithFormat:@"%@%@.jpg",homeURL,siteId];
    NSURL *url = [NSURL URLWithString:urlName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    data = [NSURLConnection sendSynchronousRequest:request
                                 returningResponse:NULL error:&error];
    if (!data) {
        NSLog(@"ReadFromURL: Error: %@",[error localizedDescription]);
        return;
    }
    // Write Background Image to: FileCache/Background.jpg
    NSString *fileName = getFileName(@"Background.jpg");
    if (![data writeToFile:fileName
                   options:NSDataWritingAtomic error:&error]) {
        NSLog(@ "WriteToFile: Error: %@",[error localizedDescription]);
        return;
    }
}

+(UIImage *) backgroundImage
{
    NSString *fileName = getFileName(@"Background.jpg");
    return([UIImage imageWithContentsOfFile:fileName]);
}

// Load Site Settings from Cache File
+(void) loadSiteSettings
{
    NSString *fileName = getFileName(@"SiteSettings.plist");
    site = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (!site) {
        NSLog(@"dictionaryWithContentsOfFile Error");
        return;
    }
    siteName = [site objectForKey:@"siteName"];
    siteLabel = [site objectForKey:@"siteLabel"];
    testURL = [site objectForKey:@"testURL"];
    productionURL = [site objectForKey:@"productionURL"];
    projects = [site objectForKey:@"projects"];
    sliders = [site objectForKey:@"sliders"];
    siteId = siteName;
}

+(void)dumpSiteSettings
{
    NSLog(@"NBSettings: dumpSiteSettings:\nsiteName: %@\nsiteLabel: %@\n"\
          "testURL: %@\nproductionURL: %@\n"\
          "dict: projects %@\ndict: sliders %@",
          siteName,siteLabel,testURL,productionURL,
          [self dumpDictionary:projects],[self dumpDictionary:sliders]);
}

+(NSString *)dumpDictionary:(NSDictionary *) dictionary {
    NSMutableString *msg = [NSMutableString stringWithFormat:@"["];
    for (NSString *key in [dictionary allKeys]) {
        [msg appendFormat:@"\n\t{key:%@, obj:%@}",
         key,[dictionary objectForKey:key]];
    }
    [msg appendFormat:@" ]"];
    return(msg);
}

+(NSString *) siteId
{
    return(siteId);
}

+(NSString *) siteLabel
{
    return(siteLabel);
}

+(NSString *) mode
{
    if ([testMode isEqualToString:@"No"]) {
        return @"Production Mode";
    } else {
        return @"Test Mode";
    }
}

+(NSString *) siteURL
{
    if ([testMode isEqualToString:@"No"]) {
        return productionURL;
    } else {
        return testURL;
    }
}

+(NSDictionary *) projects
{
    return projects;
}

+(NSDictionary *) sliderFields
{
    return sliders;
}

+(BOOL) isSlider:(NSString*)name
{
    return([sliders valueForKey:name] != nil);
}

+(float) sliderInc:(NSString*)name
{
    NSString *inc = [sliders valueForKey:name];
    return([inc floatValue]);
}

+(NSString*) round:(float)value for:(NSString*)name
{
    NSString *inc = [sliders valueForKey:name];
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

// Get FileName for Site Settings File
NSString * getFileName(NSString *name)
{
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(
                                                              NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return([cacheDir stringByAppendingPathComponent:name]);
}
@end