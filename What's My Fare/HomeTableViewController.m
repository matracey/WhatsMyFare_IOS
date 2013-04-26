//
//  HomeTableViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "HomeTableViewController.h"

#define PRIMAR_CELL_ID @"primaryCell"
#define CALCUL_CELL_ID @"calculateButtonCell"
#define CALCUL_CELL_TEXT @"Calculate!"
#define ORIGIN_CELL_TEXT @"Choose an origin..."
#define DESTIN_CELL_TEXT @"Choose a destination..."

@interface HomeTableViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSDictionary *defaultValues;
@property (strong, nonatomic) NSArray *fareBrackets;
@property (strong, nonatomic) NSString *fareBracket;
@property (strong, nonatomic) NSString *segueTitle;
@property (strong, nonatomic) NSArray *model; //
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@end

@implementation HomeTableViewController

#pragma mark - Init methods
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {        
        //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:117 green:4 blue:32 alpha:1];
    }
    return self;
}

#pragma mark - Property getters
- (NSArray *)fareBrackets
{
    return @[@"Adult", @"Child", @"Student"];
}

- (NSString *)fareBracket
{
    if(!_fareBracket)
    {
        _fareBracket = @"Choose a fare bracket...";
    }
    return _fareBracket;
}

- (NSArray *)model
{
    return @[self.origin, self.destin, self.fareBracket, CALCUL_CELL_TEXT];
}

- (NSDictionary *)defaultValues
{
    return @{@"id":@"", @"stopName":@"Choose a stop...", @"luasLine":@"", @"luasRoute":@""};
}

#pragma mark - Segue methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    if ([segue.destinationViewController isKindOfClass:[UIViewController class]])
    {
        UIViewController *stopSelect = segue.destinationViewController;
        stopSelect.title = self.segueTitle;
        
    }else NSLog(@"Err: Segue did not execute correctly.");
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titles = @[@"Origin", @"Destination", @"Fare Bracket"];
    if(section != 3) return titles[section];
    else return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id data = [self.model objectAtIndex:[indexPath section]];
    
    // Configure the cell...
    if([data isKindOfClass:[NSDictionary class]])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:PRIMAR_CELL_ID forIndexPath:indexPath];
        cell.textLabel.text = [data objectForKey:@"stopName"];
        cell.detailTextLabel.text = [data objectForKey:@"luasLine"];
    }else if ([data isKindOfClass:[NSString class]] && indexPath.section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:PRIMAR_CELL_ID forIndexPath:indexPath];
        cell.textLabel.text = data;
    }else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CALCUL_CELL_ID forIndexPath:indexPath];
        cell.textLabel.text = CALCUL_CELL_TEXT;
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
        [self performSegueWithIdentifier:@"stopSelect" sender:target];
    }else if (indexPath.section == 1)
    {
        self.segueTitle = @"Destination";
        [self performSegueWithIdentifier:@"stopSelect" sender:target];
    }
    else if (indexPath.section == 2)
{
    [self displayPickerView];
}
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    NSInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    self.fareBracket = [self.fareBrackets objectAtIndex:selectedRow];
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [self.tableView reloadData];
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.fareBrackets objectAtIndex:row];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.fareBrackets.count;
}


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
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
