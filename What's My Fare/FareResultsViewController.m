//
//  FareResultsViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 28/04/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#define LUAS_PRICES_TABLE @"PriceInfo"

#import "FareResultsViewController.h"
#import "FareAzureWebServices.h"

@interface FareResultsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *originLabel;
@property (strong, nonatomic) IBOutlet UILabel *destinLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalFareLabel;
@property (strong, nonatomic) IBOutlet UILabel *fareBracketLabel;
@property (strong, nonatomic) FareAzureWebServices *webService;
@property (strong, nonatomic) IBOutlet UISegmentedControl *platformSelector;
@property (strong, nonatomic) NSDictionary *fareResult;
@property (strong, nonatomic) NSDictionary *fareBrackets;

- (IBAction)paymentPlatformDidChange:(UISegmentedControl *)sender;
@end

@implementation FareResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (FareAzureWebServices *)webService
{
    if(!_webService)
    {
        _webService = [[FareAzureWebServices alloc] initWithTableName:LUAS_PRICES_TABLE];
    }
    return _webService;
}

- (NSDictionary *)fareBrackets
{
    return @{@"Adult":@"AdultSingle", @"Child":@"ChildSingle", @"Student":@""};
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshData];
}

- (void)refreshData
{
    NSPredicate *query = [NSPredicate predicateWithFormat:@"stop_from_id == %@ AND stop_to_id == %@", [[self.model objectAtIndex:0] objectForKey:@"id"], [[self.model objectAtIndex:1]objectForKey:@"id"]];
        
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    [self.webService.veldt readWhere:query completion:^(NSArray *items, NSInteger totalCount, NSError *error)
     {
         if(error) NSLog(@"%@", error);
         [activityIndicator stopAnimating];
         self.navigationItem.rightBarButtonItem = nil;
         if([[items objectAtIndex:0] isKindOfClass:[NSDictionary class]] && items.count == 1){
             self.fareResult = [items objectAtIndex:0];
             NSNumber *myFare = [self getPriceWithZone:[self.fareResult objectForKey:@"zone_code"]];
             self.totalFareLabel.text = [NSString stringWithFormat:@"%@", myFare];
         }
         else NSLog(@"Something went wrong. :(");
     }];
    
    self.originLabel.text = [[self.model objectAtIndex:0] objectForKey:@"stopName"];
    self.destinLabel.text = [[self.model objectAtIndex:1] objectForKey:@"stopName"];
    self.fareBracketLabel.text = [self.model objectAtIndex:2];
}

- (NSNumber *)getPriceWithZone:(NSString *)zone
{
    FareAzureWebServices *fareTarriffs = [[FareAzureWebServices alloc] initWithTableName:@"FareTarrifs"];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"ZoneCode == %@", zone];
    [fareTarriffs.veldt readWhere:query completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if([[items objectAtIndex:0] isKindOfClass:[NSDictionary class]] && items.count == 1){
            NSDictionary *price = [items objectAtIndex:0];
            self.totalFareLabel.text = [NSString stringWithFormat:@"€%@", [price objectForKey:[self.fareBrackets objectForKey:[self.model objectAtIndex:2]]]];
        }
    }];
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOriginLabel:nil];
    [self setPlatformSelector:nil];
    [super viewDidUnload];
}

- (IBAction)paymentPlatformDidChange:(UISegmentedControl *)sender
{
    NSLog(@"%i", self.platformSelector.selectedSegmentIndex);
}

@end
