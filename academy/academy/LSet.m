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

@synthesize name, desc, orderNo, wordList, package_id;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];

    name = [self getStringFromDict:dict WithKey:@"name"];
    desc = [self getStringFromDict:dict WithKey:@"description"];
    package_id = [self getStringFromDict:dict WithKey:@"package_id"];
    orderNo = [self getStringFromDict:dict WithKey:@"order_number"] ? [[self getStringFromDict:dict WithKey:@"order_number"] intValue]:-1;
    
    
    wordList = [NSMutableArray new];
    
    NSArray * words = [self getArrayFromDict:dict WithKey:@"words"];
    
    for (NSDictionary * wordDict in words) {
        Word * newWord = [[Word alloc] initWithDict:wordDict];
        [wordList addObject:newWord];
    }
    
    self.grade = 0;
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
        [self.delegate getAllSucessfull:setList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

- (void)findId:(NSString *)valId {
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

@end
