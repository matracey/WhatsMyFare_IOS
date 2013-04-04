//
//  HomeTableViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()
@property (strong, nonatomic) NSDictionary *defaultValues;
@end

@implementation HomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {        
        //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:117 green:4 blue:32 alpha:1];
    }
    return self;
}

- (NSDictionary *)defaultValues
{
    if(!_defaultValues)
    {
        NSArray *keys = [[NSArray alloc] initWithObjects:@"id", @"luasLine", @"luasRoute", @"stopName", nil];
        NSArray *defaults = [[NSArray alloc] initWithObjects:@"(null)", @"Service", @"(null)", @"Point",nil];
        _defaultValues = [[NSDictionary alloc] initWithObjects:defaults forKeys:keys];
    }
    return _defaultValues;
}

- (void)setOrigin:(NSMutableDictionary *)origin
{
    NSLog(@"defaultValues = %@", self.defaultValues);
    self.origin = [origin copy];
}

- (void)setDestin:(NSMutableDictionary *)destin
{
    self.destin = [destin copy];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[UIViewController class]])
    {
        UIViewController *stopSelect = segue.destinationViewController;
        stopSelect.title = segue.identifier;
    }else NSLog(@"Err: Segue did not execute correctly.");
}

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

#pragma mark - UIViewControllerLifeCycle
- (void)viewDidLoad
{
    NSLog(@"Default values are: %@", self.defaultValues);
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
