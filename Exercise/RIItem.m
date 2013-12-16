//
//  RIItem.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIItem.h"
#import "RIImage.h"
#import "RISimple.h"
#import "RIAPIManager.h"

@implementation RIItem

@dynamic name;
@dynamic sku;
@dynamic price;
@dynamic maxPrice;
@dynamic itemDescription;
@dynamic brand;
@dynamic identifier;
@dynamic images;
@dynamic simples;
@dynamic defaultImage;

+ (void)fetchCollectionWithBlock:(DidFetchData)fetchBlock
                   completeBlock:(DidComplete)completeBlock
{
    NSManagedObjectContext *mainMO = [NSManagedObjectContext MR_defaultContext];
    NSArray *collection = [RIItem MR_findAllSortedBy:@"price" ascending:YES inContext:mainMO];
    fetchBlock(collection);
    
    RIAPIManager *manager = [RIAPIManager defaultAPIManager];
    
    [manager get:@"womens-clothing"
      parameters:nil
    successBlock:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *collection = [RIItem MR_findAllSortedBy:@"price" ascending:YES inContext:mainMO];
            fetchBlock(collection);
            completeBlock(YES, nil);
        });
    } failBlock:^(NSError *error) {
        completeBlock(NO, error);
    }];
}

+ (void)fetchCollectionSortedBy:(RISortParameter)sortParameter
                      direction:(BOOL)ascending
                     fetchBlock:(DidFetchData)fetchBlock
                  completeBlock:(DidComplete)completeBlock
{
    NSString *sorting;
    switch (sortParameter) {
        case RISortParameterBrand:
            sorting = @"brand";
            break;
        case RISortParameterPrice:
            sorting = @"price";
            break;
        case RISortParameterName:
            sorting = @"name";
            break;
        case RISortParameterPopularity:
            sorting = @"popularity";
            break;
    }
    
    NSArray *collection = [RIItem MR_findAllSortedBy:sorting ascending:ascending];
    fetchBlock(collection);
    
    RIAPIManager *manager = [RIAPIManager defaultAPIManager];
    NSDictionary *params = @{
                             @"page": @1,
                             @"sort": sorting,
                             @"dir": (ascending ? @"asc" : @"desc"),
                             @"maxitems": @42
                             };
    [manager get:@"womens-clothing"
      parameters:params
    successBlock:^(id data) {
        NSArray *collection = [RIItem MR_findAllSortedBy:sorting ascending:YES];
        fetchBlock(collection);
        completeBlock(YES, nil);
    } failBlock:^(NSError *error) {
        completeBlock(YES, error);
    }];
}

@end
