//
//  User.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 16/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AModel.h"
#import "UserPackage.h"

@class User;
@protocol AuthDelegate <NSObject>

@optional
- (void)userLoginSuccessfull:(User *)user;
- (void)userLogin:(User *)user WithError:(id)Error StatusCode:(NSNumber*)statusCode;
- (void)userLogoutSuccessfull:(User *)user;
- (void)userLogout:(User *)user WithError:(NSDictionary*)Error;

- (void)userRegiserSuccessful:(User*)user;
- (void)userRegiserFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber*)statusCode;

- (void)userChangePasswordSuccessful:(User*)user;
- (void)userChangePasswordFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber*)statusCode;

- (void)userResetPasswordSuccessful:(User*)user;
- (void)userResetPasswordFailed:(User *)user WithError:(id)Error StatusCode:(NSNumber*)statusCode;

- (void)userPurchasePackageSucessful:(User *)user;
- (void)userPurchasePackageFailed:(User*)user WithError:(id)error StatusCode:(NSNumber*)statusCode;
- (void)userRenewPurchaseSucessful:(User *)user;
- (void)userRenewPurchaseFailed:(User*)user WithError:(id)error StatusCode:(NSNumber*)statusCode;
- (void)userTryPackageSucessful:(User *)user;
- (void)userTryPackageFailed:(User*)user WithError:(id)error StatusCode:(NSNumber*)statusCode;

- (void)userChangeProfileNameSucessful:(User*)user;
- (void)userChangeProfileNameFailed:(User*)user WithError:(id)error StatusCode:(NSNumber*)statusCode;

- (void)uploadAvatarSucessful:(User*)user;
- (void)uploadAvatarFailed:(User*)user WithError:(id)error StatusCode:(NSNumber*)statusCode;

- (void)refreshUserSucessful:(User*)user;
- (void)refreshUserFailed:(User*)user WithError:(id)error StatusCode:(NSNumber*)statusCode;
@end

@interface User : AModel
@property (nonatomic, weak) id <AuthDelegate> authDelegate;
@property (nonatomic, strong) NSString *profileName;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSDate * dob;
@property (nonatomic, readonly) NSString * fullName;
@property (nonatomic, readonly) NSString * auth;
@property (nonatomic, strong) NSNumber * credit;
@property (nonatomic, strong) NSString * facebookId;
@property (nonatomic, strong) NSString * ggpId;
@property (nonatomic, strong) NSString * avatarURL;
@property (nonatomic, strong) NSString * role;
@property (nonatomic, strong) NSString * ratingStatus;

+(NSString *) createRandomStringWithLength:(int) length;

- (void)userLoginWith:(NSString *)userName Password:(NSString *)password;
- (void)userLoginWith:(NSString *)userName fbId:(NSString *)fbId;
- (void)userLoginWith:(NSString *)userName ggpId:(NSString *)ggpId;
- (void)userLogout;

+ (User *)currentUser;
+ (void) loadCurrentUserToNSUserDefaults;

- (void)purchasePackage:(Package *)package;
- (void)tryPackage:(Package *)package;
- (void)renewPurchase:(UserPackage *)userPackage;

- (void)registerUserWithParam:(NSDictionary*)dictionary;

- (void)changePassword:(NSString *)oldPass NewPass:(NSString *) newPass;
- (void)resetPassword:(NSString *) username;

-(void)changeProfileName:(NSString *) newProfileName;
-(void)uploadImageWithURL:(NSURL *) imgURL;

-(void) refreshUser;

-(BOOL) canViewThisPackage:(Package *) pack;
@end
