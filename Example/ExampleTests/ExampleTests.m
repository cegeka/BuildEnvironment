//
//  ExampleTests.m
//  ExampleTests
//
//  Created by Sabbe Jan on 22/05/14.
//  Copyright (c) 2014 Cegeka. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BEConfig.h"

@interface ExampleTests : XCTestCase

@end

@implementation ExampleTests

- (void)testBEConfigConfiguration {
    XCTAssertEqualObjects(@"http://localhost:8080/rest", BEConfig.configuration[@"backend_url"], @"");
    XCTAssertEqualObjects(@"support@cegeka.be", BEConfig.configuration[@"support_email"], @"");
    XCTAssertEqualObjects(@"Debug", BEConfig.configuration.currentConfiguration, @"");
}

@end
