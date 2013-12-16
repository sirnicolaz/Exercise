//
//  RIImageMapper.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIImageMapper.h"
#import "RIImage.h"

@implementation RIImageMapper

#pragma mark - Private

- (RIImage *)itemForObjectData:(NSDictionary *)objData
                      inContext:(NSManagedObjectContext *)context
{
    RIImage *image = [RIImage MR_createInContext:context];
    image.remotePath = objData[@"path"];
    
    return image;
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
    for (NSDictionary *objectData in data) {
        [items addObject:[self itemForObjectData:objectData inContext:backgroundContext]];
    }
    
    [backgroundContext MR_saveOnlySelfAndWait];
    
    return items;
}

@end
