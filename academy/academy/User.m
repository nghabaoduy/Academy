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
    //NSLog(@"user dict = %@",dict);
    userDict = dict;
    self.modelId = dict[@"id"];
    _email = [self getStringFromDict:dict WithKey:@"email"];
    _userName =[self getStringFromDict:dict WithKey:@"username"];
    _credit = [self getNumberFromDict:dict WithKey:@"credit"];
    _profileName = [self getStringFromDict:dict WithKey:@"profile_name"];
    _facebookId = [self getStringFromDict:dict WithKey:@"facebook_id"];
    _ggpId = [self getStringFromDict:dict WithKey:@"ggp_id"];
    _avatarURL = dict[@"imgURL"] ?:(dict[@"asset"] != [NSNull null] ? dict[@"asset"][@"index"] : nil);
    _role = [self getStringFromDict:dict WithKey:@"role"];
    _ratingStatus = [self getStringFromDict:dict WithKey:@"rating_status"];//ENUM('notyet','rated','refuse')
}

-(NSDictionary *)getDictionaryFromObject
{
    return @{@"id" : self.modelId ?: @"",
             @"email" : _email ?: @"",
             @"username" : _userName ?: @"",
             @"credit": _credit,
             @"profile_name":_profileName?:@"",
             @"facebook_id":_facebookId?:@"",
             @"ggp_id":_ggpId?:@"",
             @"role":_role?:@"",
             @"rating_status":_ratingStatus
             };
}
- (NSString *)auth {
    return userDict[@"auth"];
}

- (NSString *)fullName {
    NSArray * newArray = @[_firstName , _lastName];
    return [newArray componentsJoinedByString:@" "];
}

- (void)userLoginWith:(NSString *)userName Password:(NSString *)password {
    NSLog(@"User Login With Username and Password");
    NSDictionary * params = @{
                              @"username" : userName,
                              @"password" : password
                              };
    
    NSString *apiPath = @"api/login";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        _currentUser = self;
        [self setObjectWithDictionary:responseObject];
        [self saveCurrentUserToNSUserDefaults];
        [self.authDelegate userLoginSuccessfull:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userLogin:self WithError:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}
- (void)userLoginWith:(NSString *)userName fbId:(NSString *)fbId {
    NSLog(@"User Login With Username and fbId");
    NSDictionary * params = @{
                              @"username" : userName,
                              @"facebook_id" : fbId
                              };
    
    NSString *apiPath = @"api/loginWithFBId";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         _currentUser = self;
         [self setObjectWithDictionary:responseObject];
         [self saveCurrentUserToNSUserDefaults];
         [self.authDelegate userLoginSuccessfull:self];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
         NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
         id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         [self.authDelegate userLogin:self WithError:json[@"message"] StatusCode:@([operation.response statusCode])];
     }];
}
- (void)userLoginWith:(NSString *)userName ggpId:(NSString *)ggpId{
    NSLog(@"User Login With Username and ggpId");
    NSDictionary * params = @{
                              @"username" : userName,
                              @"ggp_id" : ggpId
                              };
    
    NSString *apiPath = @"api/loginWithGGPId";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         _currentUser = self;
         [self setObjectWithDictionary:responseObject];
         [self saveCurrentUserToNSUserDefaults];
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

- (void)purchasePackageWithId:(NSString *)packageId {
   
}

- (void)tryPackageWithId:(NSString *)packagedId {
    
}

- (void)tryPackage:(Package *)package {
    NSDictionary * params = @{
                              @"user_id" : self.modelId,
                              @"package_id" : package.modelId
                              };
    
    NSString *apiPath = @"api/tryPackage";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.authDelegate userTryPackageSucessful:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userTryPackageFailed:self WithError:json StatusCode:@([operation.response statusCode])];
    }];
}

- (void)purchasePackage:(Package *)package {
    NSDictionary * params = @{
                              @"user_id" : self.modelId,
                              @"package_id" : package.modelId
                              };
    
    NSString *apiPath = @"api/purchasePackage";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _credit =@([_credit intValue] - [package.price intValue]);
        [self.authDelegate userPurchasePackageSucessful:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userPurchasePackageFailed:self WithError:json StatusCode:@([operation.response statusCode])];
    }];
}

- (void)renewPurchase:(UserPackage *)userPackage {
    NSDictionary * params = @{
                              @"user_package_id" : userPackage.modelId
                              };
    
    NSString *apiPath = @"api/renewPurchase";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _credit =@([_credit intValue] - [userPackage.package.price intValue]);
        [self.authDelegate userRenewPurchaseSucessful:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userRenewPurchaseFailed:self WithError:json StatusCode:@([operation.response statusCode])];
    }];
}

- (void)registerUserWithParam:(NSDictionary *)dictionary {
    NSLog(@"registerUserWithParam = %@",dictionary);
    NSString *apiPath = @"api/register";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* responseDict = responseObject;
        NSLog(@"response[%li] %@", (long)[operation.response statusCode],responseObject);
        if ([responseDict allKeys].count == 1) {
            [self.authDelegate userRegiserFailed:self WithError:nil StatusCode:@([operation.response statusCode])];
        }
        else
        {
            [self.authDelegate userRegiserSuccessful:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error.localizedDescription);
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userRegiserFailed:self WithError:json StatusCode:@([operation.response statusCode])];
    }];
}

- (void)changePassword:(NSString *)oldPass NewPass:(NSString *) newPass {
    NSDictionary * params = @{
                              @"username" : self.userName,
                              @"current_password" : oldPass,
                              @"password" : newPass,
                              @"password_confirmation" : newPass
                              };

    NSString *apiPath = @"api/changePassword";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@", responseObject);
        [self.authDelegate userChangePasswordSuccessful:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error.localizedDescription);
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userChangePasswordFailed:self WithError:json StatusCode:@([operation.response statusCode])];
    }];
}
-(void) resetPassword:(NSString *)inputUsername
{
    NSDictionary * params = @{
                              @"username" : inputUsername
                              };
    
    NSString *apiPath = @"api/resetPassword";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@", responseObject);
        [self.authDelegate userResetPasswordSuccessful:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error.localizedDescription);
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userResetPasswordFailed:self WithError:json StatusCode:@([operation.response statusCode])];
    }];
}

-(void)saveCurrentUserToNSUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * currentUserDict = [[User currentUser] getDictionaryFromObject];
    [defaults setObject:currentUserDict forKey:@"currentUserDict"];
    [defaults synchronize];
}
+(void)loadCurrentUserToNSUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * currentUserDict = [defaults objectForKey:@"currentUserDict"];
    User *user = [[User new] initWithDict:currentUserDict];
    _currentUser = user;
    
}
-(void)changeProfileName:(NSString *) newProfileName
{
    if ([_profileName isEqualToString:newProfileName]) {
        [self.authDelegate userChangeProfileNameSucessful:self];
        return;
    }
    NSDictionary * params = @{
                              @"username" : self.userName,
                              @"profile_name":newProfileName
                              };
    
    NSString *apiPath = @"api/changeProfileName";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@", responseObject);
        [self setObjectWithDictionary:responseObject];
        [self.authDelegate userChangeProfileNameSucessful:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error.localizedDescription);
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userChangeProfileNameFailed:self WithError:json StatusCode:@([operation.response statusCode])];
    }];
    
    
}
+(NSString *) createRandomStringWithLength:(int) length
{
    NSString *chars = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    int charsLength = chars.length;
    NSString * randomStr = @"";
    for (int i = 0; i<length; i++) {
        randomStr = [NSString stringWithFormat:@"%@%@",randomStr,[chars substringWithRange:NSMakeRange(arc4random_uniform(charsLength),1)]];
    }

    return randomStr;
}

-(void)uploadImageWithURL:(NSURL *)imgURL
{
    NSLog(@"uploadImageWithURL = %@",imgURL);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html", nil];
    
    NSDictionary * params = @{
                              @"username" : self.userName
                              };

    NSString *apiPath = @"api/uploadAvatar";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    
    [manager POST:requestURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:imgURL name:@"image" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"uploadImage Success: %@", responseObject);
        [self setObjectWithDictionary:responseObject];
        [self.authDelegate uploadAvatarSucessful:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"operation = %@",operation);
        //NSLog(@"#error: %@", error.localizedDescription);
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //NSLog(@"uploadImageWithURLError[%li] = %@",(long)[operation.response statusCode],json[@"message"]);
        [self.authDelegate uploadAvatarFailed:self WithError:json StatusCode:@([operation.response statusCode])];
    }];
}
-(void) refreshUser
{
    NSDictionary * params = @{
                              @"username" : self.userName
                              };
    
    NSString *apiPath = @"api/getUser";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self setObjectWithDictionary:responseObject];
        [self.authDelegate refreshUserSucessful:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.authDelegate refreshUserFailed:self WithError:[NSJSONSerialization JSONObjectWithData:[[[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil] StatusCode:@([operation.response statusCode])];
    }];
}

-(BOOL) canViewThisPackage:(Package *) pack
{
    
    NSLog(@"canDisplayByRole [userRole:%@][package %@ Role:%@]",self.role, pack.modelId, pack.roleCanView );
    
    if ([pack.roleCanView isEqualToString:@"user"] || [self.role isEqualToString:@"admin"]) {
        return YES;
    }
    if ([pack.roleCanView isEqualToString:@"tester"] && [self.role isEqualToString:@"tester"]) {
        return YES;
    }
    return NO;
}
@end
