//
//  RISimpleMapper.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RISimpleMapper.h"
#import "RISimple.h"

@implementation RISimpleMapper

#pragma mark - Private

- (RISimple *)itemForObjectData:(NSDictionary *)objData
                    inContext:(NSManagedObjectContext *)context
{
    NSDictionary *meta = objData[@"meta"];
    
    RISimple *simple = [RISimple MR_createInContext:context];
    simple.sku = meta[@"sku"];
    
    simple.price = @([meta[@"price"] floatValue]);
    simple.cachingHash = meta[@"caching_hash"];
    simple.quantity = @([meta[@"quantity"] integerValue]);
    simple.size = meta[@"size"];
    
    return simple;
}


#pragma mark - Public

- (void)mapData:(id)data block:(DidParseData)successBlock failBlock:(ParseDidFail)failBlock
{
    // TODO: no really needed for this test, but in case one need to parse a simple
    // object in background, this method should be implemented
}

- (id)mapData:(id)data
{
    NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSMutableSet *items = [NSMutableSet new];
    for (NSString *objectKey in [data allKeys]) {
        NSDictionary *content = data[objectKey];
        [items addObject:[self itemForObjectData:content inContext:backgroundContext]];
    }
    
    [backgroundContext MR_saveOnlySelfAndWait];
    
    return items;
}

@end
