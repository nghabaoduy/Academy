//
//  SetScore.m
//  academy
//
//  Created by Brian on 6/4/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetScore.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"

@implementation SetScore

@synthesize score = _score;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];
    _score = [dict valueForKey:@"score"];
    _set_id = [dict valueForKey:@"set_id"];
    _user_id = [dict valueForKey:@"user_id"];
    
    [self saveToNSUserDefaults];
}
-(NSString *)getUserDefaultStoredKey
{
    return @"storedScores";
}
- (NSDictionary *)getDictionaryFromObject {
    return @{
             @"id" : self.modelId ?: @"",
             @"user_id" : [[User currentUser] modelId],
             @"set_id" : _set_id?: @"",
             @"score" : _score?: @""
             };
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    if ([[DataEngine getInstance] isOffline]) {
        [self getAllWithFilterFromNSUserDefaults:filterDictionary];
        return;
    }
    NSString *apiPath = [NSString stringWithFormat:@"api/set/%@/score",self.set_id];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"here %@", responseObject);
        NSArray *setScores = responseObject;
        NSMutableArray * setScoreList = [NSMutableArray new];
        for (NSDictionary * setScoreDict in setScores) {
            SetScore* setScore = [[SetScore alloc] initWithDict:setScoreDict];
            [setScoreList addObject:setScore];
        }
        [self.delegate getAllSucessfull:self List:setScoreList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}


- (void)createModel {
    NSString *apiPath = [NSString stringWithFormat:@"api/set/%@/score",self.set_id];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager POST:requestURL parameters:[self getDictionaryFromObject] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"res %@", responseObject);
        
        [self.delegate createModelSuccessful:self];
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
    NSArray * storedData = [defaults objectForKey:userDefaultStoredKey];
    //NSLog(@"%@ = %@",userDefaultStoredKey, storedData);
    NSArray *aArray = [self filterNSArrayWithFilter:storedData Filter:@{@"set_id":_set_id,@"user_id" : [[User currentUser] modelId]}];
    NSMutableArray * retrievedList = [NSMutableArray new];
    for (NSDictionary * objDict in aArray) {
        SetScore * obj = [[SetScore alloc] initWithDict:objDict];
        [retrievedList addObject:obj];
    }
    
    [self.delegate getAllSucessfull:self List:retrievedList];
    
    
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"[SetScore Class] [set:%@][user:%@] = %@",_set_id,_user_id,_score];
}
@end
