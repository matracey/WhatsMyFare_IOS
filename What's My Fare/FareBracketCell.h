//
//  FareBracketCell.h
//  What's My Fare
//
//  Created by Martin Tracey on 06/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FareBracketCell : UITableViewCell
@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UILabel *detailTextLabel;

- (FareBracketCell *)initWithSampleCell:(UITableViewCell *)sample fromTableView:(UITableView *)tableView;
@end
