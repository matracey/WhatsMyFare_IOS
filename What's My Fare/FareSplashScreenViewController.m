//
//  FareSplashScreenViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 07/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FareSplashScreenViewController.h"
#import "SplitViewControllerDelegate.h"
#import "StopSelectTableViewController.h"
#import "HomeTableViewController.h"
#import "FareResultsViewController.h"

#define STOP_SELECT_SEGUE @"stopSelectSegue"
#define RESULT_SEGUE @"resultSegue"

@interface FareSplashScreenViewController ()
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) SplitViewControllerDelegate *delegate;
@property (nonatomic, strong) HomeTableViewController *masterVC;
@end

@implementation FareSplashScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:(96.0/256.0) green:(67.0/256.0) blue:(142.0/256.0) alpha:1.0];
    self.splitViewController.delegate = self.delegate;
    NSLog(@"%@", self.masterVC.title);
}

- (void)viewDidAppear:(BOOL)animated
{
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:3.0];
}
#pragma - mark Property getters
- (SplitViewControllerDelegate *)delegate
{
    if(!_delegate) _delegate = [[SplitViewControllerDelegate alloc] initWithSender:self];
    return _delegate;
}

- (HomeTableViewController *)masterVC
{
    if(!_masterVC)
    {
        UINavigationController *navController;
        if([[self.splitViewController.viewControllers objectAtIndex:0] isKindOfClass:[UINavigationController class]])
        {
            navController = [self.splitViewController.viewControllers objectAtIndex:0];
        }
        _masterVC = [navController.viewControllers objectAtIndex:0];
    }
    return _masterVC;
}

#pragma - mark Property setters

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if(_splitViewBarButtonItem != splitViewBarButtonItem)
    {
        NSMutableArray *barButtonItems = self.toolbar.items.mutableCopy;
        if(_splitViewBarButtonItem) [barButtonItems removeObject:_splitViewBarButtonItem];
        if(splitViewBarButtonItem) [barButtonItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = barButtonItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    
    if([segue.identifier isEqualToString:STOP_SELECT_SEGUE])
    {
        StopSelectTableViewController *destination = segue.destinationViewController;
        destination.title = self.masterVC.segueTitle;
        destination.selectedService = self.masterVC.selectedService;
        NSLog(@"%@", self.masterVC.segueTitle);
    }else if ([segue.identifier isEqualToString:RESULT_SEGUE])
    {
        FareResultsViewController *resultViewController = segue.destinationViewController;
        resultViewController.model = [[self.masterVC model] copy];
        resultViewController.selectedService = self.masterVC.selectedService.copy;
    }else NSLog(@"Err: Segue did not execute correctly.");
}

- (NSUInteger)supportedInterfaceOrientations
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) return UIInterfaceOrientationMaskAll;
    else return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%i", toInterfaceOrientation);
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
