//
//  FareAppDelegate.m
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FareAppDelegate.h"
#import "Reachability.h"

@interface FareAppDelegate ()
@end

@implementation FareAppDelegate

- (NSArray *)styleKeys
{
    return @[@"font",@"color", @"background"];
}

- (NSDictionary *)style1
{
    //regular font
    return @{@"font": [UIFont fontWithName:@"Futura-Medium" size:18.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style2
{
    //xtra-large font
    return @{@"font": [UIFont fontWithName:@"Futura-Medium" size:32.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style3
{
    //large font
    return @{@"font": [UIFont fontWithName:@"Futura-Medium" size:26.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style4
{
    //condensed-large font
    return @{@"font": [UIFont fontWithName:@"Futura-CondensedMedium" size:26.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style5
{
    //small font
    return @{@"font": [UIFont fontWithName:@"Futura-Medium" size:16.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)style6
{
    //small-condensed-bold font
    return @{@"font": [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]};
}

- (NSDictionary *)navigationBarTitleStyle
{
    return @{@"font": [UIFont fontWithName:@"Futura-CondensedExtraBold" size:20.0],
             @"color": [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]};
}

- (NSDictionary *)standardCellStyle
{
    return @{@"font": [UIFont fontWithName:@"Futura-Medium" size:18.0],
             @"color": [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0],
             @"backgroundColor":[[UIColor alloc] initWithRed:(206.0/256.0) green:(206.0/256.0) blue:(206.0/256.0) alpha:1.0]};
}


- (NSDictionary *)calculateCellStyle
{
    return @{@"font":[UIFont fontWithName:@"Futura-CondensedExtraBold" size:22.0],
             @"color": [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
             @"backgroundColor": [[UIColor alloc] initWithRed:96.0/256.0 green:67.0/256.0 blue:142.0/256.0 alpha:1.0]};
}

- (NSDictionary *)fontColors
{
    return @{@"Red": [UIColor colorWithRed:170.0/256.0 green:53.0/256.0 blue:53.0/256.0 alpha:1.0],
             @"Green": [UIColor colorWithRed:91.0/256.0 green:146.0/256.0 blue:47.0/256.0 alpha:1.0],
             @"DART": [UIColor colorWithRed:124.0/256.0 green:194.0/256.0 blue:66.0/256.0 alpha:1.0],
             @"Commuter Rail": [UIColor colorWithRed:51.0/256.0 green:169.0/256.0 blue:198.0/256.0 alpha:1.0]};
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

- (BOOL)applicationCanConnectToIntenet
{
    Reachability *google = [Reachability reachabilityWithHostname:@"www.google.com"];
    Reachability *apple = [Reachability reachabilityWithHostname:@"www.apple.com"];
    NetworkStatus googleStatus = [google currentReachabilityStatus];
    NetworkStatus appleStatus = [apple currentReachabilityStatus];
    
    if(googleStatus == NotReachable && appleStatus == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No intenet connection!" message:@"Please check your internet connection and try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
    }
    return googleStatus == NotReachable && appleStatus == NotReachable;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setNavigationBarStyling];
    self.deviceDidHaveIntenetConnectionOnLaunch = [self applicationCanConnectToIntenet];
    return YES;
}

@end
