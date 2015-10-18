//
//  SaltSidetestTests.m
//  SaltSidetestTests
//
//  Created by Sajjeel Khilji on 10/16/15.
//  Copyright (c) 2015 Saltside. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "JSONWebServiceRequest.h"
#import "Constants.h"

@interface SaltSidetestTests : XCTestCase
@property NSArray *jsonResponse;
@end

@implementation SaltSidetestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testWebServicePerformace
{
    
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"SALTSide Expectations"];
    // [self measureBlock:^{
    // Put the code you want to measure the time of here.
    NSURL *url = [NSURL URLWithString:kRequestURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    JSONWebServiceRequest *jsonRequestOperation = [JSONWebServiceRequest JSONWebServiceRequestWithRequest:request success:^(AFHTTPRequestOperation *operation, NSArray *responseObject) {
        
        
        self.jsonResponse = responseObject;

        dispatch_async(dispatch_get_main_queue() , ^(void) {
            XCTAssert(1,@"pass");
            [expectation fulfill];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        dispatch_async(dispatch_get_main_queue(),^(void){
            //show some error
            XCTFail("Response was not NSHTTPURLResponse");
            XCTAssertNil(error);
            [expectation fulfill];
        });
    }];
    
    [jsonRequestOperation start];
    [self waitForExpectationsWithTimeout:2.0 handler:^(NSError *error) {
        if (error) {
            XCTFail("taking time more than 2.0 secs");
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
    
    XCTAssertNotNil(self.jsonResponse, @"invalid test data");
    for(NSDictionary*dict in self.jsonResponse)
    {
        XCTAssertEqual(dict.count, 3, @"ARGUMENTS COUNT should be 3");
    }

}

@end
