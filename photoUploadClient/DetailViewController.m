//
//  DetailViewController.m
//  photoUploadClient
//
//  Created by saku on 2013/02/19.
//  Copyright (c) 2013年 canon-its. All rights reserved.
//

#import "DetailViewController.h"
#import "User.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController
@synthesize imageView;
@synthesize textFieldTitle;


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.title = self.detailItem.name;
    }
    if(self.imageView) {
        self.imageView.image = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
//    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    barButtonItem.title = NSLocalizedString(@"きりかえ", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)showCamera:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)postImage:(id)sender {
    if (self.imageView.image != nil) {
        HTTPFileUpload *httpFileUpload = [[HTTPFileUpload alloc]init];
        httpFileUpload.delegate = self;
        [httpFileUpload setPostString:self.textFieldTitle.text withPostName:@"title"];
        [httpFileUpload setPostImage:self.imageView.image withPostName:@"photo" fileName:@"Icon.png"];
        [httpFileUpload setPostUserId:self.detailItem.studentId withPostName:@"user_id"];
        [httpFileUpload postWithUri:@"http://pure-escarpment-3405.herokuapp.com/galleries/photo.json"];
        httpFileUpload = nil;
        
        [self showAlertView:@"確認" willShowAlertBodyMessage:@"登録しました"];
        
    } else {
        [self showAlertView:@"確認" willShowAlertBodyMessage:@"写真を撮影してから、もう一度実行してください"];
    }

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showModalView
{
    UIView *modalView = [[UIView alloc] initWithFrame:self.view.frame];
    modalView.opaque = NO;
    modalView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f];
    [self.view addSubview:modalView];
    
}

- (void) showAlertView:(NSString *)showAlertTitleMessage willShowAlertBodyMessage:(NSString *)showAlertBodyMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:showAlertTitleMessage message:showAlertBodyMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textFieldValue
{
    [self.textFieldTitle resignFirstResponder];
    return YES;
}

@end
