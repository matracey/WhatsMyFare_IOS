//
//  FareUnitTests.h
//  FareUnitTests
//
//  Created by Martin Tracey on 12/05/2013.
//  Copyright (c) 2013 Martin Tracey. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "FareAzureWebServices.h"

@interface FareUnitTests : SenTestCase
@property (strong, nonatomic) FareAzureWebServices *webService;
@property (strong, nonatomic) NSDictionary *firstItem;
@end
