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
#import "FareAppDelegate.h"

@interface FareResultsViewController ()
//UIView Outlets
@property (strong, nonatomic) IBOutlet UILabel *originLabel;
@property (strong, nonatomic) IBOutlet UILabel *destinLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalFareLabel;
@property (strong, nonatomic) IBOutlet UILabel *fareBracketLabel;
@property (strong, nonatomic) IBOutlet UILabel *lineLabel;
@property (strong, nonatomic) IBOutlet UIImageView *fareBracketImageView;
@property (strong, nonatomic) IBOutlet UIImageView *lineImageView;

//Properties & Model
@property (strong, nonatomic) NSDictionary *fareResult;
@property (strong, nonatomic) NSNumber *paymentPlatformID; //0 is cash, 1 is Leap Card
@property (strong, nonatomic) NSString *lineIdentifier;
@property (strong, nonatomic) FareAzureWebServices *webService;
@property (strong, nonatomic) FareAppDelegate *globalAppProperties;

//Target-Action methods
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

- (FareAppDelegate *)globalAppProperties
{
    if(!_globalAppProperties)
    {
        _globalAppProperties = [[FareAppDelegate alloc] init];
    }
    return _globalAppProperties;
}

- (NSString *)lineIdentifier
{
    if(!_lineIdentifier)
    {
        _lineIdentifier = [[NSString alloc] init];
    }
    return _lineIdentifier;
}

- (NSString *)getFareBracketFromArray:(NSArray *)fareInfo
{
    NSString *fare;
    NSString *fareBracket = [fareInfo objectAtIndex:0];
    NSString *ticketTypes = [fareInfo objectAtIndex:1];
    if([self.paymentPlatformID isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        if([fareBracket isEqualToString:@"Adult"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"AdultSingle";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"AdultReturn";
            }
        }else if ([fareBracket isEqualToString:@"Child"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"ChildSingle";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"ChildReturn";
            }
        }else if ([fareBracket isEqualToString:@"Student"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"AdultSingle";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"AdultReturn";
            }
        }
    }else if ([self.paymentPlatformID isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        if([fareBracket isEqualToString:@"Adult"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"ScAdult";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"ScAdultReturn";
            }
        }else if ([fareBracket isEqualToString:@"Child"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"ScChild";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"ScChildReturn";
            }
        }else if ([fareBracket isEqualToString:@"Student"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"ScStudent";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"ScStudentReturn";
            }
        }
    }
    return fare;
}

- (void)setLineIdentifierByOrigin:(NSString *)origin andDestination:(NSString *)destination
{
    if([origin isEqualToString:@"Red"])
    {
        if ([destination isEqualToString:@"Red"]) self.lineIdentifier = @"Red";
        else if([destination isEqualToString:@"Green"]) self.lineIdentifier = @"Both";
    }
    else if([origin isEqualToString:@"Green"])
    {
        if ([destination isEqualToString:@"Green"]) self.lineIdentifier = @"Green";
        else if([destination isEqualToString:@"Red"]) self.lineIdentifier = @"Both";
    }else self.lineIdentifier = @"Rail";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshData];
    self.paymentPlatformID = [NSNumber numberWithInt:0];
    self.totalFareLabel.text = @"Loading...";
    
    //setting up styling
    //originLabel
    self.originLabel.font = [self.globalAppProperties.style5 objectForKey:@"font"];
    self.originLabel.textColor = [self.globalAppProperties.style5 objectForKey:@"color"];
    
    //destinLabel
    self.destinLabel.font = [self.globalAppProperties.style5 objectForKey:@"font"];
    self.destinLabel.textColor = [self.globalAppProperties.style5 objectForKey:@"color"];
    
    //totalFareLabel
    self.totalFareLabel.font = [self.globalAppProperties.style2 objectForKey:@"font"];
    self.totalFareLabel.textColor = [self.globalAppProperties.style2 objectForKey:@"color"];
    
    //fareBracketLabel
    self.fareBracketLabel.font = [self.globalAppProperties.style5 objectForKey:@"font"];
    self.fareBracketLabel.textColor = [self.globalAppProperties.style5 objectForKey:@"color"];
    
    //lineLabel
    self.lineLabel.font = [self.globalAppProperties.style3 objectForKey:@"font"];
    self.lineLabel.textColor = [self.globalAppProperties.style3 objectForKey:@"color"];
    
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
             [self getPriceWithZone:[self.fareResult objectForKey:@"zone_code"]];
         }
         else NSLog(@"Something went wrong. :(");
     }];
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update UI ONLY in main queue for fear of death otherwise
        self.originLabel.text = [[self.model objectAtIndex:0] objectForKey:@"stopName"];
        self.destinLabel.text = [[self.model objectAtIndex:1] objectForKey:@"stopName"];
        
        //Update FareBracket UI Elements
        self.fareBracketLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.model objectAtIndex:2] objectAtIndex:0], [[self.model objectAtIndex:2] objectAtIndex:1]];
        self.fareBracketImageView.image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png", [[self.model objectAtIndex:2] objectAtIndex:0]] lowercaseString]];
        
        //Update Line UI Elements
        [self setLineIdentifierByOrigin:[[self.model objectAtIndex:0] objectForKey:@"luasLine"] andDestination:[[self.model objectAtIndex:1] objectForKey:@"luasLine"]];
        self.lineImageView.image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png", self.lineIdentifier] lowercaseString]];
        if([self.lineIdentifier isEqualToString:@"Red"] || [self.lineIdentifier isEqualToString:@"Green"]) self.lineLabel.text = [NSString stringWithFormat:@"%@ Line", self.lineIdentifier];
        else if([self.lineIdentifier isEqualToString:@"Both"]) self.lineLabel.text = @"Red & Green Line";
        else self.lineLabel.text = @"DART/Commuter Rail";
    });
    
}

- (void)getPriceWithZone:(NSString *)zone
{
    FareAzureWebServices *fareTarriffs = [[FareAzureWebServices alloc] initWithTableName:@"FareTarrifs"];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"ZoneCode == %@", zone];
    [fareTarriffs.veldt readWhere:query completion:^(NSArray *items, NSInteger totalCount, NSError *error)
    {
        if([[items objectAtIndex:0] isKindOfClass:[NSDictionary class]] && items.count == 1)
        {
            NSDictionary *priceDictionary = [items objectAtIndex:0];
            NSNumber *price = [priceDictionary objectForKey:[self getFareBracketFromArray:[self.model objectAtIndex:2]]];
            NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
            [priceFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IE"]];
            [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            self.totalFareLabel.text = [priceFormatter stringFromNumber:price];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOriginLabel:nil];
    [self setLineLabel:nil];
    [self setFareBracketImageView:nil];
    [self setLineImageView:nil];
    [super viewDidUnload];
}

- (IBAction)paymentPlatformDidChange:(UISegmentedControl *)sender
{
    self.paymentPlatformID = [NSNumber numberWithInteger:sender.selectedSegmentIndex];
    [self refreshData];
}

@end
