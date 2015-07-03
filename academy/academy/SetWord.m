//
//  SetWord.m
//  academy
//
//  Created by Mac Mini on 7/2/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetWord.h"
#import <AFNetworking/AFNetworking.h>

@implementation SetWord
@synthesize wordId, setId;
- (void)setObjectWithDictionary:(NSDictionary *)dict {
    
    self.wordId = [self getStringFromDict:dict WithKey:@"word_id"];
    self.setId = [self getStringFromDict:dict WithKey:@"set_id"];
    
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    NSString *apiPath = @"api/setWord";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"here %@", responseObject);
        NSArray *words = responseObject;
        NSMutableArray *swordList = [NSMutableArray new];
        for (NSDictionary * swordDict in words) {
            SetWord* setword = [[SetWord alloc] initWithDict:swordDict];
            [swordList addObject:setword];
        }
        [self.delegate getAllSucessfull:self List:swordList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

@end
