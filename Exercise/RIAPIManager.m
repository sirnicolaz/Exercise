//
//  RIAPIManager.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIAPIManager.h"
#import "RIResponseMapper.h"

static RIAPIManager *defaultAPIManager;

@implementation RIAPIManager
{
    NSOperationQueue *__queue;
}

+ (void)setDefaultAPIManager:(RIAPIManager *)apiManager
{
    defaultAPIManager = apiManager;
}

+ (id)defaultAPIManager
{
    return defaultAPIManager;
}

- (id)initWithBasePath:(NSURL *)basePath
{
    self = [super init];
    self.basePath = basePath;
    __queue = [[NSOperationQueue alloc] init];
    __queue.maxConcurrentOperationCount = 4;
    __queue.name = @"HTTP Requests Queue";
    
    return self;
}

#pragma mark - Private

- (NSURL *)apiURLForResource:(NSString *)resourceName
                  parameters:(NSDictionary *)parameters
{
    NSMutableString *flatParameters = [NSMutableString new];
    if (parameters.count > 0) {
        [flatParameters insertString:@"?" atIndex:0];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [flatParameters appendFormat:@"%@=%@", key, obj];
        }];
    }
    
    NSString *completePath = [NSString stringWithFormat:@"%@/%@%@", self.basePath, resourceName, flatParameters];
    
    return [NSURL URLWithString:completePath];
}

#pragma mark - Public

- (void)get:(NSString *)resourceName parameters:(NSDictionary *)parameters successBlock:(FetchDidComplete)successBlock
  failBlock:(FetchDidFail)failBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[self apiURLForResource:resourceName
                                                                      parameters:parameters]];
    [NSURLConnection sendAsynchronousRequest:request
                                    queue:__queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (!connectionError) {
                                   NSError *parseError;
                                   id jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                                                 options:0
                                                                                   error:&parseError];
                                   if (!parseError) {
                                       RIResponseMapper *mapper = [[RIResponseMapper alloc] init];
                                       [mapper mapData:jsonData
                                                 block:^(id result) {
                                                     successBlock(jsonData);
                                                 }
                                             failBlock:^(NSError *error) {
                                                 failBlock(parseError);
                                             }
                                        ];
                                   }
                                   else {
                                       failBlock(parseError);
                                   }
                                   
                               }
                               else {
                                   failBlock(connectionError);
                               }
                           }
     ];
}

@end
