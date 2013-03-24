//
//  FareAzureWebServices.h
//  What's My Fare
//
//  Created by Martin Tracey on 09/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>

@interface FareAzureWebServices : NSObject

@property (strong, nonatomic) MSTable *luasTable;
@property (strong, nonatomic) MSClient *client;

@end
