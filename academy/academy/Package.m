//
//  Package.m
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "Package.h"
#import "LSet.h"
#import <AFNetworking/AFNetworking.h>

@implementation Package

@synthesize awsId, name, desc, category, price, wordsTotal, setList;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    NSLog(@"Package dict = %@",dict);
    self.modelId = [self getStringFromDict:dict WithKey:@"id"];
    name = [self getStringFromDict:dict WithKey:@"name"];
    desc = [self getStringFromDict:dict WithKey:@"description"];
    category = [self getStringFromDict:dict WithKey:@"category"];
    price = [self getStringFromDict:dict WithKey:@"price"];
    wordsTotal = [[self getStringFromDict:dict WithKey:@"no_of_words"] intValue];
    
    setList = [NSMutableArray new];
    for (NSDictionary *setDict in [self getArrayFromDict:dict WithKey:@"sets"]) {
        LSet *set = [[LSet alloc] initWithDict:setDict];
        [setList addObject:set];
    }
}

- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    NSString *apiPath = @"api/package";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"here %@", responseObject);
        NSArray *packages = responseObject;
        NSMutableArray * packageList = [NSMutableArray new];
        for (NSDictionary * packageDict in packages) {
            Package* pack = [[Package alloc] initWithDict:packageDict];
            [packageList addObject:pack];
        }
        [self.delegate getAllSucessfull:packageList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

@end
