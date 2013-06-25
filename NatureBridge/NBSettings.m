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

// Device Settings
static BOOL isPhone = NO;

// Application iPad Settings
static NSUserDefaults *settings;
static NSString *testMode;
static NSString *siteId;
static NSString *homeURL;
static NSDictionary *siteList;

// Site Configuration Fields
static NSDictionary *site;
static NSString *siteName;
static NSString *siteLabel = @"Site Unknown";
static NSString *testURL = @"http://test.fieldscope.org/api";
static NSString *productionURL = @"http://fieldscope.org/api";
static double minLatitude = 47;
static double maxLatitude = 49;
static double minLongitude = -125;
static double maxLongitude = -120;
static NSDictionary *projects;
static NSDictionary *sliders;

// Current Status Fields
static BOOL viewFlag;
static BOOL editFlag;

// Recent Station Names
static NSMutableArray *recentNames;

// Load Settings. This is the intializer for this class
+(void) load {
    NSString *model = [UIDevice currentDevice].model;
    if ([model hasPrefix:@"iPhone"]) {
        isPhone = YES;
        //NSLog(@"Model: is Phone");
    }
    //NSLog(@"NBSettings: load.");
    [self loadApplicationSettings];
    if ([self isSiteId]) {
        [self loadSiteSettings];
    }
    [self isLandscape];
}

// Get Device Type
+(BOOL) isPhone {
    return(isPhone);
}
// Get Device Orientation
+(BOOL) isLandscape {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if ( (orientation == UIDeviceOrientationLandscapeLeft) ||
        (orientation == UIDeviceOrientationLandscapeRight) ) {
        //NSLog(@"NBSettings: is Landscape.");
        return(YES);
    }return(NO);
}

// Get Standard Font for device
+(UIFont *) font {
    if (isPhone)
        return([UIFont boldSystemFontOfSize:14.0]);
    else
        return([UIFont boldSystemFontOfSize:22.0]);
}
// Get Text Input Font for device
+(UIFont *) textFont {
    if (isPhone)
        return([UIFont systemFontOfSize:16.0]);
    else
        return([UIFont systemFontOfSize:30.0]);
}
// Get List Cell Font for device
+(UIFont *) cellFont {
/*    NSLog(@"System Font Size: %f",[UIFont systemFontSize]);
    NSLog(@"Label Font Size: %f",[UIFont labelFontSize]);
    NSLog(@"Button Font Size: %f",[UIFont buttonFontSize]); 
 */
    if (isPhone)
        return([UIFont boldSystemFontOfSize:14.0]);
    else
        return([UIFont boldSystemFontOfSize:16.0]);
}
// Set the font for all Buttons in a View
+(void) setButtonFonts:(UIView *)view
{   //NSLog(@"setButtonFonts:");
    for (UIView *obj in [view subviews]) {
        //NSLog(@"%@", obj.class);
        if([obj isKindOfClass:[UIButton class]]) {
            ((UIButton *)obj).titleLabel.font = [self font];
        }
    }
}
// Set the size for all Buttons in a View
+(void) setButtonSize:(UIView *)view x:(double)x y:(double)y
{   //NSLog(@"setButtonSize: %f %f",x,w);
    for (UIView *obj in [view subviews]) {
        if([obj isKindOfClass:[UIButton class]]) {
            //NSLog(@"Button was: %@", obj);
            // Button setup (to keep text central during animation)
            CGRect old = obj.frame;
            double dw = old.size.width*(x-1);
            CGRect new = CGRectMake(old.origin.x-(dw/2), old.origin.y*y,
                                old.size.width+dw, old.size.height*y);
            obj.frame = new;
            //NSLog(@"Button is: %@", obj);
        }   }
}
// Set the font for all Labels in a View
+(void) setLabelFonts:(UIView *)view
{   //NSLog(@"setLabelFonts:");
    for (UIView *obj in [view subviews]) {
        if([obj isKindOfClass:[UILabel class]]) {
            //NSLog(@"%@", obj);
            ((UILabel *)obj).font = [self font];
        }
    }
}

// Load Application Settings from iPad/iPhone Settings
+ (void) loadApplicationSettings
{   //NSLog(@"NBSettings: loadApplicationSettings.");
    settings = [NSUserDefaults standardUserDefaults];
    [settings registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        @"Yes", @"testFlag", @"", @"siteId",
        @"http://naturebridge.org/datacollector/", @"homeURL", nil]];
    testMode = [settings stringForKey:@"testFlag"];
    siteId = [settings stringForKey:@"siteId"];
    homeURL = [settings stringForKey:@"homeURL"];
}
+(BOOL) isSiteId
{   if (!siteId) return NO;
    if ([siteId isEqualToString:@""]) return NO;
    return YES;
}
// Load SiteList from HomeURL/SiteList.plist
+(NSDictionary *) loadSiteList
{   //NSLog(@"NBSettings: loadSiteList.");
    // Read Site List from: HomeURL/SiteId.plist
    NSString *urlName = [[NSString alloc]
        initWithFormat:@"ProjectList.plist"];
    NSURL *url = [NSURL URLWithString:urlName];
    siteList = [NSDictionary dictionaryWithContentsOfURL:url];
    if (!siteList) {
        NSLog(@"dictionaryWithContentsOfURL Error");
        siteList = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Cancel", @"Cancel",
                    @"Glacia National Park", @"Glacia",
                    @"Olympic National Park", @"Olympic",
                    @"Prince William State Park", @"PRWI",
                    @"Yellowstone National Park", @"Yellowstone", nil]; }
    //NSLog(@"NBSettings: dumpSiteList:%@",[self dumpDictionary:siteList]);
    return(siteList);
}
// Get SiteSettings from HomeURL/SiteId.plist
+(void) getSiteSettings:(NSString *)siteId
{   //NSLog(@"NBSettings: getSiteSettings.");
    NSString *data; NSError *error;
    // Read Site Settings from: HomeURL/SiteId.plist
    NSString *urlName = [[NSString alloc]
        initWithFormat:@"%@%@.plist",homeURL,siteId];
    NSURL *url = [NSURL URLWithString:urlName];
    data = [NSString stringWithContentsOfURL:url
        encoding:NSUTF8StringEncoding error:&error];
    if (!data) {
        NSLog(@ "ReadFromURL: %@ Error: %@",url,
              [error localizedDescription]);
        return; }
    // Write Site Settings to: FileCache/SiteSettings.plist
    NSString *fileName = getFileName(@"SiteSettings.plist");
    if (![data writeToFile:fileName atomically:YES
                  encoding:NSUTF8StringEncoding error:&error]) {
        NSLog(@ "WriteToFile: %@ Error: %@",fileName,
              [error localizedDescription]);
        return;
    }
    [self getBackgroundImage:siteId];
    [settings setObject:siteId forKey:@"siteId"];
    [self loadSiteSettings];
}
// Get Background Image from HomeURL/SiteId.jpg
+(void) getBackgroundImage:(NSString *)siteId
{   //NSLog(@"NBSettings: getBackgroundImage.");
    NSData *data; NSError *error;
    // Read Background Image from: HomeURL/SiteId.jpg
    NSString *imageId = siteId;
    if ([NBSettings isPhone]) // If iPhone HomeURL/SiteId2.jpg
        imageId = [[NSString alloc] initWithFormat:@"%@2",siteId];
    NSString *urlName = [[NSString alloc]
        initWithFormat:@"%@%@.jpg",homeURL,imageId];
    NSURL *url = [NSURL URLWithString:urlName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    data = [NSURLConnection sendSynchronousRequest:request
        returningResponse:NULL error:&error];
    if (!data) {
        NSLog(@"ReadFromURL: %@ Error: %@",url,
              [error localizedDescription]);
        return; }
    // Write Background Image to: FileCache/Background.jpg
    NSString *fileName = getFileName(@"Background.jpg");
    if (![data writeToFile:fileName
                   options:NSDataWritingAtomic error:&error]) {
        NSLog(@ "WriteToFile: %@ Error: %@",fileName,
              [error localizedDescription]);
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
{   //NSLog(@"NBSettings: loadSiteSettings.");
    NSString *fileName = getFileName(@"SiteSettings.plist");
    site = [NSDictionary dictionaryWithContentsOfFile:fileName];
    if (!site) {
        NSLog(@"dictionaryWithContentsOfFile Error");
        return;}
    siteName = [site objectForKey:@"siteName"];
    siteLabel = [site objectForKey:@"siteLabel"];
    testURL = [site objectForKey:@"testURL"];
    productionURL = [site objectForKey:@"productionURL"];
    minLatitude = [(NSNumber *)[site objectForKey:@"minLatitude"] doubleValue];
    maxLatitude = [(NSNumber *)[site objectForKey:@"maxLatitude"] doubleValue];
    minLongitude = [(NSNumber *)[site objectForKey:@"minLongitude"]doubleValue];
    maxLongitude = [(NSNumber *)[site objectForKey:@"maxLongitude"] doubleValue];
    [self loadSiteArea];
    projects = [site objectForKey:@"projects"];
    sliders = [site objectForKey:@"sliders"];
    siteId = siteName;
    //[self dumpSiteSettings];
}
+(void) loadSiteArea { // Temporary till Project files updated
    if (minLatitude != 0.0) return;
    if ([siteName isEqualToString:@"Olympic"]) {
        minLatitude = 47;       maxLatitude = 49;
        minLongitude = -125;    maxLongitude = -122;
    } else if ([siteName isEqualToString:@"PRWI"]) {
        minLatitude = 37;       maxLatitude = 40;
        minLongitude = -80;     maxLongitude = -76;
    } else {
        minLatitude = -89.9997222;     maxLatitude = 89.9997222;
        minLongitude = -189.9997222;   maxLongitude = 189.9997222; }
}
+(void)dumpSiteSettings
{  NSLog(@"NBSettings: dumpSiteSettings:\nsiteName: %@\nsiteLabel: %@\n"\
          "testURL: %@\nproductionURL: %@\n"\
          "minLat:%f maxLat:%f\nminLon:%f maxLon:%f\n"\
          "dict: projects %@\ndict: sliders %@",
          siteName,siteLabel,testURL,productionURL,
          minLatitude,maxLatitude,minLongitude,maxLongitude,
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
+(NSString *) siteId {return(siteId);}
+(NSString *) siteLabel {return(siteLabel);}
+(NSString *) mode {
    if ([testMode isEqualToString:@"No"]) {
        return @"Production Mode";
    } else 
        return @"Test Mode";
}
+(NSString *) siteURL {
    if ([testMode isEqualToString:@"No"]) {
        return productionURL;
    } else 
        return testURL;
}
+(double) minLatitude {return(minLatitude);}
+(double) maxLatitude{return(maxLatitude);}
+(double) midLatitude {return((minLatitude+maxLatitude)/2);}
+(double) minLongitude{return(minLongitude);}
+(double) maxLongitude{return(maxLongitude);}
+(double) midLongitude{return((minLongitude+maxLongitude)/2);}
+(NSDictionary *) projects {return projects;}
+(NSDictionary *) sliderFields {return sliders;}
+(BOOL) isSlider:(NSString*)name {
    return([sliders valueForKey:name] != nil);
}
+(float) sliderInc:(NSString*)name {
    NSString *inc = [sliders valueForKey:name];
    return([inc floatValue]);
}
+(NSString*) round:(float)value for:(NSString*)name {
    NSString *inc = [sliders valueForKey:name];
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
+(BOOL) viewFlag {return viewFlag;}
+(void) setViewFlag:(BOOL)flag {viewFlag = flag;}
+(BOOL) editFlag {return editFlag;}
+(void) setEditFlag:(BOOL)flag {editFlag = flag;}

+(NSMutableArray *) getNames
{   //NSLog(@"NBSettings getNames");
    recentNames = [NSMutableArray arrayWithCapacity:20];
    NSString *fileName = getFileName(@"RecentStations.plist");
    [recentNames addObjectsFromArray:[NSArray arrayWithContentsOfFile:fileName]];
    //NSLog(@"NBSettings Names: %@",recentNames);
    return(recentNames);
}

+(void) addName:(NSString*)name
{   //NSLog(@"NBSettings addName: %@",name);
    if (recentNames == nil)
        recentNames = [self getNames];
    [recentNames removeObject:name];  //Remove old copy if exists
    if ([recentNames count] > 20)
        [recentNames removeLastObject];
    [recentNames insertObject:name atIndex:0];
    NSString *fileName = getFileName(@"RecentStations.plist");
    if (![recentNames writeToFile:fileName atomically:YES]) {
        NSLog(@ "WriteToFile: %@ Error",fileName);
    }
}

// Get FileName for Site Settings File
NSString *getFileName(NSString *name) {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(
        NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return([cacheDir stringByAppendingPathComponent:name]);
}
@end