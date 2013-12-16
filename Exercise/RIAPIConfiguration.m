//
//  RIAPIConfiguration.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIAPIConfiguration.h"
#import "RIAPIManager.h"
#import "RIKeyEntityMapper.h"

@implementation RIAPIConfiguration

+ (void)configure
{
    RIAPIManager *manager = [[RIAPIManager alloc] initWithBasePath:[NSURL URLWithString:@"http://theiconic.bugfoot.de/mobile-api"]];
    [RIAPIManager setDefaultAPIManager:manager];
    
    RIKeyEntityMapper *mapper = [RIKeyEntityMapper new];
    NSString *pathBundle = [[NSBundle mainBundle] pathForResource:@"KeyEntityMapping" ofType:@"plist"];
    mapper.dataBase = [[NSDictionary alloc] initWithContentsOfFile:pathBundle];
    [RIKeyEntityMapper setDefaultKeyEntityMapper:mapper];
}

@end
