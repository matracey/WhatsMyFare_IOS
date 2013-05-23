//
//  PickerViewInActionSheetDelegate.m
//  What's My Fare
//
//  Created by Martin Tracey on 18/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "PickerViewInActionSheetDelegate.h"
#import "FareAppDelegate.h"
#import "PickerViewPopoverViewController.h"

PickerLocation PickerLocationMake(int b, int t){
    PickerLocation pickerLoc;
    pickerLoc.b = b;
    pickerLoc.t = t;
    return pickerLoc;
}

@interface PickerViewInActionSheetDelegate()
@property (weak, nonatomic) NSArray *pickerViewModel;
@property (strong, nonatomic) FareAppDelegate *globalAppProperties;
@property (strong, nonatomic) id<PickerViewInActionSheetSenderDelegate> delegate;
@property (strong, nonatomic) NSArray *pickerViewImages;

@property (strong, nonatomic) UIPickerView  *picker;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *popover;
@end

@implementation PickerViewInActionSheetDelegate
#pragma mark - Property getters
- (FareAppDelegate *)globalAppProperties
{
    if(!_globalAppProperties) _globalAppProperties = [[FareAppDelegate alloc] init];
    return _globalAppProperties;
}

- (NSArray *)pickerViewImages
{
    if(!_pickerViewImages)
    {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (NSString *s in [self.pickerViewModel objectAtIndex:0]) {
            UIImage *image = [UIImage imageNamed:[[NSString stringWithFormat:@"%@.png", s] lowercaseString]];
            if(image) [arr addObject:image];
        }
        _pickerViewImages = arr.copy;
    }
    return _pickerViewImages;
}

- (NSArray *)pickerViewModel
{
    return  [[NSArray alloc] initWithObjects:
            [[NSArray alloc] initWithObjects:@"Adult", @"Child", @"Student", nil],
            [[NSArray alloc] initWithObjects:@"Single", @"Return", nil], nil];
    //return @[@[@"Adult", @"Child", @"Student"],@[@"Single", @"Return"]];
}

#pragma mark - Property setters
- (void)setPickerViewModel:(NSArray *)pickerViewModel
{
//    if(_pickerViewModel != pickerViewModel)
//    {
//        _pickerViewModel = pickerViewModel;
//    }
}

- (void)setDelegate:(id<PickerViewInActionSheetSenderDelegate>)delegate
{
    if([delegate conformsToProtocol:@protocol(PickerViewInActionSheetSenderDelegate)])
    {
        _delegate = delegate;
    }
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //Create label for title
    UILabel *label;
    UIImageView *imgView;
    UIView *pickerViewRow;

    if(view)
    {
        return view;
    }
    else{
        if(component == 0)
        {
            //Creating the image view that will hold our fare bracket images
            
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 30, 40)];
            [imgView setImage:[self.pickerViewImages objectAtIndex:row]];
            label = [[UILabel alloc] initWithFrame:CGRectMake(42, 0, 160, 40)];
        }else
        {
            label = label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 160, 40)];
        }
        
        label.text = [[self.pickerViewModel objectAtIndex:component] objectAtIndex:row];
        label.textColor = [self.globalAppProperties.style1 objectForKey:[self.globalAppProperties.styleKeys objectAtIndex:1]];
        label.font = [self.globalAppProperties.style1 objectForKey:[self.globalAppProperties.styleKeys objectAtIndex:0]];
        label.backgroundColor = [UIColor clearColor];
        
        //Create UIView as a frame for label
        pickerViewRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
        [pickerViewRow addSubview:label];
        if(component == 0) [pickerViewRow addSubview:imgView];
        return pickerViewRow;
    }
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return [[self.pickerViewModel objectAtIndex:component] objectAtIndex:row];
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.pickerViewModel.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self.pickerViewModel objectAtIndex:component] count];
}

- (void)displayPickerViewInView:(UIView *)view
{
    CGRect pickerFrame = CGRectMake(0.0, 40.0, 320.0, 400.0);
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    picker.showsSelectionIndicator = YES;
    picker.dataSource = self;
    picker.delegate = self;
    
    //Get the location of the currently selected bracket and scroll to it
    [self scrollPickerView:picker toPickerLocation:PickerLocationMake(0, 0) animated:NO];
    
    //Create and add a done button
    UISegmentedControl *doneButton = [[UISegmentedControl alloc] initWithItems:@[@"Done"]];
    doneButton.momentary = YES;
    doneButton.frame = CGRectMake(260.0, 5.0f, 50.0f, 30.0f);
    doneButton.segmentedControlStyle = UISegmentedControlStyleBar;
    doneButton.tintColor = [UIColor blueColor];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[PickerViewPopoverViewController alloc] initWithPickerView:picker]];
        PickerViewPopoverViewController *popoverVC = (PickerViewPopoverViewController *)popover.contentViewController;
        [popoverVC setDoneButton:doneButton fromSender:self];
        
        [popover setPopoverContentSize:CGSizeMake(320.0, 220.0)];
        [popover presentPopoverFromRect:CGRectMake(0.0, 190.0, 320.0, 220.0)
                                 inView:view
               permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.popover = popover;
        self.picker  = picker;
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select a Fare Bracket"
                                                                 delegate:nil
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [doneButton addTarget:self action:@selector(getSelectedObjectsAndDismissPickerView) forControlEvents:UIControlEventValueChanged];
        [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [actionSheet addSubview:picker];
        [actionSheet addSubview:doneButton];
        [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        [actionSheet setBounds:CGRectMake(0.0, 0.0, 320.0, 485.0)];
        self.actionSheet = actionSheet;
        self.picker = picker;
    }
}

- (void)getSelectedObjectsAndDismissPickerView
{
    PickerLocation pickerLoc;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        PickerViewPopoverViewController *popoverVC = (PickerViewPopoverViewController *)self.popover.contentViewController;
        self.picker = popoverVC.pickerView;
        pickerLoc = PickerLocationMake([self.picker selectedRowInComponent:0], [self.picker selectedRowInComponent:1]);
        [self.popover dismissPopoverAnimated:YES];
    }
    else
    {
        pickerLoc = PickerLocationMake([self.picker selectedRowInComponent:0], [self.picker selectedRowInComponent:1]);
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    }
    [self.delegate didDismissPickerViewWithPickerLocation:pickerLoc];
}

- (void)scrollPickerView:(UIPickerView *)picker toPickerLocation:(PickerLocation)pickerLocation animated:(BOOL)animated
{
    [picker selectRow:pickerLocation.b inComponent:0 animated:animated];
    [picker selectRow:pickerLocation.t inComponent:1 animated:animated];
}

@end
