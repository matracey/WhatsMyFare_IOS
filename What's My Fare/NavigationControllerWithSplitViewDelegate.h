//
//  SplitViewControllerDelegate.h
//  What's My Fare
//
//  Created by Martin Tracey on 15/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SplitViewBarButtonItemPresenter
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;
@end

@interface NavigationControllerWithSplitViewDelegate : UINavigationController <UISplitViewControllerDelegate>
@end
