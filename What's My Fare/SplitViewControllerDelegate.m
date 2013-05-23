//
//  SplitViewControllerDelegate.m
//  What's My Fare
//
//  Created by Martin Tracey on 15/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "SplitViewControllerDelegate.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface SplitViewControllerDelegate ()
@property (nonatomic, strong) UIViewController *sender;
@end

@implementation SplitViewControllerDelegate

-(id<SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    NSLog(@"%@", self.sender);
    id detailVC = ([self.sender.splitViewController.viewControllers lastObject]);
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)])
    {
        detailVC = nil;
    }
    return detailVC;
}

- (SplitViewControllerDelegate *)initWithSender:(UIViewController *)sender
{
    self = [super init];
    self.sender = sender;
    return self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    [[self splitViewBarButtonItemPresenter] setSplitViewBarButtonItem:barButtonItem];
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [[self splitViewBarButtonItemPresenter] setSplitViewBarButtonItem:nil];
}

@end
