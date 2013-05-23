//
//  PickerViewInActionSheetDelegate.h
//  What's My Fare
//
//  Created by Martin Tracey on 18/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerViewInActionSheetDelegate : NSObject <UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>
- (void)setFareBrackets:(NSArray *)fareBrackets;
@end
