//
//  RIMasterViewController.m
//  Exercise
//
//  Created by Nicola Miotto on 12/13/13.
//  Copyright (c) 2013 Rocket Internet. All rights reserved.
//

#import "RIMasterViewController.h"
#import "RIDetailViewController.h"
#import "RIItem.h"
#import "RIImage.h"

@interface RIMasterViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation RIMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.rowHeight = 50;
    [RIItem fetchCollectionWithBlock:^(NSArray *data) {
        self.dataSource = data;
        [self.tableView reloadData];
    } completeBlock:^(BOOL success, NSError *error) {
        if (!success) {
            [[[UIAlertView alloc] initWithTitle:error.domain
                                        message:error.description
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [self.dataSource objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    RIItem *object = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = object.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - From %@€", object.brand, object.price];
    cell.tag = [object.identifier integerValue];
    cell.imageView.frame = CGRectMake(4, 4, 42, 42);
    cell.imageView.backgroundColor = [UIColor lightGrayColor];
    cell.imageView.image = nil;
    
    NSInteger declarationTag = cell.tag;
    
    RIImage *image = object.defaultImage;
    
    if (!image.image) {
        [image fetchRemoteInBackgroundWithBlock:^(UIImage *fetchedImage){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (declarationTag == cell.tag) {
                    cell.imageView.image = fetchedImage;
                    [cell setNeedsDisplay];
                }
            });
        }];
    }
}

@end
