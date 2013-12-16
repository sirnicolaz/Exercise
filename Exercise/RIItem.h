//
//  RIItem.h
//  Exercise
//
//  Created by Nicola Miotto on 12/15/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^DidFetchData) (NSArray *data);
typedef void (^DidComplete) (BOOL success, NSError *error);

typedef enum {
    RISortParameterPopularity,
    RISortParameterPrice,
    RISortParameterBrand,
    RISortParameterName
} RISortParameter;

@class RIImage, RISimple;

@interface RIItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sku;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * maxPrice;
@property (nonatomic, retain) NSString * itemDescription;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) NSSet *simples;
@property (nonatomic, retain) RIImage *defaultImage;

+ (void)fetchCollectionWithBlock:(DidFetchData)fetchBlock
                   completeBlock:(DidComplete)completeBlock;

+ (void)fetchCollectionSortedBy:(RISortParameter)sortParameter
                      direction:(BOOL)ascending
                     fetchBlock:(DidFetchData)fetchBlock
                  completeBlock:(DidComplete)completeBlock;


@end

@interface RIItem (CoreDataGeneratedAccessors)

- (void)addImagesObject:(RIImage *)value;
- (void)removeImagesObject:(RIImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addSimplesObject:(RISimple *)value;
- (void)removeSimplesObject:(RISimple *)value;
- (void)addSimples:(NSSet *)values;
- (void)removeSimples:(NSSet *)values;

@end
