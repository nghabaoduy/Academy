//
//  SharedData.m
//  academy
//
//  Created by Mac Mini on 6/28/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SharedData.h"
#import <AFNetworking/AFNetworking.h>
#import "DataEngine.h"
@implementation SharedData

@synthesize sharedDataDelegate;

- (void)updateSharedData {
    NSString *apiPath = @"api/sharedData";
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", [[DataEngine getInstance] requestURL], apiPath];    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *sharedDataList = responseObject;
        for (NSDictionary * dataDict in sharedDataList) {
            if ([dataDict[@"name"] isEqualToString:@"app_version"]) {
                self.appVersion = dataDict[@"value"];
            }
            if([dataDict[@"name"] isEqualToString:@"latest_data_update_date"]){
                self.latestDataUpdateDate = dataDict[@"value"];
            }
        }
        [sharedDataDelegate SharedDataGetSuccessful:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSData *data = [ErrorResponse dataUsingEncoding:NSUTF8StringEncoding];
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [sharedDataDelegate SharedDataGetFailed:json[@"message"] StatusCode:@([operation.response statusCode])];
    }];
}
@end
