//
//  UserListController.m
//  photoUploadClient
//
//  Created by saku on 2013/02/19.
//  Copyright (c) 2013年 canon-its. All rights reserved.
//

#import "UserListController.h"
#import "User.h"

@implementation UserListController

- (id)initWithArray:(NSArray *)array
{
    self = [super init];
    
    if(self != nil) {
        NSMutableArray *userArray = [ NSMutableArray arrayWithCapacity:[array count]];
        
        for (NSDictionary *user in array ) {
            User *newuser = [[User alloc] init];
            
            newuser.studentId = [user objectForKey:@"_id"];
            newuser.name = [user objectForKey:@"name"];
            newuser.password = [user objectForKey:@"password"];
            newuser.email = [user objectForKey:@"email"];
            newuser.gradeNo = [user objectForKey:@"grade_no"];
            newuser.classNo = [user objectForKey:@"class_no"];
            newuser.gender = [user objectForKey:@"gender"];
            
            [userArray addObject:newuser];
        }
        
        _userList = userArray;
    }
    return self;
}

- (id)initWithUserUrl:(NSString *)userUrl
{
    NSURL *url = [NSURL URLWithString:userUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *userData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSArray *userObject = [NSJSONSerialization JSONObjectWithData:userData options:NSJSONReadingAllowFragments error:nil];
    
    self = [self initWithArray:userObject];
    
    return self;
    
}

@end
