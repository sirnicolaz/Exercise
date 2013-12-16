//
//  RIKeyEntityMapper.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIKeyEntityMapper.h"

static RIKeyEntityMapper *defaultKeyEntityMapper;

@implementation RIKeyEntityMapper

+ (void)setDefaultKeyEntityMapper:(RIKeyEntityMapper *)keyEntityMapper
{
    defaultKeyEntityMapper = keyEntityMapper;
}

+ (id)defaultKeyEntityMapper
{
    return defaultKeyEntityMapper;
}

- (Class)mapperForKey:(NSString *)key
{
    NSString *classString = self.dataBase[key];
    return NSClassFromString(classString);
}

@end
