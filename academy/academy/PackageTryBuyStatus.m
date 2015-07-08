//
//  PackageTryBuyStatus.m
//  academy
//
//  Created by Mac Mini on 7/6/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "PackageTryBuyStatus.h"
#import <AFNetworking/AFNetworking.h>

@implementation PackageTryBuyStatus

@synthesize tryCount, buyCount;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    
    self.modelId = [self getStringFromDict:dict WithKey:@"package_id"];
    tryCount = [[self getNumberFromDict:dict WithKey:@"try"] intValue];
    buyCount = [[self getNumberFromDict:dict WithKey:@"buy"] intValue];
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    NSString *apiPath = @"api/getPackagesTryBuyStatus";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject;
        NSMutableArray *returnArray = [NSMutableArray new];
        for (NSDictionary * statusDict in array) {
            PackageTryBuyStatus* status = [[PackageTryBuyStatus alloc] initWithDict:statusDict];
            [returnArray addObject:status];
        }
        [self.delegate getAllSucessfull:self List:returnArray];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

- (void)refreshPackStatuswithCompletion:(completion) block
{
    NSString *apiPath = @"api/getPackagesTryBuyStatus";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject;
        NSMutableArray *returnArray = [NSMutableArray new];
        for (NSDictionary * statusDict in array) {
            PackageTryBuyStatus* status = [[PackageTryBuyStatus alloc] initWithDict:statusDict];
            [returnArray addObject:status];
        }
        [[DataEngine getInstance] refreshPackStatusInDB:returnArray completion:^(BOOL finished) {
            block(finished);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(NO);
    }];
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"[PackageTryBuyStatus Class] Package_id:%@ [try:%i][buy:%i]",self.modelId,self.tryCount,self.buyCount];
}

@end
