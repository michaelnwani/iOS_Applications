//
//  KMNAppDelegate.m
//  Homepwner
//
//  Created by Michael Nwani on 9/7/14.
//  Copyright (c) 2014 Michael Nwani. All rights reserved.
//

#import "KMNAppDelegate.h"
#import "KMNItemsViewController.h"
#import "KMNItemStore.h"

NSString * const KMNNextItemValuePrefsKey = @"NextItemValue";
NSString * const KMNNextItemNamePrefsKey = @"NextItemName";

@implementation KMNAppDelegate

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"%@", NSStringFromSelector(_cmd)); //Very cool/helpful.
    
    //If state restoration did not occur, set up the view controller hierarchy
    if (!self.window.rootViewController)
    {
        //Create a KMNItemsViewController
        KMNItemsViewController *itemsViewController = [[KMNItemsViewController alloc] init];
        
        
        //Create an instance of a UINavigationController
        //its stack contains only itemsViewController
        UINavigationController *navController = [[UINavigationController alloc]
                                                 initWithRootViewController:itemsViewController];
        
        //Give the navigation controller a restoration identifier that is the same name as the class
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        
        //Place navigation controller's view in the window hierarchy
        self.window.rootViewController = navController;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    BOOL success = [[KMNItemStore sharedStore] saveChanges];
    if (success)
    {
        NSLog(@"Saved all of the KMNItems");
    }
    else
    {
        NSLog(@"Could not save any of the KMNItems");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    //Create a new navigation controller
    UIViewController *vc = [[UINavigationController alloc] init];
    
    //The last object in the path array is the restoration identifier for this view controller
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    if ([identifierComponents count] == 1)
    {
        //If there is only 1 identifier component, then this is the root view controller
        self.window.rootViewController = vc;
    }
    else
    {
        //Else, it is the navigation controller for a new item, so you need to set its modal presentation style
        //(we know this because the intermediate steps have been taken care of, ItemsViewController and DetailViewController
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    return vc;
}

//called automatically by the Obj-C runtime before the first instance of that class is created.
+(void)initialize
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *factorySettings = @{KMNNextItemValuePrefsKey : @75,
                                      KMNNextItemNamePrefsKey : @"Coffee Cup"};
    [defaults registerDefaults:factorySettings];
}

@end
