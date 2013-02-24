//
//  HTTPFileUpload.h
//  photoUploadClient
//
//  Created by saku on 2013/02/24.
//  Copyright (c) 2013年 canon-its. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HTTPFileUploadDelegate;
@interface HTTPFileUpload : NSObject
{
@private
    id <HTTPFileUploadDelegate> delegate_;
    NSMutableArray *postStrings_, *postImages_, *postUserIds_;
    NSMutableData *resultData_;
}
@property(nonatomic, assign) id <HTTPFileUploadDelegate> delegate;

- (void)setPostString:(NSString *)stringValue withPostName:(NSString *)postName;
- (void)setPostImage:(UIImage *)image withPostName:(NSString *)postName fileName:(NSString *)fileName;
- (void)setPostUserId:(NSString *)userId withPostName:(NSString *)postName;
- (void)postWithUri:(NSString *)uri;
@end

@protocol HTTPFileUploadDelegate <NSObject>
@required
- (void)httpFileUploadDidFinishLoading:(NSURLConnection *)connection result:(NSString *)result;
@optional
- (void)httpFileUpload:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
