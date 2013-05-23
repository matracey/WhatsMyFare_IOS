//
//  PickerViewPopoverViewController.h
//  What's My Fare
//
//  Created by Martin Tracey on 19/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewPopoverViewController : UIViewController
@property (strong, nonatomic) UIPickerView *pickerView;


- (PickerViewPopoverViewController *)initWithPickerView:(UIPickerView *)picker;
- (void)setDoneButton:(UISegmentedControl *)doneButton fromSender:(id)sender;
@end
