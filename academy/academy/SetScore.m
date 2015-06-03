//
//  SetScore.m
//  academy
//
//  Created by Brian on 6/4/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetScore.h"
#import <AFNetworking/AFNetworking.h>

@implementation SetScore

@synthesize score = _score;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    self.modelId = [dict valueForKey:@"id"];
    _score = [dict valueForKey:@"score"];
    
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    NSString *apiPath = [NSString stringWithFormat:@"api/set/%@/score",self.set_id];
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"here %@", responseObject);
        NSArray *setScores = responseObject;
        NSMutableArray * setScoreList = [NSMutableArray new];
        for (NSDictionary * setScoreDict in setScores) {
            SetScore* setScore = [[SetScore alloc] initWithDict:setScoreDict];
            [setScoreList addObject:setScore];
        }
        [self.delegate getAllSucessfull:setScoreList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}
@end
