//
//  PickerViewPopoverViewController.m
//  What's My Fare
//
//  Created by Martin Tracey on 19/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "PickerViewPopoverViewController.h"

@implementation PickerViewPopoverViewController

- (PickerViewPopoverViewController *)initWithPickerView:(UIPickerView *)picker
{
    self = [super init];
    
    self.pickerView = picker;
    [self.view setBounds:self.pickerView.bounds];
    [self.view addSubview:self.pickerView];
    
    return self;
}

- (void)setDoneButton:(UISegmentedControl *)doneButton fromSender:(id)sender
{
    NSMutableArray *subviews = self.view.subviews.mutableCopy;
    [doneButton addTarget:sender action:@selector(dismissPickerView) forControlEvents:UIControlEventValueChanged];
    [subviews insertObject:doneButton atIndex:0];
    [self.pickerView removeFromSuperview];
    
    for (id obj in subviews) {
        [self.view addSubview:obj];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
