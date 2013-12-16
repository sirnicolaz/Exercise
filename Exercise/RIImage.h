//
//  RIImage.h
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RIImage : NSManagedObject

@property (nonatomic, retain) NSString * remotePath;
@property (nonatomic, retain) NSString * localPath;
@property (nonatomic, retain) NSManagedObject *item;
@property (nonatomic, strong, readonly) UIImage *image;

- (void)fetchRemoteInBackgroundWithBlock:(void(^)(UIImage *image))completeBlock;

@end
