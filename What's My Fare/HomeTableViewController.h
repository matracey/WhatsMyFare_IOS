//
//  HomeTableViewController.h
//  What's My Fare
//
//  Created by Martin Tracey on 03/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableDictionary *origin;
@property (strong, nonatomic) NSMutableDictionary *destin;
@end
