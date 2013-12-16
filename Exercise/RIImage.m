//
//  RIImage.m
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIImage.h"

static NSOperationQueue *imagesQueue;
static NSCache *imagesCache; // To save IO from hard drive

@implementation RIImage

@dynamic remotePath;
@dynamic localPath;
@dynamic item;

+ (void)initialize
{
    imagesQueue = [[NSOperationQueue alloc] init];
    imagesQueue.name = @"Images queue";
    imagesQueue.maxConcurrentOperationCount = 5;
    
    imagesCache = [[NSCache alloc] init];
    imagesCache.countLimit = 15;
}

- (UIImage *)image
{
    UIImage *cached = [imagesCache objectForKey:self.localPath];
    if (cached) {
        return cached;
    }
    else if(self.localPath) {
        UIImage *image = [self imageFromDisk];
        [imagesCache setObject:image forKey:self.localPath];
        return image;
    }
    
    return nil;
}

- (UIImage *)imageFromDisk
{
    NSData *data  = [NSData dataWithContentsOfFile:self.localPath
                                           options:NSDataReadingUncached
                                             error:nil];
    UIImage *img = [UIImage imageWithData:data];
    return img;
}

// Returns the local path
- (NSString *)storeImageLocally:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:self.remotePath.lastPathComponent];
    
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
        return nil;
    }
    
    return imagePath;
}

- (void)fetchRemoteInBackgroundWithBlock:(void(^)(UIImage *image))completeBlock
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.remotePath]];
    [NSURLConnection sendAsynchronousRequest:request queue:imagesQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSManagedObjectContext *currentMO = [NSManagedObjectContext MR_contextForCurrentThread];
        RIImage *selfInContext = [self MR_inContext:currentMO];
        UIImage *image= [UIImage imageWithData:data];
        selfInContext.localPath = [selfInContext storeImageLocally:image];
        [currentMO MR_saveOnlySelfAndWait];
        [imagesCache setObject:image forKey:selfInContext.localPath];
        completeBlock(image);
    }];
}

@end
