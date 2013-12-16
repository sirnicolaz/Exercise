//
//  RISimpleMapperTests.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RISimpleMapper.h"
#import "RISimple.h"

@interface RISimpleMapperTests : XCTestCase
@property (nonatomic, strong) RISimpleMapper *mapper;
@end

@implementation RISimpleMapperTests

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
    self.mapper = [[RISimpleMapper alloc] init];
}

- (void)testMapSingleObject
{
    NSArray *fakeObj = @[@{@"AT482AA14KIN-281809": @{
                                   @"meta": @{
                                           @"sku": @"AT482AA14KIN-281809",
                                           @"price": @22.95,
                                           @"caching_hash": @"116b251f2d014d132080a22d77099e90",
                                           @"shipment_cost_item": @0.00,
                                           @"shipment_cost_order": @0.00,
                                           @"tax_percent": @10.00,
                                           @"quantity": @25,
                                           @"cost": @8.70,
                                           @"size_brand": @12,
                                           @"size": @"L",
                                           @"size_position": @134,
                                           @"dispatch_time": @"4 Business Days",
                                           @"dispatch_time_position": @13,
                                           @"3hours_shipment_available": @YES,
                                           @"estimated_delivery": @"4 Business Days",
                                           @"estimated_delivery_position": @13
                                           },
                                   @"attributes": @{
                                           @"sort_order": @0,
                                           @"size": @"L"
                                           }
                                   }
                           }];
    NSSet *simples = [self.mapper mapData:fakeObj];
    RISimple *simple = (RISimple *)[simples anyObject];
    // We test with the different data type the object can have
    XCTAssert([simple.sku isEqualToString:@"AT482AA14KIN-281809"], @"SKU not initialized according to data");
    XCTAssertEqual(simple.price.floatValue, 22.95f, @"Price not initialized according to data");
}

- (void)testMapCollection
{
    NSArray *fakeObj = @[@{@"AT482AA14KIN-281809": @{
                                   @"meta": @{
                                           @"sku": @"AT482AA14KIN-281809",
                                           @"price": @22.95,
                                           @"caching_hash": @"116b251f2d014d132080a22d77099e90",
                                           @"shipment_cost_item": @0.00,
                                           @"shipment_cost_order": @0.00,
                                           @"tax_percent": @10.00,
                                           @"quantity": @25,
                                           @"cost": @8.70,
                                           @"size_brand": @12,
                                           @"size": @"L",
                                           @"size_position": @134,
                                           @"dispatch_time": @"4 Business Days",
                                           @"dispatch_time_position": @13,
                                           @"3hours_shipment_available": @YES,
                                           @"estimated_delivery": @"4 Business Days",
                                           @"estimated_delivery_position": @13
                                           },
                                   @"attributes": @{
                                           @"sort_order": @0,
                                           @"size": @"L"
                                           }
                                   }
                           },
                         @{@"AT482AA14KIN-281810": @{
                                   @"meta": @{
                                           @"sku": @"AT482AA14KIN-281810",
                                           @"price": @22.95,
                                           @"caching_hash": @"116b25234f2d014d132080a22d77099e90",
                                           @"shipment_cost_item": @0.00,
                                           @"shipment_cost_order": @0.00,
                                           @"tax_percent": @10.00,
                                           @"quantity": @25,
                                           @"cost": @8.70,
                                           @"size_brand": @12,
                                           @"size": @"L",
                                           @"size_position": @134,
                                           @"dispatch_time": @"4 Business Days",
                                           @"dispatch_time_position": @13,
                                           @"3hours_shipment_available": @YES,
                                           @"estimated_delivery": @"4 Business Days",
                                           @"estimated_delivery_position": @13
                                           },
                                   @"attributes": @{
                                           @"sort_order": @0,
                                           @"size": @"L"
                                           }
                                   }
                           }];
    
    NSSet *simples = [self.mapper mapData:fakeObj];
    XCTAssertEqual(simples.count, 2U, @"Simples not parsed correctly");
}

@end
