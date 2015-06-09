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
    _email = [self getStringFromDict:dict WithKey:@"email"];
    _userName =[self getStringFromDict:dict WithKey:@"username"];
    _credit = [self getNumberFromDict:dict WithKey:@"credit"];
    _profileName = [self getStringFromDict:dict WithKey:@"profile_name"];
}

-(NSDictionary *)getDictionaryFromObject
{
    return @{@"id" : self.modelId ?: @"",
             @"email" : _email ?: @"",
             @"username" : _userName ?: @"",
             @"credit": _credit,
             @"profile_name":_profileName
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

- (void)registerUserWithParam:(NSDictionary *)dictionary {
    
    NSString *apiPath = @"api/register";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response %@", responseObject);
        [self.authDelegate userRegiserSuccessful:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error.localizedDescription);
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.authDelegate userRegiserFailed:self WithError:json StatusCode:@([operation.response statusCode])];
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

@end
