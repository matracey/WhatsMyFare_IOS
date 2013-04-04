//
//  StopSelectTableViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 07/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "StopSelectTableViewController.h"
#import "FareAzureWebServices.h"
#import "HomeTableViewController.h"
#import "FareAppDelegate.h"

@interface StopSelectTableViewController ()
//Class Properties
@property (strong, nonatomic) NSArray *stopsDataModel; //data model
@property (strong, nonatomic) FareAzureWebServices *webService;
@property (strong, nonatomic) FareAppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

//Target-Action methods
- (IBAction)refreshData:(UIBarButtonItem *)sender;
@end

@implementation StopSelectTableViewController

#pragma mark - StopSelectTableViewController init methods

- (StopSelectTableViewController *)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if(!self)
    {
        self = [super initWithStyle:UITableViewStylePlain];
    }
    
    return self;
}

#pragma mark - StopSelectTableViewController object instantiation

- (FareAzureWebServices *)webService
{
    if(!_webService)
    {
        _webService = [[FareAzureWebServices alloc] init];
    }
    return _webService;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshData:self.refreshButton];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stopsDataModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"stopCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.stopsDataModel objectAtIndex:indexPath.item] objectForKey:@"stopName"];
    cell.detailTextLabel.text = [[self.stopsDataModel objectAtIndex:indexPath.item] objectForKey:@"luasLine"];
    if([cell.detailTextLabel.text isEqualToString:@"Green"])cell.detailTextLabel.textColor = [UIColor greenColor];
    if([cell.detailTextLabel.text isEqualToString:@"Red"])cell.detailTextLabel.textColor = [UIColor redColor];
    
    return cell;
}

- (IBAction)refreshData:(UIBarButtonItem *)sender
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    [self.webService.stopsDataTable readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        self.stopsDataModel = [items copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            //sleep(1); //added so that activityIndicator can be seen.
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem = sender;
        });
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewController *homeViewController = [self.navigationController.viewControllers
                                                   objectAtIndex:self.navigationController.viewControllers.count-2];
    if([self.title isEqualToString:@"Origin"])
    {
        [homeViewController setOrigin:[[self.stopsDataModel objectAtIndex:indexPath.item] mutableCopy]];
    }
    if ([self.title isEqualToString:@"Destination"])
    {
        [homeViewController setDestin:[[self.stopsDataModel objectAtIndex:indexPath.item] mutableCopy]];
    }
    
    //return to previous nav controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}
@end
