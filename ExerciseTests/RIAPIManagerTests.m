//
//  RIAPIManagerTests.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RIAPIManager.h"
#import "Nocilla.h"
#import "NSString+Additions.h"

@interface RIAPIManagerTests : XCTestCase

@property (nonatomic, strong) RIAPIManager *apiManager;
@property (nonatomic, strong) NSURL *basePath;

@end

@implementation RIAPIManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.basePath = [NSURL URLWithString:@"http://test.com/mobileAPIs"];
    self.apiManager = [[RIAPIManager alloc] initWithBasePath:self.basePath];
    [[LSNocilla sharedInstance] start];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [[LSNocilla sharedInstance] stop];
    [super tearDown];
}

- (void)testGetResource
{
    NSString *resource = @"test";
    NSString *completePath = [NSString stringWithFormat:@"%@/%@", self.basePath, resource];
    
    NSString *fakeJSONResponse = @"{\"item\":{\"name\":\"Test\", \"price\":42}}";
    stubRequest(@"GET", completePath).andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody(fakeJSONResponse);
    
    StartBlock();
    [self.apiManager get:resource
              parameters:nil
            successBlock:^(id data) {
                EndBlock();
            }
               failBlock:^(NSError *error) {
                   EndBlock();
                   XCTFail(@"Failed to get resource");
               }
     ];
    WaitUntilBlockCompletes();
}

@end
