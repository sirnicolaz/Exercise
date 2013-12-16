//
//  RIEntityMapper.h
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DidParseData) (id result);
typedef void (^ParseDidFail) (NSError *error);

@protocol RIEntityMapper <NSObject>

@required

// Asynchronous version
// Sent to a background thread
// It must return a set of core data object ids
- (void)mapData:(id)data
          block:(DidParseData)successBlock
      failBlock:(ParseDidFail)failBlock;

// Synchronous version
// Snychronized on the same thread as the caller
// It must return a set of core data managed objects
- (id)mapData:(id)data;

@end
