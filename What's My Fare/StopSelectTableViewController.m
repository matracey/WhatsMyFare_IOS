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

@interface StopSelectTableViewController () <UISearchBarDelegate, UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet UISearchBar *pointSearchBar;

//Class Properties
@property (strong, nonatomic) NSString *searchQuery;
@property (strong, nonatomic) NSArray *points; //data model
@property (strong, nonatomic) NSMutableArray *filteredPoints; //filtered data model
@property (strong, nonatomic) FareAzureWebServices *webService;
@property (strong, nonatomic) FareAppDelegate *appDelegate;

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
        _webService = [[FareAzureWebServices alloc] initWithTableName:@"LuasStops"];
    }
    return _webService;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filteredPoints = [NSMutableArray arrayWithCapacity:self.points.count];
    [self refreshData:self.refreshButton];
    self.searchDisplayController.searchBar.alpha = 0.0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView) return self.filteredPoints.count;
    else return self.points.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    NSDictionary *point;
    
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        point = [self.filteredPoints objectAtIndex:indexPath.row];
    }else point = [self.points objectAtIndex:indexPath.row];
    
    //Configure the cell...
    cell.textLabel.text = [point objectForKey:@"stopName"];
    cell.detailTextLabel.text = [point objectForKey:@"luasLine"];
    if([cell.detailTextLabel.text isEqualToString:@"Green"])cell.detailTextLabel.textColor = [UIColor greenColor];
    if([cell.detailTextLabel.text isEqualToString:@"Red"])cell.detailTextLabel.textColor = [UIColor redColor];
    
    /*
    cell.textLabel.text = [[self.points objectAtIndex:indexPath.item] objectForKey:@"stopName"];
    cell.detailTextLabel.text = [[self.points objectAtIndex:indexPath.item] objectForKey:@"luasLine"];
    if([cell.detailTextLabel.text isEqualToString:@"Green"])cell.detailTextLabel.textColor = [UIColor greenColor];
    if([cell.detailTextLabel.text isEqualToString:@"Red"])cell.detailTextLabel.textColor = [UIColor redColor];
     */
    
    return cell;
}

- (IBAction)refreshData:(UIBarButtonItem *)sender
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    [self.webService.veldt readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        self.points = [items copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            //sleep(1); //added so that activityIndicator can be seen.
            [self.tableView reloadData];
            [activityIndicator stopAnimating];
            self.navigationItem.rightBarButtonItem = sender;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            self.searchDisplayController.searchBar.alpha = 1.0;
        });
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *result;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        result = [self.filteredPoints objectAtIndex:indexPath.row];
    }else result = [self.points objectAtIndex:indexPath.row];
    HomeTableViewController *homeViewController = [self.navigationController.viewControllers
                                                   objectAtIndex:self.navigationController.viewControllers.count-2];
    if([self.title isEqualToString:@"Origin"])
    {
        [homeViewController setOrigin:[result mutableCopy]];
    }
    if ([self.title isEqualToString:@"Destination"])
    {
        [homeViewController setDestin:[result mutableCopy]];
    }
    //return to previous nav controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}

#pragma mark - UISearchDisplayControllerDelegate methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //filter the content by the search string and the scope selector!
    [self filterContentForSearchQuery:searchString];
    return YES;
}

#pragma mark - UITableViewSearch methods
- (void)filterContentForSearchQuery:(NSString *)searchQuery
{
    //Clean out the filtered array
    [self.filteredPoints removeAllObjects];
    //Create a predicate that will be used to filter results
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"stopName contains[c] %@", searchQuery];
    self.filteredPoints = [NSMutableArray arrayWithArray:[self.points filteredArrayUsingPredicate:searchPredicate]];
}

@end
