//
//  FareAppDelegate.h
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface FareAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSArray *styleKeys;
@property (strong, nonatomic) NSDictionary *style1;
@property (strong, nonatomic) NSDictionary *style2;
@property (strong, nonatomic) NSDictionary *style3;
@property (strong, nonatomic) NSDictionary *style4;
@property (strong, nonatomic) NSDictionary *style5;
@property (strong, nonatomic) NSDictionary *navigationBarTitleStyle;
@property (strong, nonatomic) NSDictionary *standardCellStyle;
@property (strong, nonatomic) NSDictionary *calculateCellStyle;
@property (strong, nonatomic) NSDictionary *fontColors;

@property (strong, nonatomic) UIColor *backgroundColor;

@end
