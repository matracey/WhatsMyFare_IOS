//
//  FareSplashScreenViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 07/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FareSplashScreenViewController.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface FareSplashScreenViewController ()
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@end

@implementation FareSplashScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:(96.0/256.0) green:(67.0/256.0) blue:(142.0/256.0) alpha:1.0];
    NSLog(@"%@", [[self.splitViewController.viewControllers objectAtIndex:0] title]);
}

- (void)viewDidAppear:(BOOL)animated
{
    if(![[self.splitViewController.viewControllers lastObject] isEqual:self]) [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:3.0];
    else{
        self.navigationController.toolbarHidden = NO;
    }
}

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

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
