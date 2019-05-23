//
//  PointziTests.m
//  PointziTests
//
//  Created by Mahipal Kummari on 22/05/19.
//  Copyright © 2019 Mahipal Kummari. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ServerModel.h"
#import "PZTooltipObj.h"

@interface PointziTests : XCTestCase
{
    ServerModel * _serviceStub;
   
}
@property XCTestExpectation * expectation;
@end

@implementation PointziTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
_serviceStub = [[ServerModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void) testGetJsonDataTask {
    
    _expectation = [self expectationWithDescription:@"parser"];
    
    NSString * testUrlString = @"https://dummyapi.io/api/post?limit=1";
    
    [_serviceStub getJSONData:testUrlString andCompletionHandler:^(PZTooltipObj * toolTipObj) {
        NSString * testFirstName = @"Julio";
        NSString * expectedFirstName = toolTipObj.firstName;
        XCTAssertEqualObjects(testFirstName, expectedFirstName);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
