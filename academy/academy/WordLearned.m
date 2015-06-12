//
//  WordLearned.m
//  academy
//
//  Created by Brian on 6/12/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordLearned.h"
#import <AFNetworking/AFNetworking.h>
#import "User.h"

@implementation WordLearned

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];
    _word_id = [dict valueForKey:@"word_id"];
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
             @"user_id" : _user_id?:@"",
             @"word_id" : _word_id?: @""
             };
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {

    NSString *apiPath = [NSString stringWithFormat:@"api/wordLeanred"];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"here %@", responseObject);
        NSArray *wordLearneds = responseObject;
        NSMutableArray * wordLearnedList = [NSMutableArray new];
        for (NSDictionary * setScoreDict in wordLearneds) {
            WordLearned* wordLeanred = [[WordLearned alloc] initWithDict:setScoreDict];
            [wordLearnedList addObject:wordLeanred];
        }
        [self.delegate getAllSucessfull:self List:wordLearnedList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

/*
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
*/
-(NSString *)description
{
    return [NSString stringWithFormat:@"[WordLearned Class] [user:%@][word:%@]",_user_id,_word_id];
}
@end
