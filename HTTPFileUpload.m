//
//  HTTPFileUpload.m
//  photoUploadClient
//
//  Created by saku on 2013/02/24.
//  Copyright (c) 2013年 canon-its. All rights reserved.
//


#import "HTTPFileUpload.h"

#define KEY_POST_NAME            @"postName"
#define KEY_POST_USER_ID         @"postUserId"
#define KEY_POST_STRING          @"postString"
#define KEY_POST_IMAGE           @"postImage"
#define KEY_POST_IMAGE_FILE_NAME @"postImageFileName"

#define BOUNDARY                 @"----iOSAppsFormBoundaryByHTTPFileUpload"


@implementation HTTPFileUpload
@synthesize delegate;

- (id)init {
    self = [super init];
    if (self) {
        postStrings_ = [[NSMutableArray alloc] initWithCapacity:0];
        postImages_ = [[NSMutableArray alloc] initWithCapacity:0];
        postUserIds_ = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)setPostString:(NSString *)stringValue
         withPostName:(NSString *)postName
{
    NSDictionary *stringDictionary;
    stringDictionary = [NSDictionary dictionaryWithObjectsAndKeys:stringValue, KEY_POST_STRING,
                        postName, KEY_POST_NAME, nil];
    [postStrings_ addObject:stringDictionary];
}

- (void)setPostImage:(UIImage *)image
        withPostName:(NSString *)postName
            fileName:(NSString *)fileName
{
    NSDictionary *imageDictionary;
    imageDictionary = [NSDictionary dictionaryWithObjectsAndKeys:image, KEY_POST_IMAGE,
                       postName, KEY_POST_NAME,
                       fileName, KEY_POST_IMAGE_FILE_NAME, nil];
    [postImages_ addObject:imageDictionary];
}

- (void)setPostUserId:(NSString *)userId withPostName:(NSString *)postName
{
    NSDictionary *userIdDictionary;
    userIdDictionary = [NSDictionary dictionaryWithObjectsAndKeys:userId, KEY_POST_USER_ID,
                        postName, KEY_POST_NAME, nil];
    [postUserIds_ addObject:userIdDictionary];
}

- (void)postWithUri:(NSString *)uri
{
	NSMutableData *postData = [[NSMutableData alloc] init];
    
    // Create string userId data.
    for (NSDictionary *userIdDictionary in postUserIds_) {
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",
                               [userIdDictionary objectForKey:KEY_POST_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"%@\r\n",
                               [userIdDictionary objectForKey:KEY_POST_USER_ID]] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    // Create string data.
    for (NSDictionary *stringDictionary in postStrings_) {
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",
                               [stringDictionary objectForKey:KEY_POST_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"%@\r\n",
                               [stringDictionary objectForKey:KEY_POST_STRING]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Create image data.
    NSRegularExpression *regExp;
    NSTextCheckingResult *match;
    NSError *error = nil;
    regExp = [NSRegularExpression regularExpressionWithPattern:@"[.](?:jpg|jpeg)$"
                                                       options:NSRegularExpressionCaseInsensitive
                                                         error:&error];
    NSData *imageData;
    NSString *contentType;
    for (NSDictionary *imageDictionary in postImages_) {
        match = [regExp firstMatchInString:[imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME]
                                   options:0
                                     range:NSMakeRange(0, [[imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME] length])];
        if (match != nil) {
            imageData = UIImageJPEGRepresentation([imageDictionary objectForKey:KEY_POST_IMAGE], 1.0f);
            contentType = @"image/jpeg";
        } else {
            imageData = UIImagePNGRepresentation([imageDictionary objectForKey:KEY_POST_IMAGE]);
            contentType = @"image/png";
        }
        
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                               [imageDictionary objectForKey:KEY_POST_NAME],
                               [imageDictionary objectForKey:KEY_POST_IMAGE_FILE_NAME]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n", contentType] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:imageData];
        [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];


    // Post data.
    NSMutableURLRequest *request;
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:uri]
                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                        timeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	[request setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
	[request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY] forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    resultData_ = [[NSMutableData alloc] initWithCapacity:0];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


#pragma mark - NSURLConnection delegate.
- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    if ([delegate_ respondsToSelector:@selector(httpFileUpload:didFailWithError:)]) {
        [delegate_ httpFileUpload:connection didFailWithError:error];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    resultData_ = nil;
    [connection cancel];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    [resultData_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *result = [[NSString alloc] initWithData:resultData_ encoding:NSUTF8StringEncoding];
    if ([delegate_ respondsToSelector:@selector(httpFileUploadDidFinishLoading:result:)]) {
        [delegate_ httpFileUploadDidFinishLoading:connection result:result];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    resultData_ = nil;
    [connection cancel];
}

@end
