//
//  SplitViewControllerDelegate.m
//  What's My Fare
//
//  Created by Martin Tracey on 15/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "NavigationControllerWithSplitViewDelegate.h"

@interface NavigationControllerWithSplitViewDelegate ()
@property (nonatomic, strong) UIViewController *sender;
@end

@implementation NavigationControllerWithSplitViewDelegate

-(id<SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    detailVC = [[detailVC viewControllers] lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]){
        detailVC = nil;
    }
    return detailVC;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    
    //return orientation == UIInterfaceOrientationMaskPortrait;
    return NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    NSLog(@"Will hide!");
    //getting the HomeViewController from the navigation controller
    UINavigationController *hiddenVC = (UINavigationController *)aViewController;
    aViewController = [hiddenVC.viewControllers objectAtIndex:0];
    
    //setting the bar button item
    barButtonItem.title = aViewController.title;
    [[self splitViewBarButtonItemPresenter] setSplitViewBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSLog(@"Will Show!");
    [[self splitViewBarButtonItemPresenter] setSplitViewBarButtonItem:nil];
}

@end
