//
//  HomeTableViewController.h
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>

struct PickerLocation{
    int b;
    int t;
};

typedef struct PickerLocation PickerLocation;

@interface HomeTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableDictionary *origin;
@property (strong, nonatomic) NSMutableDictionary *destin;
@property (strong, nonatomic) NSString *segueTitle;
@property (strong, nonatomic) NSNumber *selectedService; //0 for Luas, 1 for DART, 2 for Rail

- (NSArray *)model;
@end
