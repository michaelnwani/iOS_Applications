//
//  KMNAppDelegate.m
//  Nerdfeed
//
//  Created by Michael Nwani on 9/13/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNAppDelegate.h"
#import "KMNCoursesViewController.h"
#import "KMNWebViewController.h"

@implementation KMNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    KMNCoursesViewController *cvc = [[KMNCoursesViewController alloc] init];
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    KMNWebViewController *wvc = [[KMNWebViewController alloc] init];
    cvc.webViewController = wvc;

    self.window.rootViewController = masterNav;
    
    // Override point for customization after application launch.
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
