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
#define DEFAULT_TABLE @"LuasStops"

@interface FareAzureWebServices ()
@property (strong, nonatomic) FareAppDelegate *appDelegate;
@property (strong, nonatomic) NSString *table;
@end

@implementation FareAzureWebServices

- (FareAzureWebServices *)init
{
    return [self initWithTableName:DEFAULT_TABLE];
}

- (FareAzureWebServices *)initWithTableName:(NSString *)tableName
{
    self = [super init];
    self.table = [tableName copy];
    self.client = [MSClient clientWithApplicationURLString:AZURE_SERVICE_URL  withApplicationKey:AZURE_SERVICE_KEY];
    self.veldt = [self.client getTable:tableName];
    
    return self;
}

- (MSClient *)client
{
    if(!_client) _client = [MSClient clientWithApplicationURLString:AZURE_SERVICE_URL withApplicationKey:AZURE_SERVICE_KEY];
    return _client;
}

- (MSTable *)luasTable
{
    if(!_veldt) [self.client getTable:self.table];
    return _veldt;
}

@end
