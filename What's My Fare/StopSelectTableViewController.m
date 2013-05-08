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
//UI Outlets
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) IBOutlet UISearchBar *pointSearchBar;

//Class Properties
@property (strong, nonatomic) NSString *searchQuery;
@property (strong, nonatomic) NSArray *points; //data model
@property (strong, nonatomic) NSMutableArray *filteredPoints; //filtered data model
@property (strong, nonatomic) FareAzureWebServices *webService;
@property (strong, nonatomic) FareAppDelegate *globalAppProperties;
@property (strong, nonatomic) HomeTableViewController *homeViewController;

//Target-Action methods
- (IBAction)refreshData:(UIBarButtonItem *)sender;
@end

@implementation StopSelectTableViewController

#pragma mark - StopSelectTableViewController init methods

- (StopSelectTableViewController *)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(!self) self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (FareAppDelegate *)globalAppProperties
{
    if(!_globalAppProperties) _globalAppProperties = [[FareAppDelegate alloc] init];
    return _globalAppProperties;
}

- (HomeTableViewController *)homeViewController
{
    if(!_homeViewController) _homeViewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    return _homeViewController;
}

#pragma mark - StopSelectTableViewController object instantiation

- (FareAzureWebServices *)webService
{
    if(!_webService)
    {
        //
        if([self.selectedService isEqual: @0]) _webService = [[FareAzureWebServices alloc] initWithTableName:@"LuasStops"];
        else if ([self.selectedService isEqual: @1] || [self.selectedService isEqual: @2]) _webService = [[FareAzureWebServices alloc] initWithTableName:@"DARTandCommuterRail_Stations"];
    }
    return _webService;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filteredPoints = [NSMutableArray arrayWithCapacity:self.points.count];
    [self setSearchBarOutOfView];
    self.searchDisplayController.searchBar.alpha = 0.0;
    [self refreshData:self.refreshButton];
}

- (void)setSearchBarOutOfView
{
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
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
    //textLabel properties
    cell.textLabel.text = [point objectForKey:@"stopName"];
    cell.textLabel.font = [self.globalAppProperties.style1 objectForKey:@"font"];
    cell.textLabel.textColor = [self.globalAppProperties.style1 objectForKey:@"color"];
    
    //detailTextLabel properties
    if([self.selectedService isEqual:@0])
    {
        cell.detailTextLabel.text = [point objectForKey:@"service"];
        cell.detailTextLabel.textColor = [self.globalAppProperties.fontColors objectForKey:cell.detailTextLabel.text];
        cell.detailTextLabel.font = [self.globalAppProperties.style1 objectForKey:@"font"];
    }else cell.detailTextLabel.text = @"";
    
    //general cell properties
    cell.backgroundColor = [self.globalAppProperties.standardCellStyle objectForKey:@"backgroundColor"];
    
    return cell;
}

- (IBAction)refreshData:(UIBarButtonItem *)sender
{
    //Create and add the UIActivityIndicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    //Access our data
    NSPredicate *filterPredicate;
    if([self.selectedService isEqual:@0])
    {
        [self.webService.veldt readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error)
         {
             [self dataDidLoadFromWebService:items withIndicator:activityIndicator andSender:sender];
         }];
    }else if([self.selectedService isEqual:@1]){
        filterPredicate = [NSPredicate predicateWithFormat:@"service ==[c] %@  OR service ==[c] %@", @"DART/Commuter Rail", @"DART"];
        [self.webService.veldt readWhere:filterPredicate completion:^(NSArray *items, NSInteger totalCount, NSError *error)
        {
            [self dataDidLoadFromWebService:items withIndicator:activityIndicator andSender:sender];
        }];
    }else if([self.selectedService isEqual:@2]){
        filterPredicate = [NSPredicate predicateWithFormat:@"service ==[c] %@  OR service ==[c] %@", @"DART/Commuter Rail", @"Commuter Rail"];
        [self.webService.veldt readWhere:filterPredicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
            [self dataDidLoadFromWebService:items withIndicator:activityIndicator andSender:sender];
        }];
    }
}

- (void)dataDidLoadFromWebService:(NSArray *)data withIndicator:(UIActivityIndicatorView *)activityIndicator andSender:(UIBarButtonItem *)sender
{
    self.points = [data copy];
    
    //filter the display when selecting destination for commuter rail services.
    if([self.selectedService isEqual:@2] && [self.title isEqual:@"Destination"]){
        self.points = [self removeIrrelevantStationsForCommuterRailFromArray:self.points];
    }
    //reload the data so that the table view is updated
    [self.tableView reloadData];
    //stop the activity indicator from spinning and put the refresh button back
    [activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = sender;
    //scroll to the first record in the table view
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    //make the search bar visible again
    self.searchDisplayController.searchBar.alpha = 1.0;
}

- (NSArray *)removeIrrelevantStationsForCommuterRailFromArray:(NSArray *)array
{
    NSMutableSet *myMutableSet = [[NSMutableSet alloc] initWithCapacity:self.points.count];
    if([[self.homeViewController.origin objectForKey:@"hasCommuterLine1"] isEqualToString:@"y"])
    {
        for (NSDictionary *obj in array) {
            if ([[obj objectForKey:@"hasCommuterLine1"] isEqualToString:@"y"] && ![obj isEqual:self.homeViewController.origin]) {
                [myMutableSet addObject:obj];
                //NSLog(@"Commuter Line 1");
            }
        }
    }
    if([[self.homeViewController.origin objectForKey:@"hasCommuterLine2"] isEqualToString:@"y"])
    {
        for (NSDictionary *obj in array) {
            if ([[obj objectForKey:@"hasCommuterLine2"] isEqualToString:@"y"] && ![obj isEqual:self.homeViewController.origin]) {
                [myMutableSet addObject:obj];
                //NSLog(@"Commuter Line 2");
            }
        }
    }
    if([[self.homeViewController.origin objectForKey:@"hasCommuterLine3"] isEqualToString:@"y"])
    {
        for (NSDictionary *obj in array) {
            if ([[obj objectForKey:@"hasCommuterLine3"] isEqualToString:@"y"] && ![obj isEqual:self.homeViewController.origin]) {
                [myMutableSet addObject:obj];
                //NSLog(@"Commuter Line 3");
            }
        }
    }
    if([[self.homeViewController.origin objectForKey:@"hasCommuterLine4"] isEqualToString:@"y"])
    {
        for (NSDictionary *obj in array) {
            if ([[obj objectForKey:@"hasCommuterLine4"] isEqualToString:@"y"] && ![obj isEqual:self.homeViewController.origin]) {
                [myMutableSet addObject:obj];
                //NSLog(@"Commuter Line 4");
            }
        }
    }
    if([[self.homeViewController.origin objectForKey:@"hasCommuterLine5"] isEqualToString:@"y"])
    {
        for (NSDictionary *obj in array) {
            if ([[obj objectForKey:@"hasCommuterLine5"] isEqualToString:@"y"] && ![obj isEqual:self.homeViewController.origin]) {
                [myMutableSet addObject:obj];
                //NSLog(@"Commuter Line 5");
            }
        }
    }
    if([[self.homeViewController.origin objectForKey:@"hasCommuterLine6"] isEqualToString:@"y"])
    {
        for (NSDictionary *obj in array) {
            if ([[obj objectForKey:@"hasCommuterLine6"] isEqualToString:@"y"] && ![obj isEqual:self.homeViewController.origin]) {
                [myMutableSet addObject:obj];
                //NSLog(@"Commuter Line 6");
            }
        }
    }
    if([[self.homeViewController.origin objectForKey:@"hasCommuterLine7"] isEqualToString:@"y"])
    {
        for (NSDictionary *obj in array) {
            //NSLog(@"%@", [obj objectForKey:@"stopName"]);
            if ([[obj objectForKey:@"hasCommuterLine7"] isEqualToString:@"y"] && ![obj isEqual:self.homeViewController.origin]) {
                [myMutableSet addObject:obj];
                //NSLog(@"Commuter Line 7");
            }
        }
    }
    return [myMutableSet allObjects];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *result;
    if(tableView == self.searchDisplayController.searchResultsTableView)
    {
        result = [self.filteredPoints objectAtIndex:indexPath.row];
    }else result = [self.points objectAtIndex:indexPath.row];
    if([self.title isEqualToString:@"Origin"])
    {
        [self.homeViewController setOrigin:[result mutableCopy]];
    }
    if ([self.title isEqualToString:@"Destination"])
    {
        [self.homeViewController setDestin:[result mutableCopy]];
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
