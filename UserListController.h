//
//  UserListController.h
//  photoUploadClient
//
//  Created by saku on 2013/02/19.
//  Copyright (c) 2013年 canon-its. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserListController : NSObject

@property (nonatomic, readonly) NSArray *userList;

- (id)initWithArray:(NSArray *)array;
- (id)initWithUserUrl:(NSString *)userUrl;

@end
