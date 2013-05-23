//
//  FareResultsViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 28/04/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#define LUAS_PRICES_TABLE @"LuasPriceInfo"
#define LUAS_TARIFF_TABLE @"LuasFareTariffs"
#define RAIL_PRICES_TABLE @"RailPriceInfo"
#define RAIL_TARIFF_TABLE @"RailFareTariffs"

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
@property (strong, nonatomic) IBOutlet UIButton *CashButton;
@property (strong, nonatomic) IBOutlet UIButton *LeapCardButton;

//Properties & Model
@property (strong, nonatomic) NSDictionary *fareResult;
@property (strong, nonatomic) NSDictionary *farePrice;
@property (strong, nonatomic) NSNumber *paymentPlatformID; //0 is cash, 1 is Leap Card
@property (strong, nonatomic) NSString *lineIdentifier;
@property (strong, nonatomic) FareAzureWebServices *webService;
@property (strong, nonatomic) FareAppDelegate *globalAppProperties;

//Target-Action methods
- (IBAction)paymentPlatformDidChange:(UIButton *)sender;
@end

@implementation FareResultsViewController

#pragma mark - Init methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - Property Accessor methods
- (FareAzureWebServices *)webService
{
    if(!_webService)
    {
        if([self.selectedService isEqual:@0]) _webService = [[FareAzureWebServices alloc] initWithTableName:LUAS_PRICES_TABLE];
        else _webService = [[FareAzureWebServices alloc] initWithTableName:RAIL_PRICES_TABLE];
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

#pragma mark - Property Setter methods
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
    }else self.lineIdentifier = origin;
}

#pragma mark - ViewController Lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshData];
    [self paymentPlatformDidChange:self.CashButton];
    self.view.backgroundColor = [self.globalAppProperties.standardCellStyle objectForKey:@"backgroundColor"];
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

- (void)viewDidUnload
{
    [self setOriginLabel:nil];
    [self setLineLabel:nil];
    [self setFareBracketImageView:nil];
    [self setLineImageView:nil];
    [self setCashButton:nil];
    [self setLeapCardButton:nil];
    [super viewDidUnload];
}

#pragma mark - Model
- (void)refreshData
{
    NSPredicate *query;
    if([self.selectedService isEqual:@0]) query = [NSPredicate predicateWithFormat:@"stop_from_id == %@ AND stop_to_id == %@", [[self.model objectAtIndex:0] objectForKey:@"id"], [[self.model objectAtIndex:1]objectForKey:@"id"]];
    else query = [NSPredicate predicateWithFormat:@"stop_from_id == %@ AND stop_to_id == %@", [[self.model objectAtIndex:0] objectForKey:@"stopId"], [[self.model objectAtIndex:1]objectForKey:@"stopId"]];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    
    [self.webService.veldt readWhere:query completion:^(NSArray *items, NSInteger totalCount, NSError *error)
     {
         if(error) NSLog(@"%@", error);
         
         [activityIndicator stopAnimating];
         self.navigationItem.rightBarButtonItem = nil;
         
         if([[items objectAtIndex:0] isKindOfClass:[NSDictionary class]] && items.count == 1)
         {
             self.fareResult = [items objectAtIndex:0];
             [self getPriceWithZone:[self.fareResult objectForKey:@"price_code"]];
         }
         else NSLog(@"Something went wrong. :(");
     }];
    self.originLabel.text = [[self.model objectAtIndex:0] objectForKey:@"stopName"];
    self.destinLabel.text = [[self.model objectAtIndex:1] objectForKey:@"stopName"];
    
    //Update FareBracket UI Elements
    self.fareBracketLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.model objectAtIndex:2] objectAtIndex:0], [[self.model objectAtIndex:2] objectAtIndex:1]];
    self.fareBracketImageView.image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png", [[self.model objectAtIndex:2] objectAtIndex:0]] lowercaseString]];
    
    //Update Line UI Elements
    [self setLineIdentifierByOrigin:[[self.model objectAtIndex:0] objectForKey:@"service"] andDestination:[[self.model objectAtIndex:1] objectForKey:@"service"]];
    if([self.selectedService isEqual:@2])self.lineImageView.image = [UIImage imageNamed:@"rail.png"];
    else if([self.selectedService isEqual:@1])self.lineImageView.image = [UIImage imageNamed:@"dart.png"];
    else self.lineImageView.image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png", self.lineIdentifier] lowercaseString]];
    
    if([self.lineIdentifier isEqualToString:@"Red"] || [self.lineIdentifier isEqualToString:@"Green"]) self.lineLabel.text = [NSString stringWithFormat:@"%@ Line", self.lineIdentifier];
    else if([self.lineIdentifier isEqualToString:@"Both"]) self.lineLabel.text = @"Red & Green Line";
    else if([self.selectedService isEqual:@1]) self.lineLabel.text = @"DART";
    else self.lineLabel.text = @"Commuter Rail";
    
}

- (void)getPriceWithZone:(NSString *)zone
{
    FareAzureWebServices *fareTariffs;
    if([self.selectedService isEqual:@0]) fareTariffs = [[FareAzureWebServices alloc] initWithTableName:LUAS_TARIFF_TABLE];
    else fareTariffs = [[FareAzureWebServices alloc] initWithTableName:RAIL_TARIFF_TABLE];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"priceCode == %@", zone];
    [fareTariffs.veldt readWhere:query completion:^(NSArray *items, NSInteger totalCount, NSError *error)
    {
        if([[items objectAtIndex:0] isKindOfClass:[NSDictionary class]] && items.count == 1)
        {
            self.farePrice = [items objectAtIndex:0];
            NSNumber *price = [self.farePrice objectForKey:[self getFareBracketStringFromArray:[self.model objectAtIndex:2]]];
            self.totalFareLabel.text = [self getLocalisedPriceStringFromPrice:price];
        }
    }];
}

- (NSString *)getLocalisedPriceStringFromPrice:(NSNumber *)price
{
    NSNumberFormatter *priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_IE"]];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [priceFormatter stringFromNumber:price];
}

- (NSString *)getFareBracketStringFromArray:(NSArray *)fareInfo
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
                fare = @"adultSingle";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"adultReturn";
            }
        }else if ([fareBracket isEqualToString:@"Child"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"childSingle";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"childReturn";
            }
        }else if ([fareBracket isEqualToString:@"Student"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"adultSingle";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"adultReturn";
            }
        }
    }else if ([self.paymentPlatformID isEqualToNumber:[NSNumber numberWithInt:1]])
    {
        if([fareBracket isEqualToString:@"Adult"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"scAdult";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"scAdultReturn";
            }
        }else if ([fareBracket isEqualToString:@"Child"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"scChild";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"scChildReturn";
            }
        }else if ([fareBracket isEqualToString:@"Student"])
        {
            if ([ticketTypes isEqualToString:@"Single"])
            {
                fare = @"scStudent";
            }else if ([ticketTypes isEqualToString:@"Return"])
            {
                fare = @"scStudentReturn";
            }
        }
    }
    return fare;
}

#pragma mark - Target-Action methods
- (IBAction)paymentPlatformDidChange:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"CASH"])
    {
        self.paymentPlatformID = @0;
        self.LeapCardButton.enabled = YES;
    }
    else
    {
        self.paymentPlatformID = @1;
        self.CashButton.enabled = YES;
    }
    sender.enabled = NO;
    NSNumber *price = [self.farePrice objectForKey:[self getFareBracketStringFromArray:[self.model objectAtIndex:2]]];
    self.totalFareLabel.text = [self getLocalisedPriceStringFromPrice:price];
}

@end
