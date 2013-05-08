//
//  FareResultsViewController.h
//  What's My Fare
//
//  Created by Martin Tracey on 28/04/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FareResultsViewController : UIViewController
@property (strong, nonatomic) NSArray *model; //data model set by HomeTableViewController
@property (strong, nonatomic) NSNumber *selectedService; //0 is Luas, 1 is DART, 2 is Commuter Rail
@end
