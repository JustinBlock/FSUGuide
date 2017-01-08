//
//  AppDelegate.m
//  FSUGuide
//
//  Created by Justin Block on 6/15/16.
//  Copyright © 2016 Justin Block. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "UIColor+FSUGuideColors.h"
#import "MainTabBarViewController.h"

#define TAB_INDEX_FOR_EXPLORE_FSU_PAGE 1
#define TAB_INDEX_FOR_PROFILE_PAGE 3

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Initialize Parse.
    [Parse enableLocalDatastore];
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"INSERT-APPLICATION-ID";
        configuration.server = @"INSER-SERVER-URL";
        configuration.clientKey = @"INSERT-CLIENT-KEY";
    }]];
    
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:0.33 green:0.00 blue:0.08 alpha:0.9]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // If already done onboarding go to home page
    if([defaults boolForKey:@"isOnboardingComplete"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
        self.window.rootViewController = viewController;
    }
    // Otherwise show onboarding
    else {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"StepOne"];
        self.window.rootViewController = viewController;
    }
    
    return YES;
}

/*
    Sets the background color for the status bar
 
    Credits: https://stackoverflow.com/questions/19063365/how-to-change-the-status-bar-background-color-and-text-color-on-ios-7
*/
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma Notifications
/*
    When a local notification is recieved
*/
- (void) application:(UIApplication *)application didReceiveLocalNotification: (UILocalNotification *)notification
{
    // If the app is active show a popup
    if([application applicationState] == UIApplicationStateActive) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:notification.alertTitle
                                                                       message:notification.alertBody
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
        
        [alert addAction:okAction];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    // If the app was in the background
    else {
        // Show the Profile page for the orientation time
        if([notification.alertTitle isEqualToString:@"Orientation Reminder"]) {
            // Hides the current viewController (incase the popup happens when the app had another window ontop like a webview etc while it was in the background)
            [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
            MainTabBarViewController *tab = (MainTabBarViewController *)self.window.rootViewController;
            tab.selectedIndex = TAB_INDEX_FOR_PROFILE_PAGE;
        }
        // Show the Explore FSU tab
        else if([notification.alertTitle isEqualToString:@"Explore FSU Reminder"]) {
            // Hides the current viewController (incase the popup happens when the app had another window ontop like a webview etc while it was in the background)
            [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
            MainTabBarViewController *tab = (MainTabBarViewController *)self.window.rootViewController;
            tab.selectedIndex = TAB_INDEX_FOR_EXPLORE_FSU_PAGE;
        }
    }
}

@end
