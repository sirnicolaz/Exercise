//
//  RIAPIManager.h
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchDidFail) (NSError *error);
typedef void (^FetchDidComplete) (id data);

@interface RIAPIManager : NSObject

@property (nonatomic, strong) NSURL *basePath;

+ (void)setDefaultAPIManager:(RIAPIManager *)apiManager;
+ (id)defaultAPIManager;

- (id)initWithBasePath:(NSURL *)basePath;

- (void)get:(NSString *)resourceName
 parameters:(NSDictionary *)parameters
successBlock:(FetchDidComplete)successBlock
  failBlock:(FetchDidFail)failBlock;

@end
