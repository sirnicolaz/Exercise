//
//  RIAppDelegate.h
//  Exercise
//
//  Created by Nicola Miotto on 12/13/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
