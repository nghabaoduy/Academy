//
//  Package.m
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "Package.h"
#import "LSet.h"
#import "User.h"
#import <AFNetworking/AFNetworking.h>

@implementation Package

@synthesize awsId, name, desc, category, price, oldPrice, wordsTotal, setList, imgURL,language, roleCanView, orderCode;

- (void)setObjectWithDictionary:(NSDictionary *)dict {
    //NSLog(@"Package dict = %@",dict);
    
    self.modelId = [self getStringFromDict:dict WithKey:@"id"];
    name = [self getStringFromDict:dict WithKey:@"name"];
    desc = [self getStringFromDict:dict WithKey:@"description"];
    category = [self getStringFromDict:dict WithKey:@"category"];
    oldPrice = [self getStringFromDict:dict WithKey:@"old_price"];
    price = [self getStringFromDict:dict WithKey:@"price"];
    orderCode = [self getStringFromDict:dict WithKey:@"order_code"];
    wordsTotal = [[self getStringFromDict:dict WithKey:@"no_of_words"] intValue];
    language = [self getStringFromDict:dict WithKey:@"language"];
    imgURL = dict[@"imgURL"] ?:(dict[@"asset"] != [NSNull null] ? dict[@"asset"][@"index"] : nil);
    roleCanView = [self getStringFromDict:dict WithKey:@"role_can_view"];
    setList = [NSMutableArray new];
    for (NSDictionary *setDict in [self getArrayFromDict:dict WithKey:@"sets"]) {
        LSet *set = [[LSet alloc] initWithDict:setDict];
        [setList addObject:set];
    }
    
}

- (NSDictionary *)getDictionaryFromObject {
    return @{
             @"id" : self.modelId ?: @"",
             @"name" : name ?: @"",
             @"description" : desc ?: @"",
             @"category" : category ?: @"",
             @"old_price" : oldPrice ?: @"",
             @"price" : price ?: @"",
             @"no_of_words" : [NSNumber numberWithInt:wordsTotal] ?: @"",
             @"imgURL" : imgURL ?: @"",
             @"sets":[self getSetDictList],
              @"role_can_view" : self.roleCanView ?: @"",
              @"language" : self.language ?: @""
             };
}
-(NSArray *) getSetDictList
{
    NSMutableArray *aArray = [NSMutableArray new];
    for (LSet * set in setList) {
        [aArray addObject:[set getDictionaryFromObject]];
    }
    return aArray;
}
- (void)getAllWithFilter:(NSDictionary *)filterDictionary {
    NSString *apiPath = @"api/package";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:filterDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"here %@", responseObject);
        NSArray *packages = responseObject;
        
        User *curUser = [User currentUser];
        NSMutableArray * packageList = [NSMutableArray new];
        for (NSDictionary * packageDict in packages) {
            Package* pack = [[Package alloc] initWithDict:packageDict];
            if ([curUser canViewThisPackage:pack]) {
                [packageList addObject:pack];
            }
            
        }
        [self.delegate getAllSucessfull:self List:packageList];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        [self.delegate model:self ErrorMessage:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}

@end
