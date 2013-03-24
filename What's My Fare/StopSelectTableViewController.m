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

@interface StopSelectTableViewController ()
//Class Properties
@property (strong, nonatomic) NSArray *stopsDataModel; //data model
@property (strong, nonatomic) FareAzureWebServices *webService;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) NSDictionary *selectedItem;

//Target-Action methods
- (IBAction)refreshData:(UIBarButtonItem *)sender;
@end

@implementation StopSelectTableViewController
@synthesize stopsDataModel = _stopsDataModel;
@synthesize webService = _webService;

- (FareAzureWebServices *)webService
{
    if(!_webService)
    {
        _webService = [[FareAzureWebServices alloc] init];
    }
    return _webService;
}

- (IBAction)refreshData:(UIBarButtonItem *)sender
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    
    
    [self.webService.luasTable readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        self.stopsDataModel = [items copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.navigationItem.rightBarButtonItem = sender;
        });
    }];
}

- (StopSelectTableViewController *)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if(!self)
    {
        self = [super initWithStyle:UITableViewStylePlain];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self refreshData:self.refreshButton];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = [self.stopsDataModel objectAtIndex:indexPath.item];
    
    NSLog(@"%@", self.selectedItem);
    
    //return to previous nav controller
    
}

- (void)viewDidUnload {
    [self setRefreshButton:nil];
    [super viewDidUnload];
}
@end
