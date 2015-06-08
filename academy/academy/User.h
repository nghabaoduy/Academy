//
//  User.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"
#import "Package.h"

@class User;
@protocol AuthDelegate <NSObject>

@optional
- (void)userLoginSuccessfull:(User *)user;
- (void)userLogin:(User *)user WithError:(id)Error StatusCode:(NSNumber*)statusCode;
- (void)userLogoutSuccessfull:(User *)user;
- (void)userLogout:(User *)user WithError:(NSDictionary*)Error;

- (void)userRegiserSuccessful:(User*)user;
- (void)userRegiserFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber*)statusCode;



- (void)userPurchasePackageSucessful:(User *)user;
- (void)userPurchasePackageFailed:(User*)user WithError:(id)error StatusCode:(NSNumber*)statusCode;
- (void)userTryPackageSucessful:(User *)user;
- (void)userTryPackageFailed:(User*)user WithError:(id)error StatusCode:(NSNumber*)statusCode;
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
@property (nonatomic, strong) NSNumber * credit;

- (void)userLoginWith:(NSString *)userName Password:(NSString *)password;
- (void)userLogout;

+ (id)currentUser;

- (void)purchasePackage:(Package *)package;
- (void)tryPackage:(Package *)package;

- (void)registerUserWithParam:(NSDictionary*)dictionary;
@end
