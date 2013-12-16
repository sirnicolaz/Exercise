//
//  RIKeyEntityMapper.h
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RIKeyEntityMapper : NSObject

@property (nonatomic, strong) NSDictionary *dataBase;

+ (void)setDefaultKeyEntityMapper:(RIKeyEntityMapper *)keyEntityManager;
+ (id)defaultKeyEntityMapper;

/* Nil if no mapper is found */
- (Class)mapperForKey:(NSString *)key;

@end
