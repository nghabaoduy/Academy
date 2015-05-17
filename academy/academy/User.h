//
//  User.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"

@class User;
@protocol AuthDelegate <NSObject>

@optional
- (void)userLoginSuccessfull:(User *)user;
- (void)userLogin:(User *)user WithError:(id)Error StatusCode:(NSNumber*)statusCode;
- (void)userLogoutSuccessfull:(User *)user;
- (void)userLogout:(User *)user WithError:(NSDictionary*)Error;
@end

@interface User : AModel
@property (nonatomic, weak) id <AuthDelegate> authDelegate;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSDate * dob;
@property (nonatomic, readonly) NSString * fullName;
@property (nonatomic, readonly) NSString * auth;

- (void)userLoginWith:(NSString *)userName Password:(NSString *)password;
- (void)userLogout;

+ (id)currentUser;

@end
