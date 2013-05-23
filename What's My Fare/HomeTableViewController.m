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
#import "FareSplashScreenViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FareAppDelegate.h"
#import "PickerViewInActionSheetDelegate.h"

#define PRIMAR_CELL_ID @"primaryCell"
#define CALCUL_CELL_ID @"calculateButtonCell"
#define CALCUL_CELL_TEXT @"Calculate!"
#define POINTS_CELL_TEXT @"Choose a stop..."
#define FAREBR_CELL_TEXT @"Choose a fare bracket..."

#define SPLASH_SEGUE @"splashSegue"
#define RESULT_SEGUE @"fareResultSegue"
#define STOP_SELECT_SEGUE @"stopSelect"

#define ORIGIN_ERR @"Please choose an origin before continuing..."
#define DESTIN_ERR @"Please choose a destination before continuing..."
#define FAREBR_ERR @"Please choose a fare bracket before continuing..."

@interface HomeTableViewController ()
@property (strong, nonatomic) IBOutlet UILabel *errLabel;
@property (strong, nonatomic) IBOutlet UIButton *luasServiceButton; //0
@property (strong, nonatomic) IBOutlet UIButton *dartServiceButton; //1
@property (strong, nonatomic) IBOutlet UIButton *railServiceButton; //2

//Fare Bracket Selector Views
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (strong, nonatomic) UITableViewCell *bgView;
@property (strong, nonatomic) NSDictionary *defaultValues;
@property (strong, nonatomic) NSArray *model;
@property (strong, nonatomic) NSString *fareBracket;
@property (strong, nonatomic) NSString *ticketType;
@property (strong, nonatomic) NSArray *fareBrackets;
@property (strong, nonatomic) FareAppDelegate *globalAppProperties;

- (IBAction)didChangeSelectedService:(UIButton *)sender;
@end

@implementation HomeTableViewController

#pragma mark - UIProperty getters
- (UITableViewCell *)bgView
{
    if(!_bgView)
    {
        //Setting up the background view
        _bgView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CalculateSelected"];
        _bgView.backgroundColor = [UIColor colorWithRed:63.0/256.0 green:45.0/256.0 blue:147.0/256.0 alpha:1.0];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds= YES;
        _bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _bgView.layer.borderWidth = 1.0f;
    }
    return _bgView;
}

#pragma mark - Property getters
- (NSDictionary *)defaultValues
{
    return @{@"id":@"", @"stopName":POINTS_CELL_TEXT, @"service":@"", @"luasRoute":@""};
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

#pragma mark - Property setters
- (void)setOrigin:(NSMutableDictionary *)origin
{
    if([self.selectedService isEqual:@2])
    {
        //If we're setting the origin for Commuter Rail, we need to reset the value for destination.
        self.destin = self.defaultValues.copy;
        _origin = origin;
    }
    else _origin = origin;
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
        resultViewController.selectedService = self.selectedService.copy;
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
        label.backgroundColor = [UIColor clearColor];
        
        //Create UIView as a frame for label
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        view.backgroundColor = [UIColor clearColor];
        [view addSubview:label];
        
        return view;
    }
    else return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([self getScreenHeight] == 480){
        if(section != 3) return 34;
        else return 6;
    }else{
        if(section != 3)return 40;
        else return 12;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self getScreenHeight] == 480)
    {
        return 34;
    }else return UITableViewAutomaticDimension;
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
        if([self.selectedService isEqual:@0]) cell.detailTextLabel.text = [data objectForKey:@"service"];
        else cell.detailTextLabel.text = @"";
        cell.detailTextLabel.autoresizesSubviews = YES;
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
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if(![cell.detailTextLabel.text isEqual:FAREBR_CELL_TEXT])cell.imageView.image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png", [data objectAtIndex:0]] lowercaseString]];
        
        //general cell properties
        cell.backgroundColor = [self.globalAppProperties.standardCellStyle objectForKey:@"backgroundColor"];
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CALCUL_CELL_ID];
        cell.textLabel.text = CALCUL_CELL_TEXT;
        cell.backgroundColor = [self.globalAppProperties.calculateCellStyle objectForKey:@"backgroundColor"];
        cell.textLabel.font = [self.globalAppProperties.calculateCellStyle objectForKey:@"font"];
        cell.textLabel.textColor = [self.globalAppProperties.calculateCellStyle objectForKey:@"color"];
        
        //Now, set the selectedBackgroundView to be this new view
        cell.selectedBackgroundView = self.bgView;
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
        if([self isDeviceIdiomiPad])
        {
            id dvc = [[[self.splitViewController.viewControllers lastObject] viewControllers] lastObject];
            if (![dvc isKindOfClass:[StopSelectTableViewController class]]) {
                [[[[self.splitViewController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"stopSelectSegue" sender:target];
            }
            else if([dvc isKindOfClass:[StopSelectTableViewController class]] && [[dvc title] isEqual:@"Destination"])
            {
                [[dvc navigationController] popToRootViewControllerAnimated:NO];
                [[[[self.splitViewController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"stopSelectSegue" sender:target];
            }
        }
        else [self performSegueWithIdentifier:STOP_SELECT_SEGUE sender:target];
    }else if (indexPath.section == 1)
    {
        if([self.selectedService isEqual:@2] && [[self.origin objectForKey:@"stopName"] isEqual:POINTS_CELL_TEXT]) [self displayValidationErrorLabelWithMessage:ORIGIN_ERR];
        else{
            self.segueTitle = @"Destination";
            id dvc = [[[self.splitViewController.viewControllers lastObject] viewControllers] lastObject];
            if([self isDeviceIdiomiPad])
            {
                if (![dvc isKindOfClass:[StopSelectTableViewController class]]) {
                    [[[[self.splitViewController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"stopSelectSegue" sender:target];
                }
                else if([dvc isKindOfClass:[StopSelectTableViewController class]] && [[dvc title] isEqual:@"Origin"])
                {
                    [[dvc navigationController] popToRootViewControllerAnimated:NO];
                    [[[[self.splitViewController.viewControllers objectAtIndex:1] viewControllers] objectAtIndex:0] performSegueWithIdentifier:@"stopSelectSegue" sender:target];
                }
            }else [self performSegueWithIdentifier:STOP_SELECT_SEGUE sender:target];
        }
    }
    else if (indexPath.section == 2)
    {
        [self displayPickerView];
    }
    else if (indexPath.section == 3)
    {
        if([[self.origin objectForKey:@"stopName"] isEqualToString:POINTS_CELL_TEXT] || [[self.destin objectForKey:@"stopName"] isEqualToString:POINTS_CELL_TEXT] || [self.fareBracket isEqualToString:FAREBR_CELL_TEXT])
        {
            self.bgView.backgroundColor = [UIColor redColor];
            target.selectedBackgroundView = self.bgView;
            
            //Validation code -- ensuring that the user has set all required values.
            if([[self.origin objectForKey:@"stopName"] isEqualToString:POINTS_CELL_TEXT]) [self displayValidationErrorLabelWithMessage:ORIGIN_ERR];
            else if([[self.destin objectForKey:@"stopName"] isEqualToString:POINTS_CELL_TEXT]) [self displayValidationErrorLabelWithMessage:DESTIN_ERR];
            else if([self.fareBracket isEqualToString:FAREBR_CELL_TEXT]) [self displayValidationErrorLabelWithMessage:FAREBR_ERR];
        }else
        {
            self.bgView = nil;
            target.selectedBackgroundView = self.bgView;
            
            [self performSegueWithIdentifier:@"fareResultSegue" sender:target];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)displayValidationErrorLabelWithMessage:(NSString *)message
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

#pragma mark - Display and Dismiss PickerView
- (void)displayPickerView
{
    PickerViewInActionSheetDelegate *delegate = [[PickerViewInActionSheetDelegate alloc] init];
    [delegate setFareBrackets:self.fareBrackets.copy];
    
    CGRect pickerFrame = CGRectMake(0.0, 40.0, 320.0, 200.0);
    self.pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = delegate;
    self.pickerView.delegate = delegate;
    
    //Get the location of the currently selected bracket and scroll to it
    PickerLocation location = [self getPickerLocationForCurrentlySelectedFareBracket];
    [self.pickerView selectRow:location.b inComponent:0 animated:NO];
    [self.pickerView selectRow:location.t inComponent:1 animated:NO];
    
    //Create and add a done button
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:@[@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260.0, 7.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blueColor];
    [doneButton addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventValueChanged];
    
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select a Fare Bracket" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [self.actionSheet addSubview:self.pickerView];
    
    [self.actionSheet addSubview:doneButton];
    
    if([self isDeviceIdiomiPad])
    {
        //display actionsheet here
        [self.actionSheet showFromRect:CGRectMake(0.0, 360.0, 320.0, 200.0) inView:self.splitViewController.view animated:YES];
        [self.actionSheet sizeThatFits:CGSizeMake(320.0, 200.0)];
    }
    else{
        [self.actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        [self.actionSheet setBounds:CGRectMake(0.0, 0.0, 320.0, 485.0)];
    }
}

- (void)dismissPickerView
{
    self.fareBracket = [[self.fareBrackets objectAtIndex:0] objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    self.ticketType = [[self.fareBrackets objectAtIndex:1] objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self.tableView reloadData];
}

- (PickerLocation)getPickerLocationForCurrentlySelectedFareBracket
{
    //this makes the UIPickerView scroll to whatever is currently selected (or 0,0 if nothing is selected yet)
    int bracketInt = 0;
    int ticketsInt = 0;
    
    for (NSArray *a in self.fareBrackets) {
        for (int i = 0; i < a.count; i++) {
            if([[a objectAtIndex:i] isEqual:self.fareBracket]) bracketInt = i;
            else if([[a objectAtIndex:i] isEqual:self.ticketType]) ticketsInt = i;
        }
    }
    
//    for (int i=0; i<[[self.fareBrackets objectAtIndex:0] count]; i++)
//    {
//        if([self.fareBracket isEqualToString:[[self.fareBrackets objectAtIndex:0] objectAtIndex:i]]) bracketInt = i;
//    }
//    for (int j=0; j<[[self.fareBrackets objectAtIndex:1] count]; j++)
//    {
//        if([self.ticketType isEqualToString:[[self.fareBrackets objectAtIndex:1] objectAtIndex:j]]) ticketsInt = j;
//    }
    
    //Create and populate the PickerLocation to be returned
    PickerLocation location;
    location.b = bracketInt;
    location.t = ticketsInt;
    
    return location;
}

#pragma mark - Target-Action methods
- (IBAction)didChangeSelectedService:(UIButton *)sender
{
    if(sender.tag == 0)
    {
        //LUAS selected
        self.selectedService = @0;
        sender.enabled = NO;
        self.dartServiceButton.enabled = YES;
        self.railServiceButton.enabled = YES;
    }else if(sender.tag == 1)
    {
        //DART selected
        self.selectedService = @1;
        sender.enabled = NO;
        self.luasServiceButton.enabled = YES;
        self.railServiceButton.enabled = YES;
    }else if (sender.tag == 2)
    {
        //Commuter Rail selected
        self.selectedService = @2;
        sender.enabled = NO;
        self.luasServiceButton.enabled = YES;
        self.dartServiceButton.enabled = YES;
    }
    self.origin = self.defaultValues.copy;
    self.destin = self.defaultValues.copy;
    [self.tableView reloadData];
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
    
    if(![self isDeviceIdiomiPad]) [self performSegueWithIdentifier:@"splashSegue" sender:self];
    [self didChangeSelectedService:self.luasServiceButton];
}

- (BOOL)isDeviceIdiomiPad
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)return YES;
    else return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setErrLabel:nil];
    [self setLuasServiceButton:nil];
    [self setRailServiceButton:nil];
    [super viewDidUnload];
}

#pragma mark - 586hSupportMethods
- (CGFloat)getScreenHeight
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    return screenHeight;
}

@end
