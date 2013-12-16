//
//  RIResponseMapper.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIResponseMapper.h"
#import "RIKeyEntityMapper.h"

@implementation RIResponseMapper
{
    dispatch_queue_t __mapperQueue;
}

- (id)init
{
    self = [super init];
    __mapperQueue = dispatch_queue_create("Item IO Queue", DISPATCH_QUEUE_SERIAL);
    
    return self;
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
    if ([data isKindOfClass:[NSDictionary class]]) {
        // Throw exception
    }
    
    // Take the first key
    BOOL success = [data[@"success"] boolValue];
    if (!success) {
        [NSException raise:@"Mapping error" format:@"Response is not successful"];
    }
            
    NSArray *resultsData = data[@"metadata"][@"results"];
    if (resultsData.count > 0) {
        Class resultsMapperClass = [[RIKeyEntityMapper defaultKeyEntityMapper] mapperForKey:@"results"];
        if (resultsMapperClass) {
            id mapper = [resultsMapperClass new];
            if ([mapper conformsToProtocol:@protocol(RIEntityMapper)]) {
                [mapper mapData:resultsData block:^(id result) {
                    // Extracted the object ids
                    successBlock(result);
                } failBlock:^(NSError *error) {
                    failBlock(error);
                }];
            }
        }
    }
}

@end
