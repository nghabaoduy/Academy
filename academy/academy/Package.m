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
    self.modelId = [dict valueForKey:@"id"];
    name = [dict valueForKey:@"name"];
    desc = [dict valueForKey:@"description"];
    category = [dict valueForKey:@"category"];
    price = [dict valueForKey:@"price"];
    wordsTotal = [[dict valueForKey:@"no_of_words"] intValue];
    
    setList = [NSMutableArray new];
    for (NSDictionary *setDict in [dict objectForKey:@"sets"]) {
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
