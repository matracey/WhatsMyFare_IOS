//
//  StopSelectTableViewController.h
//  What's My Fare
//
//  Created by Martin Tracey on 07/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StopSelectTableViewController : UITableViewController
@property (strong, nonatomic) NSNumber *selectedService; //0 is Luas, 1 is DART, 2 is Commuter Rail
@end
