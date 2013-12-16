//
//  RIImageMapperTests.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RIImageMapper.h"
#import "RIImage.h"

@interface RIImageMapperTests : XCTestCase
@property (nonatomic, strong) RIImageMapper *mapper;
@end

@implementation RIImageMapperTests

+ (void)setUp
{
    [super setUp];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
}

+ (void)tearDown
{
    [super tearDown];
    [MagicalRecord cleanUp];
}

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.mapper = [[RIImageMapper alloc] init];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testMapSingleObject
{
    NSArray *fakeObj = @[@{
                              @"path": @"http://magratea"
                            }
                          ];
    
    NSSet *images = [self.mapper mapData:fakeObj];
    NSString *generatedPath = (NSString *)[[images anyObject] remotePath];
    XCTAssert([generatedPath isEqualToString:@"http://magratea"], @"Image path not properly initialized");
}

- (void)testMapCollection
{
    NSArray *fakeObj = @[@{
                             @"path": @"http://42"
                             },
                         @{
                             @"path": @"http://magratea"
                             }
                         ];
    
    NSSet *images = [self.mapper mapData:fakeObj];
    XCTAssertEqual(images.count, 2U, @"Images not parsed correctly");
}

@end
