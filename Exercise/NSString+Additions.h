//
//  NSString+Additions.h
//  Exercise
//
//  Created by Nicola Miotto on 12/13/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (NSString *)readFromFile:(NSString *)fileName;
- (NSString *)JSONString;

@end
