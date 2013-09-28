//
//  APAppDelegate.m
//  AppPartnerTest
//
//  Created by Xiaonan Wang on 7/2/13.
//  Copyright (c) 2013 Xiaonan Wang. All rights reserved.
//
NSString *const AppPartnerSessionStateChangedNotification = @"AppPartnerTest:AppPartnerSessionStateChangedNotification";

#import "APAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>


@implementation APAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //for facebook picture
    [FBProfilePictureView class];
    
    // change the style of navigation bar
    UIImage *navBackgroundImage = [UIImage imageNamed:@"header.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIImage *navBackImage = [[UIImage imageNamed:@"headerbutton_back_off.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    
    UIImage *pressBackImage = [[UIImage imageNamed:@"headerbutton_back_on.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 6)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:navBackImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:pressBackImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    UIColor *red = [UIColor redColor];
    [[UIBarButtonItem appearance] setTintColor:red];
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBSession.activeSession handleOpenURL:url];
    //return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

@end
