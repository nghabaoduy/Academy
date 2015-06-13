//
//  UserPackage.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "UserPackage.h"
#import <AFNetworking/AFNetworking.h>

@implementation UserPackage
@synthesize userPackageDelegate;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = dict[@"id"];

    _package_id = dict[@"package_id"] ?:  nil;
    
    if (_package_id) {
        _package = [[Package alloc] initWithDict:dict[@"package"]];
    }
    _user_id = dict[@"user_id"] ?: nil;
    _score = [self getNumberFromDict:dict WithKey:@"score"];
    
    [self saveToNSUserDefaults];
}
-(NSString *)getUserDefaultStoredKey
{
    return @"storedUserPackages";
}
- (NSDictionary *)getDictionaryFromObject {
    return @{
             @"id" : self.modelId ?: @"",
             @"package_id" : _package_id ?: @"",
             @"user_id" : _user_id ?: @"",
             @"package": [_package getDictionaryFromObject],
             @"score":_score?:[NSNumber numberWithInt:0]
             };
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    NSLog(@"getAllWithFilter %@",filterDictionary);
    if ([[DataEngine getInstance] isOffline]) {
        [self getAllWithFilterFromNSUserDefaults:filterDictionary];
        return;
    }
    
    NSString *apiPath = @"api/userPackage";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get all user package successful");
        NSArray *packages = responseObject;
        NSMutableArray * packageList = [NSMutableArray new];
        for (NSDictionary * userPackageDict in packages) {
            UserPackage * newUserPackage = [[UserPackage alloc] initWithDict:userPackageDict];
            NSLog(@"UserPackage = %@",newUserPackage);
            [packageList addObject:newUserPackage];
        }
        
        [self.delegate getAllSucessfull:self List:packageList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

- (void)getAllWithFilterFromNSUserDefaults:(NSDictionary *)filterDictionary {
    NSString *userDefaultStoredKey = [self getUserDefaultStoredKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray * storedUserPackages = [defaults objectForKey:userDefaultStoredKey];
    //NSLog(@"%@ = %@",self.userDefaultStoredKey, storedUserPackages);
    NSArray *packages = [self filterNSArrayWithFilter:storedUserPackages Filter:filterDictionary];
    NSMutableArray * packageList = [NSMutableArray new];
    for (NSDictionary * userPackageDict in packages) {
        UserPackage * newUserPackage = [[UserPackage alloc] initWithDict:userPackageDict];
        [packageList addObject:newUserPackage];
    }
    
    [self.delegate getAllSucessfull:self List:packageList];
}

-(void) updateScore:(NSNumber *) score
{
    NSDictionary * params = @{@"user_id":_user_id,
                              @"package_id":_package_id,
                              @"score":score
                              };
    NSString *apiPath = @"api/changeScore";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Update Score Successful");
        UserPackage * userPackage = [[UserPackage alloc] initWithDict:responseObject];
        [self.userPackageDelegate updateUserPackageScoreSuccessful:userPackage];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.userPackageDelegate updateUserPackageScoreWithError:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"[UserPackage Class] [user_id:%@][package_id:%@][score:%i]",_user_id,_package_id,[_score intValue]];
}
@end
