//
//  PickerViewPopoverViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 19/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "PickerViewPopoverViewController.h"

@interface PickerViewPopoverViewController ()
{
    UIPickerView *pickerView;
}

@end

@implementation PickerViewPopoverViewController

- (PickerViewPopoverViewController *)initWithPickerView:(UIPickerView *)picker
{
    self = [super init];
    
    pickerView = picker;
    [self.view setBounds:pickerView.bounds];
    [self.view addSubview:pickerView];
    
    return self;
}

- (void)setDoneButton:(UISegmentedControl *)doneButton
{
    NSMutableArray *subviews = self.view.subviews.mutableCopy;
    [subviews insertObject:doneButton atIndex:0];
    [pickerView removeFromSuperview];
    
    for (id obj in subviews) {
        [self.view addSubview:obj];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
