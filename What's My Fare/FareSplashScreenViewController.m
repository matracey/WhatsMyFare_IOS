//
//  FareSplashScreenViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 07/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FareSplashScreenViewController.h"

@interface FareSplashScreenViewController ()

@end

@implementation FareSplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:(96.0/256.0) green:(67.0/256.0) blue:(142.0/256.0) alpha:1.0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:3.0];
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
