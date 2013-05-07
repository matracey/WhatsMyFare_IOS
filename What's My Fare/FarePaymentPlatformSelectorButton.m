//
//  FarePaymentPlatformSelectorButton.m
//  What's My Fare
//
//  Created by Martin Tracey on 07/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FarePaymentPlatformSelectorButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation FarePaymentPlatformSelectorButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Let's establish the midpoint of the view.
    CGPoint midpoint;
    midpoint.x = self.bounds.origin.x + (self.bounds.size.width/2);
    midpoint.y = self.bounds.origin.y + (self.bounds.size.height/2);
    
    //Now, let's establish the size of the view.
    CGFloat size = (self.bounds.size.width / 2);
    if(self.bounds.size.height < self.bounds.size.width) size = (self.bounds.size.height / 2);
    CGContextSetLineWidth(context, 1.0);
    
    [[UIColor blackColor] setStroke];
    
    self.layer.borderColor = CGColorRef
}

@end
