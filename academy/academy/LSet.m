//
//  LSet.m
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "LSet.h"
#import "Word.h"
#import <AFNetworking/AFNetworking.h>

@implementation LSet

@synthesize name, desc, orderNo, wordList, package_id, imgURL, language;

- (void)setObjectWithDictionary:(NSDictionary *)dict {

    self.modelId = [self getStringFromDict:dict WithKey:@"id"];

    name = [self getStringFromDict:dict WithKey:@"name"];
    desc = [self getStringFromDict:dict WithKey:@"description"];
    package_id = [self getStringFromDict:dict WithKey:@"package_id"];
    orderNo = [self getStringFromDict:dict WithKey:@"order_number"] ? [[self getStringFromDict:dict WithKey:@"order_number"] intValue]:-1;
    language = [self getStringFromDict:dict WithKey:@"language"];
    imgURL = dict[@"imgURL"] ?:(dict[@"asset"] != [NSNull null] ? dict[@"asset"][@"index"] : nil);

    wordList = [NSMutableArray new];
    
    NSArray * words = [self getArrayFromDict:dict WithKey:@"words"];
    
    for (NSDictionary * wordDict in words) {
        Word * newWord = [[Word alloc] initWithDict:wordDict];
        [wordList addObject:newWord];
    }
    
    self.grade = 0;
    self.dummyImgName = @"sticker_egg.png";
    
    if (words.count > 0) {
        [self saveToNSUserDefaults];
    }
}
-(NSString *)getUserDefaultStoredKey
{
    return @"storedLSetWithWords";
}

-(NSDictionary *)getDictionaryFromObject
{
    return @{
             @"id" : self.modelId ?: @"",
             @"name" : name ?: @"",
             @"description" : desc ?: @"",
             @"package_id": package_id?: @"",
             @"order_number": [NSNumber numberWithInt:orderNo],
             @"imgURL":imgURL?: @"",
             @"words":[self getWordList],
             @"language":language?: @""
             };

}
-(NSArray *) getWordList
{
    NSMutableArray *aArray = [NSMutableArray new];
    for (Word * newWord in wordList) {
        [aArray addObject:[newWord getDictionaryFromObject]];
    }
    return aArray;
}
- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    NSString *apiPath = @"api/set";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"here %@", responseObject);
        NSArray *sets = responseObject;
        NSMutableArray * setList = [NSMutableArray new];
        for (NSDictionary * setDict in sets) {
            LSet * newSet = [[LSet alloc] initWithDict:setDict];
            [setList addObject:newSet];
        }
        [self.delegate getAllSucessfull:self List:setList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

- (void)findId:(NSString *)valId {
    if ([[DataEngine getInstance] isOffline]) {
        [self findIdInFromNSUserDefaults:valId];
        return;
    }
    
    
    NSString *apiPath = @"api/set";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@/%@", [[DataEngine getInstance] requestURL], apiPath, valId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self setObjectWithDictionary:responseObject];
        [self.delegate findIdSuccessful:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

-(void)findIdInFromNSUserDefaults:(NSString *)valId {
    NSString *userDefaultStoredKey = [self getUserDefaultStoredKey];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray * storedData = [defaults objectForKey:userDefaultStoredKey];
    //NSLog(@"%@ = %@",userDefaultStoredKey, storedData);
    NSArray *aArray = [self filterNSArrayWithFilter:storedData Filter:@{@"id":valId}];
    if (aArray.count > 0) {
        [self setObjectWithDictionary:[aArray firstObject]];
        [self.delegate findIdSuccessful:self];
    }
    else
    {
        NSString *errorMess = @"Không thể tải từ vựng về. Bạn cần tải về 1 lần trước khi có thể sự dụng trong chế độ Offline.";
        [self.delegate model:self ErrorMessage:errorMess StatusCode:@0];

    }

}

@end
