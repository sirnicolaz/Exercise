//
//  RISimple.h
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RISimple : NSManagedObject

@property (nonatomic, retain) NSString * cachingHash;
@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSManagedObject *item;

@end
