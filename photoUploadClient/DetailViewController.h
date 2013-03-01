//
//  DetailViewController.h
//  photoUploadClient
//
//  Created by saku on 2013/02/19.
//  Copyright (c) 2013年 canon-its. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPFileUpload.h"

@class User;

@interface DetailViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) User *detailItem;

//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTitle;

- (IBAction)showCamera:(id)sender;
- (IBAction)postImage:(id)sender;

@end
