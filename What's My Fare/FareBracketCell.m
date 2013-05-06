//
//  FareBracketCell.m
//  What's My Fare
//
//  Created by Martin Tracey on 06/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FareBracketCell.h"
#import "FareAppDelegate.h"

@interface FareBracketCell ()
{
    CGRect sampleCellFrame;
    CGRect sampleTextLabelFrame;
    CGRect sampleDetailTextLabelFrame;
}
@property (strong, nonatomic) FareAppDelegate *globalAppProperties;
@end

@implementation FareBracketCell
@synthesize textLabel = textLabel;
@synthesize detailTextLabel = detailTextLabel;

- (FareAppDelegate *)globalAppProperties
{
    if(!_globalAppProperties)
    {
        _globalAppProperties = [[FareAppDelegate alloc] init];
    }
    return _globalAppProperties;
}

- (FareBracketCell *)initWithSampleCell:(UITableViewCell *)sample fromTableView:(UITableView *)tableView
{
    self = [super initWithFrame:sample.frame];
    sampleCellFrame = sample.frame;
    sampleTextLabelFrame = sample.textLabel.frame;
    sampleDetailTextLabelFrame = sample.detailTextLabel.frame;
    self.backgroundColor = self.globalAppProperties.backgroundColor;
    return self;
}

- (UILabel *)textLabel
{
    if(!textLabel)
    {
        CGRect cellFrame = self.frame;
        CGFloat yPos = (cellFrame.size.height-40)/2;
        if(self.image) textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.image.frame.size.width+40, yPos, 200, 40)];
        else textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, yPos, 200, 40)];
        textLabel.text = @"Choose a fare bracket...";
        textLabel.font = [self.globalAppProperties.standardCellStyle objectForKey:@"font"];
        textLabel.textColor = [self.globalAppProperties.standardCellStyle objectForKey:@"color"];
        textLabel.backgroundColor = [UIColor clearColor];
    }
    return textLabel;
}

- (UILabel *)detailTextLabel
{
    if(!detailTextLabel)
    {
        CGRect cellFrame = self.frame;
        CGFloat yPos = (cellFrame.size.height-40)/2;
        detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, yPos, 80, 40)];
        detailTextLabel.font = [self.globalAppProperties.standardCellStyle objectForKey:@"font"];
        detailTextLabel.textColor = [self.globalAppProperties.standardCellStyle objectForKey:@"color"];
        detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    return detailTextLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
