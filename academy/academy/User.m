//
//  User.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "User.h"
#import <AFNetworking/AFNetworking.h>

@implementation User {
    NSDictionary * userDict;
}

static User * _currentUser = nil;

+ (id)currentUser {
    return _currentUser;
}

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    userDict = dict;
    self.modelId = dict[@"id"];
    _firstName = dict[@"first_name"]?: @"N/A";
    _lastName = dict[@"last_name"]?: @"N/A";
    _email = dict[@"email"] ?: @"N/A";
    _userName = dict[@"username"] ?: @"N/A";
    
}

- (NSString *)auth {
    return userDict[@"auth"];
}

- (NSString *)fullName {
    NSArray * newArray = @[_firstName , _lastName];
    return [newArray componentsJoinedByString:@" "];
}

- (void)userLoginWith:(NSString *)userName Password:(NSString *)password {
    
    NSDictionary * params = @{
                              @"username" : userName,
                              @"password" : password
                              };
    
    NSString *apiPath = @"api/login";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _currentUser = self;
        [self setObjectWithDictionary:responseObject];
        [self.authDelegate userLoginSuccessfull:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userLogin:self WithError:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

- (void)userLogout {
    _currentUser = nil;
}

@end
