//
//  HomeTableViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "HomeTableViewController.h"

@interface HomeTableViewController ()
@property (strong, nonatomic) IBOutlet UITableViewCell *originTableViewCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *destinationTableViewCell;
@property (strong, nonatomic) NSDictionary *defaultValues;
@property (strong, nonatomic) NSString *fareBracket;
@property (strong, nonatomic) IBOutlet UITableViewCell *fareBracketTableViewCell;
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
        NSArray *defaults = [[NSArray alloc] initWithObjects:@"", @"", @"", @"Choose a stop...",nil];
        _defaultValues = [[NSDictionary alloc] initWithObjects:defaults forKeys:keys];
    }
    return _defaultValues;
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
- (void)refreshData
{
    self.originTableViewCell.textLabel.text = [self.origin objectForKey:@"stopName"];
    self.originTableViewCell.detailTextLabel.text = [self.origin objectForKey:@"luasLine"];
    
    self.destinationTableViewCell.textLabel.text = [self.destin objectForKey:@"stopName"];
    self.destinationTableViewCell.detailTextLabel.text = [self.destin objectForKey:@"luasLine"];
    
    self.fareBracketTableViewCell.textLabel.text = self.fareBracket;
}

#pragma mark - UITableViewDelegate

#pragma mark - UIViewControllerLifeCycle
- (void)viewDidLoad
{
    self.fareBracket = @"Choose a fare bracket...";
    if (!self.origin)
    {
        self.origin = [self.defaultValues copy];
    }
    if (!self.destin)
    {
        self.destin = [self.defaultValues copy];
    }
    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self refreshData];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setOriginTableViewCell:nil];
    [self setDestinationTableViewCell:nil];
    [self setFareBracketTableViewCell:nil];
    [super viewDidUnload];
}
@end
