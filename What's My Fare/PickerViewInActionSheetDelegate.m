//
//  PickerViewInActionSheetDelegate.m
//  What's My Fare
//
//  Created by Martin Tracey on 18/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "PickerViewInActionSheetDelegate.h"
#import "FareAppDelegate.h"

@interface PickerViewInActionSheetDelegate()
@property (weak, nonatomic) NSArray *fareBrackets;
@property (strong, nonatomic) FareAppDelegate *globalAppProperties;
@end

@implementation PickerViewInActionSheetDelegate
#pragma mark - Property getters
- (FareAppDelegate *)globalAppProperties
{
    if(!_globalAppProperties) _globalAppProperties = [[FareAppDelegate alloc] init];
    return _globalAppProperties;
}

#pragma mark - Property setters
- (void)setFareBrackets:(NSArray *)fareBrackets
{
    if(_fareBrackets != fareBrackets)
    {
        _fareBrackets = fareBrackets;
    }
}

#pragma mark - UIPickerViewDelegate
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



@end
