//
//  FareAzureWebServices.m
//  What's My Fare
//
//  Created by Martin Tracey on 09/03/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FareAzureWebServices.h"
#import "FareAppDelegate.h"

#define AZURE_SERVICE_URL @"https://whats-my-fare.azure-mobile.net"
#define AZURE_SERVICE_KEY @"RCegDxlgLbeqphBsIBONspgchGaofN19"
#define AZURE_SERVICE_DB  @"LuasStops"

@interface FareAzureWebServices ()
@property (strong, nonatomic) FareAppDelegate *appDelegate;
@end

@implementation FareAzureWebServices

- (FareAzureWebServices *)init
{
    self.client = [MSClient clientWithApplicationURLString:AZURE_SERVICE_URL  withApplicationKey:AZURE_SERVICE_KEY];
    self.stopsDataTable = [self.client getTable:AZURE_SERVICE_DB];
    
    return self;
}

- (MSClient *)client
{
    if(!_client) _client = [MSClient clientWithApplicationURLString:AZURE_SERVICE_URL withApplicationKey:AZURE_SERVICE_KEY];
    return _client;
}

- (MSTable *)luasTable
{
    if(!_stopsDataTable) [self.client getTable:AZURE_SERVICE_DB];
    return _stopsDataTable;
}

@end
