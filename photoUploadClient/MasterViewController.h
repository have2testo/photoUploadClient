//
//  MasterViewController.h
//  photoUploadClient
//
//  Created by saku on 2013/02/19.
//  Copyright (c) 2013年 canon-its. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class UserListController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) UserListController *userListController;
- (IBAction)updateUserListAction:(id)sender;

@end
