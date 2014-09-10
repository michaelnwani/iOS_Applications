//
//  KMNAppDelegate.m
//  TouchTracker
//
//  Created by Michael Nwani on 9/9/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNAppDelegate.h"
#import "KMNDrawViewController.h"
#import "KMNDrawView.h"

@implementation KMNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    KMNDrawViewController *dvc = [[KMNDrawViewController alloc] init];
    
    self.window.rootViewController = dvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
 
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

@end
