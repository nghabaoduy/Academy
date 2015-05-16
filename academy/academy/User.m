//
//  User.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "User.h"

@implementation User

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    _firstName = dict[@"first_name"]?: @"N/A";
    _lastName = dict[@"last_name"]?: @"N/A";
    _email = dict[@"email"] ?: @"N/A";
    _userName = dict[@"username"] ?: @"N/A";
}

- (NSString *)fullName {
    NSArray * newArray = @[_firstName , _lastName];
    return [newArray componentsJoinedByString:@" "];
}

- (void)userLoginWith:(NSString *)userName Password:(NSString *)password {
    
}

- (void)userLogout {
    
}

@end
