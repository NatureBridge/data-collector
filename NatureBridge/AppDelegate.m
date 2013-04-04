//
//  AppDelegate.m
//  NatureBridge
//
//  Copyright 2013 NatureBridge. All Rights Reserved.
//
//  Permission is granted to copy, distribute and/or modify this file under the
//  terms of the Open Software License v. 3.0 (OSL-3.0). You may obtain a copy of
//  the license at http://opensource.org/licenses/OSL-3.0
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "NBLog.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.rootViewController = navigationController;
    [_window makeKeyAndVisible];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [NBLog archive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [NBLog archive];
}

@end
