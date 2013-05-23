//
//  PickerViewInActionSheetDelegate.h
//  What's My Fare
//
//  Created by Martin Tracey on 18/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <Foundation/Foundation.h>

struct PickerLocation{
    int b;
    int t;
};

typedef struct PickerLocation PickerLocation;

PickerLocation PickerLocationMake(int b, int t);

@class PickerViewInActionSheetDelegate;

@protocol PickerViewInActionSheetSenderDelegate <NSObject>
- (void)didDismissPickerViewWithPickerLocation:(PickerLocation)pickerLoc;
@end

@interface PickerViewInActionSheetDelegate : NSObject <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>
- (void)setPickerViewModel:(NSArray *)pickerViewModel;

- (void)displayPickerViewInView:(UIView *)view; //view can be nil if not iPad
- (void)getSelectedObjectsAndDismissPickerView;
@end
