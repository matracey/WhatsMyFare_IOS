//
//  FareUnitTests.m
//  FareUnitTests
//
//  Created by Martin Tracey on 12/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import "FareUnitTests.h"
#import <SenTestingKit/SenTestingKit.h>

@implementation FareUnitTests

- (void)setUp
{
    [super setUp];
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testLuasStopsIsEqual
{
    self.webService = [[FareAzureWebServices alloc] initWithTableName:@"LuasStops"];
    [self.webService.veldt readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if(totalCount != 0) self.firstItem = [items objectAtIndex:0];
        STAssertEquals([self.firstItem objectForKey:@"stopName"], @"Saggart", @"Verifying that the objects are being read correctly from the LuasStops table");
    }];
}

- (void)testLuasStopsIsNotEqual
{
    self.webService = [[FareAzureWebServices alloc] initWithTableName:@"LuasStops"];
    [self.webService.veldt readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if(totalCount != 0) self.firstItem = [items objectAtIndex:0];
        STAssertFalse([[self.firstItem objectForKey:@"stopName"] isEqual:@"Adamstown"], @"Making sure that we're getting Luas stops, not Rail stations!");
    }];
}

- (void)testLuasStopsIsNotNil
{
    self.webService = [[FareAzureWebServices alloc] initWithTableName:@"LuasStops"];
    [self.webService.veldt readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if(totalCount != 0) self.firstItem = [items objectAtIndex:0];
        STAssertNotNil(self.firstItem, @"Ensuring that the webservice isn't returning nil! (Very important to ensure that our app doesn't crash -- it will if this is nil)");
    }];
}

- (void)testDARTStationsIsEqual
{
    self.webService = [[FareAzureWebServices alloc] initWithTableName:@"RailStations"];
    [self.webService.veldt readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if(totalCount != 0) self.firstItem = [items objectAtIndex:0];
        STAssertEquals([self.firstItem objectForKey:@"stopName"], @"Adamstown", @"Verifying that the objects are being read correctly from the RailStations table");
    }];
}

- (void)testDARTStationsIsNotEqual
{
    self.webService = [[FareAzureWebServices alloc] initWithTableName:@"RailStations"];
    [self.webService.veldt readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if(totalCount != 0) self.firstItem = [items objectAtIndex:0];
        STAssertEquals([self.firstItem objectForKey:@"stopName"], @"Saggart", @"Verifying that the objects are being read correctly from the RailStations table");
    }];
}

- (void)testDARTStationsIsNotNil
{
    self.webService = [[FareAzureWebServices alloc] initWithTableName:@"RailStations"];
    [self.webService.veldt readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        if(totalCount != 0) self.firstItem = [items objectAtIndex:0];
        STAssertNotNil(self.firstItem, @"Ensuring that the webservice isn't returning nil! (Very important to ensure that our app doesn't crash -- it will if this is nil)");
    }];
}

@end
