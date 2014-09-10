//
//  KMNAppDelegate.m
//  HypnoNerd
//
//  Created by Michael Nwani on 9/6/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNAppDelegate.h"
#import "KMNHypnosisViewController.h"
#import "KMNReminderViewController.h"
#import "MNQuizViewController.h"

@implementation KMNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    KMNHypnosisViewController *hvc = [[KMNHypnosisViewController alloc] init];
    
    //This will get a pointer to an object that represents the app bundle
//    NSBundle *appBundle = [NSBundle mainBundle];
    
    //Look in the appBundle for the file KMNReminderViewController.xib
//    KMNReminderViewController *rvc = [[KMNReminderViewController alloc] initWithNibName:@"KMNReminderViewController" bundle:appBundle];
    KMNReminderViewController *rvc = [[KMNReminderViewController alloc] init];
    //By default, view controller's designated initializer's are initWithNibName:bundle:, which gets called by init, and passes nil for both arguments.
    //And when a view controller is initialized with nil as it's Nib name, it searches for a nib file with the same name as the class, "KMNReminderViewController", and the bundle searched automatically is the main application bundle.
    
    MNQuizViewController *qvc = [[MNQuizViewController alloc] init];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[hvc, rvc, qvc];
    self.window.rootViewController = tabBarController;
    
//    self.window.rootViewController = hvc; //activates the loadView method, ends up displaying hvc's UIView object full-window size.
    
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
