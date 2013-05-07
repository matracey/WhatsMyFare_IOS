//
//  HomeTableViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "HomeTableViewController.h"
#import "StopSelectTableViewController.h"
#import "FareResultsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FareAppDelegate.h"

#define PRIMAR_CELL_ID @"primaryCell"
#define CALCUL_CELL_ID @"calculateButtonCell"
#define CALCUL_CELL_TEXT @"Calculate!"
#define POINTS_CELL_TEXT @"Choose a stop..."
#define FAREBR_CELL_TEXT @"Choose a fare bracket..."

#define SPLASH_SEGUE @"splashSegue"
#define RESULT_SEGUE @"fareResultSegue"
#define STOP_SELECT_SEGUE @"stopSelect"

@interface HomeTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *errLabel;
@property (strong, nonatomic) IBOutlet UIButton *luasServiceButton;
@property (strong, nonatomic) IBOutlet UIButton *railServiceButton;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) NSDictionary *defaultValues;
@property (strong, nonatomic) NSDictionary *fontColors;
@property (strong, nonatomic) NSString *fareBracket;
@property (strong, nonatomic) NSString *ticketType;
@property (strong, nonatomic) NSString *segueTitle;
@property (strong, nonatomic) NSArray *model; //
@property (strong, nonatomic) NSArray *fareBrackets;
@property (strong, nonatomic) NSNumber *selectedService; //0 for Luas, 1 for Rail
@property (strong, nonatomic) FareAppDelegate *globalAppProperties;

- (IBAction)didChangeSelectedService:(UIButton *)sender;
@end

@implementation HomeTableViewController

#pragma mark - Init methods

#pragma mark - Property getters
- (NSArray *)fareBrackets
{
    return @[@[@"Adult", @"Child", @"Student"], @[@"Single", @"Return"]];
}

- (FareAppDelegate *)globalAppProperties
{
    if(!_globalAppProperties)
    {
        _globalAppProperties = [[FareAppDelegate alloc] init];
    }
    return _globalAppProperties;
}

- (NSString *)fareBracket
{
    if(!_fareBracket)
    {
        _fareBracket = FAREBR_CELL_TEXT;
    }
    return _fareBracket;
}

- (NSString *)ticketType
{
    if(!_ticketType)
    {
        _ticketType = @"";
    }
    return _ticketType;
}

- (NSArray *)model
{
    return @[self.origin, self.destin, @[self.fareBracket, self.ticketType], CALCUL_CELL_TEXT];
}

- (NSDictionary *)defaultValues
{
    return @{@"id":@"", @"stopName":POINTS_CELL_TEXT, @"luasLine":@"", @"luasRoute":@""};
}

- (NSDictionary *)fontColors
{
    return @{@"Red": [UIColor colorWithRed:170/256 green:53/256 blue:53/256 alpha:1.0],
             @"Green": [UIColor colorWithRed:91/256 green:146/256 blue:47/256 alpha:1.0],
             @"DART": [UIColor colorWithRed:51/256 green:169/256 blue:198/256 alpha:1.0],
             @"Commuter Rail": [UIColor colorWithRed:170/256 green:53/256 blue:53/256 alpha:1.0]};
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    
    if([segue.identifier isEqualToString:STOP_SELECT_SEGUE])
    {
        StopSelectTableViewController *destination = segue.destinationViewController;
        destination.title = self.segueTitle;
        destination.selectedService = self.selectedService;
    }else if ([segue.identifier isEqualToString:RESULT_SEGUE])
    {
        FareResultsViewController *resultViewController = segue.destinationViewController;
        resultViewController.model = [self.model copy];
    }else if ([segue.identifier isEqualToString:SPLASH_SEGUE])
    {
        NSLog(@"Application launched successfully!");
    }
    else NSLog(@"Err: Segue did not execute correctly.");
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 3)
    {
        //Create label for title
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 284, 30)];
        NSArray *titles = @[@"Origin:", @"Destination:", @"Fare type:"];
        label.text = titles[section];
        label.textColor = [self.globalAppProperties.style1 objectForKey:[self.globalAppProperties.styleKeys objectAtIndex:1]];
        label.font = [self.globalAppProperties.style1 objectForKey:[self.globalAppProperties.styleKeys objectAtIndex:0]];
        label.backgroundColor = self.globalAppProperties.backgroundColor;
        
        //Create UIView as a frame for label
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        view.backgroundColor = self.globalAppProperties.backgroundColor;
        [view addSubview:label];
        
        return view;
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section != 3)
    {
        return 40;
    }else return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id data = [self.model objectAtIndex:[indexPath section]];
    
    // Configure the cell...
    if([data isKindOfClass:[NSDictionary class]])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:PRIMAR_CELL_ID];
        
        //textLabel properties
        cell.textLabel.text = [data objectForKey:@"stopName"];
        cell.textLabel.font = [self.globalAppProperties.standardCellStyle objectForKey:@"font"];
        cell.textLabel.textColor = [self.globalAppProperties.standardCellStyle objectForKey:@"color"];
        
        //detailTextLabel properties
        cell.detailTextLabel.text = [data objectForKey:@"luasLine"];
        cell.detailTextLabel.font = [self.globalAppProperties.standardCellStyle objectForKey:@"font"];
        cell.detailTextLabel.textColor = [self.globalAppProperties.fontColors objectForKey:cell.detailTextLabel.text];
        
        //general cell properties
        cell.backgroundColor = [self.globalAppProperties.standardCellStyle objectForKey:@"backgroundColor"];
    }else if ([data isKindOfClass:[NSArray class]])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:PRIMAR_CELL_ID];
        
        //textLabel properties
        cell.textLabel.text = [data objectAtIndex:0];
        cell.textLabel.font = [self.globalAppProperties.standardCellStyle objectForKey:@"font"];
        cell.textLabel.textColor = [self.globalAppProperties.standardCellStyle objectForKey:@"color"];
        
        //detailTextLabel properties
        cell.detailTextLabel.text = [data objectAtIndex:1];
        cell.detailTextLabel.font = [self.globalAppProperties.standardCellStyle objectForKey:@"font"];
        cell.detailTextLabel.textColor = [self.globalAppProperties.standardCellStyle objectForKey:@"color"];
        
        //general cell properties
        cell.backgroundColor = [self.globalAppProperties.standardCellStyle objectForKey:@"backgroundColor"];
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CALCUL_CELL_ID];
        cell.textLabel.text = CALCUL_CELL_TEXT;
        cell.backgroundColor = [self.globalAppProperties.calculateCellStyle objectForKey:@"backgroundColor"];
        cell.textLabel.font = [self.globalAppProperties.calculateCellStyle objectForKey:@"font"];
        cell.textLabel.textColor = [self.globalAppProperties.calculateCellStyle objectForKey:@"color"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *target = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        self.segueTitle = @"Origin";
        [self performSegueWithIdentifier:STOP_SELECT_SEGUE sender:target];
    }else if (indexPath.section == 1)
    {
        self.segueTitle = @"Destination";
        [self performSegueWithIdentifier:STOP_SELECT_SEGUE sender:target];
    }
    else if (indexPath.section == 2)
{
    [self displayPickerView];
}
    else if (indexPath.section == 3)
    {
        if([[self.origin objectForKey:@"stopName"] isEqualToString:POINTS_CELL_TEXT] || [[self.destin objectForKey:@"stopName"] isEqualToString:POINTS_CELL_TEXT] || [self.fareBracket isEqualToString:FAREBR_CELL_TEXT])
        {
            //[self updateCellSelectionColourWithCell:target andColour:[UIColor redColor]];
            
            //Validation code -- ensuring that the user has set all required values.
            if([[self.origin objectForKey:@"stopName"] isEqualToString:POINTS_CELL_TEXT]) [self displayErrorLabelWithMessage:@"Please choose an origin before continuing..."];
            else if([[self.destin objectForKey:@"stopName"] isEqualToString:POINTS_CELL_TEXT]) [self displayErrorLabelWithMessage:@"Please choose a destination before continuing..."];
            else if([self.fareBracket isEqualToString:FAREBR_CELL_TEXT]) [self displayErrorLabelWithMessage:@"Please choose a fare bracket before continuing..."];
        }else
        {
            //[self updateCellSelectionColourWithCell:target andColour:[UIColor blueColor]];
            target.selectionStyle = UITableViewCellSelectionStyleBlue;
            [self performSegueWithIdentifier:@"fareResultSegue" sender:target];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateCellSelectionColourWithCell:(UITableViewCell *)cell andColour:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:cell.frame];
    [view setBackgroundColor:color];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    cell.selectedBackgroundView = view;
}

- (void)displayErrorLabelWithMessage:(NSString *)message
{
    self.errLabel.text = message;
    [UIView animateWithDuration:1.0 animations:^{
        self.errLabel.alpha = 1.0;
    }];
    [UIView animateWithDuration:3.0 delay:3.0 options:UIViewAnimationOptionTransitionNone animations:^{
        self.errLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UIPickerViewDelegate
- (void)displayPickerView
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    //this makes the UIPickerView scroll to whatever is currently selected (or 0,0 if nothing is selected yet)
    int bracketInt = 0;
    int ticketsInt = 0;
    for (int i=0; i<[[self.fareBrackets objectAtIndex:0] count]; i++)
    {
        if([self.fareBracket isEqualToString:[[self.fareBrackets objectAtIndex:0] objectAtIndex:i]]) bracketInt = i;
    }
    for (int j=0; j<[[self.fareBrackets objectAtIndex:1] count]; j++)
    {
        if([self.ticketType isEqualToString:[[self.fareBrackets objectAtIndex:1] objectAtIndex:j]]) ticketsInt = j;
    }
    
    [self.pickerView selectRow:bracketInt inComponent:0 animated:NO];
    [self.pickerView selectRow:ticketsInt inComponent:1 animated:NO];
    
    [self.actionSheet addSubview:self.pickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
    closeButton.momentary = YES;
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blueColor];
    [closeButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:closeButton];
    
    [self.actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [self.actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (void)dismissPickerView
{
    self.fareBracket = [[self.fareBrackets objectAtIndex:0] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    self.ticketType = [[self.fareBrackets objectAtIndex:1] objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self.tableView reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //Create label for title
    UILabel *label;
    UIImageView *imgView;
    
    if(component == 0)
    {
        UIImage *image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png", [[self.fareBrackets objectAtIndex:0] objectAtIndex:row]] lowercaseString]];
        //Creating the image view that will hold our fare bracket images
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 30, 40)];
        [imgView setImage:image];
        label = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, 160, 40)];
    }else
    {
        label = label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, 40)];
    }
    
    label.text = [[self.fareBrackets objectAtIndex:component] objectAtIndex:row];
    label.textColor = [self.globalAppProperties.style1 objectForKey:[self.globalAppProperties.styleKeys objectAtIndex:1]];
    label.font = [self.globalAppProperties.style1 objectForKey:[self.globalAppProperties.styleKeys objectAtIndex:0]];
    label.backgroundColor = [UIColor clearColor];
    
    //Create UIView as a frame for label
    UIView *pickerViewRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    [pickerViewRow addSubview:label];
    if(component == 0) [pickerViewRow addSubview:imgView];
    
    return pickerViewRow;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.fareBrackets.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self.fareBrackets objectAtIndex:component] count];
}

- (IBAction)didChangeSelectedService:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        self.selectedService = @0;
        sender.enabled = NO;
        self.railServiceButton.enabled = YES;
    }else if(sender.tag == 1)
    {
        self.selectedService = @1;
        sender.enabled = NO;
        self.luasServiceButton.enabled = YES;
    }
}

#pragma mark - UIViewControllerLifeCycle
- (void)viewDidLoad
{
    self.fareBracket = FAREBR_CELL_TEXT;
    if (!self.origin)
    {
        self.origin = [self.defaultValues copy];
    }
    if (!self.destin)
    {
        self.destin = [self.defaultValues copy];
    }
    [self.tableView reloadData];
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 41.0, 35.0)];
    [logoImageView setImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:logoImageView];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil]];
    self.view.backgroundColor = self.globalAppProperties.backgroundColor;
    [self performSegueWithIdentifier:@"splashSegue" sender:self];
    [self didChangeSelectedService:self.luasServiceButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setErrLabel:nil];
    [self setLuasServiceButton:nil];
    [self setRailServiceButton:nil];
    [super viewDidUnload];
}
@end
