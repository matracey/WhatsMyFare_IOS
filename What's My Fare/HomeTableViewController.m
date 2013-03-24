//
//  HomeTableViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@end

@implementation HomeTableViewController
@synthesize myTableView = _myTableView;

- (UITableView *)myTableView
{
    if(!_myTableView)
    {
        id myTableView = [self initWithStyle:UITableViewStyleGrouped];
        if([myTableView isKindOfClass:[UITableView class]]) _myTableView = myTableView;
    }
    return _myTableView;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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



- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
