//
//  RIItemMapper.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIItemMapper.h"
#import "RIItem.h"
#import "RISimple.h"
#import "RIKeyEntityMapper.h"

@implementation RIItemMapper
{
    dispatch_queue_t __mapperQueue;
}

- (id)init
{
    self = [super init];
    __mapperQueue = dispatch_queue_create("Item IO Queue", DISPATCH_QUEUE_SERIAL);
    
    return self;
}


#pragma mark - Private

- (NSSet *)objectIdsForManagedObjects:(NSSet *)managedObjects
{
    NSMutableSet *set = [NSMutableSet new];
    for (NSManagedObject *mo in managedObjects) {
        [set addObject:[mo objectID]];
    }
    
    return set;
}

- (RIItem *)itemForObjectData:(NSDictionary *)objData
                    inContext:(NSManagedObjectContext *)context
{
    RIItem *item = [RIItem MR_createInContext:context];
    item.identifier = @([objData[@"id"] integerValue]);
    
    NSDictionary *data = objData[@"data"];
    
    item.sku = data[@"sku"];
    item.name = data[@"name"];
    item.itemDescription = data[@"description"];
    item.brand = data[@"brand"];
    item.maxPrice = @([data[@"max_price"] floatValue]);
    item.price = @([data[@"price"] floatValue]);
    
    id simplesMapperClass = [[RIKeyEntityMapper defaultKeyEntityMapper] mapperForKey:@"simples"];
    if (simplesMapperClass){
        id mapper = [simplesMapperClass new];
        if ([mapper conformsToProtocol:@protocol(RIEntityMapper)]) {
            NSSet *simples = [mapper mapData:data[@"simples"]];
            [item addSimples:simples];
        }
    }
    
    id imagesMapperClass = [[RIKeyEntityMapper defaultKeyEntityMapper] mapperForKey:@"images"];
    if (imagesMapperClass){
        id mapper = [imagesMapperClass new];
        if ([mapper conformsToProtocol:@protocol(RIEntityMapper)]) {
            NSSet *images = [mapper mapData:objData[@"images"]];
            [item addImages:images];
        }
    }
    
    item.defaultImage = [item.images anyObject];
    
    return item;
}

#pragma mark - Public

- (id)mapData:(id)data
{
    // TODO: no really needed for this test, but in case one need to parse a simple
    // object in background, this method should be implemented
    
    return nil;
}

- (void)mapData:(id)data
          block:(DidParseData)successBlock
      failBlock:(ParseDidFail)failBlock
{
    // For now we always expect an array
    if (![data isKindOfClass:[NSArray class]]) {
        [NSException raise:@"Mapping error" format:@"Error mapping Item data. List (NSArray) required."];
    }
    
    // Take the first key
    dispatch_async(__mapperQueue, ^{
        @try {
            NSManagedObjectContext *backgroundContext = [NSManagedObjectContext MR_contextForCurrentThread];
            
            NSMutableSet *items = [NSMutableSet new];
            for (NSDictionary *objectData in data) {
                [items addObject:[self itemForObjectData:objectData inContext:backgroundContext]];
            }
            
            [backgroundContext MR_saveOnlySelfAndWait];
            // Extracted the object ids
            successBlock([self objectIdsForManagedObjects:items]);
        }
        @catch (NSException *exception) {
            NSError *error = [NSError errorWithDomain:exception.description code:42 userInfo:nil];
            failBlock(error);
        }
    });
}

@end
