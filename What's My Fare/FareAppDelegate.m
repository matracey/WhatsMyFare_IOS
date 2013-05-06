//
//  FareAppDelegate.m
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FareAppDelegate.h"

@interface FareAppDelegate ()
@end

@implementation FareAppDelegate

- (NSArray *)styleKeys
{
    return @[@"font",@"color"];
}

- (NSDictionary *)style1
{
    return @{@"font": [UIFont fontWithName:@"Futura-Medium" size:14.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style2
{
    return @{@"font": [UIFont fontWithName:@"Futura-Medium" size:32.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style3
{
    return @{@"font": [UIFont fontWithName:@"Futura-Medium" size:18.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style4
{
    return @{@"font": [UIFont fontWithName:@"Futura-CondensedMedium" size:28.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style5
{
    return @{@"font": [UIFont fontWithName:@"Futura-CondensedMedium" size:28.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)navigationBarTitleStyle
{
    return @{@"font": [UIFont fontWithName:@"Futura-CondensedExtraBold" size:22.0],
             @"color": [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]};
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithRed:233.0/256.0 green:233.0/256.0 blue:233.0/256.0 alpha:1.0];
}

- (void)setNavigationBarStyling
{
    UIColor *navigationBarBackgroundColor = [UIColor colorWithRed:96.0/256.0 green:67.0/256.0 blue:142.0/256.0 alpha:1.0];
    [[UINavigationBar appearance] setTintColor:navigationBarBackgroundColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeFont:[self.navigationBarTitleStyle objectForKey:@"font"]}];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setNavigationBarStyling];
    return YES;
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
}

@end
