//
//  RIMasterViewController.h
//  Exercise
//
//  Created by Nicola Miotto on 12/13/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface RIMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
