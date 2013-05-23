//
//  FareSplashScreenViewController.h
//  What's My Fare
//
//  Created by Martin Tracey on 07/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface FareSplashScreenViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (strong, nonatomic) UIBarButtonItem *splitViewBarButtonItem;
@end
