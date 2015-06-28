//
//  DataEngine.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedData.h"
typedef NS_ENUM(NSUInteger, LoginType) {
    LoginNormal = 0,
    LoginFacebook = 1,
    LoginGooglePlus = 2,
    LoginTypeCount
};

@interface DataEngine : NSObject

+ (id)getInstance;

- (NSString*)requestURL;

@property (nonatomic, assign) BOOL isForceReload;
@property (nonatomic, assign) BOOL isOffline;
@property (nonatomic, assign) BOOL isSoundOff;
@property (nonatomic, assign) LoginType loginType;
@property (nonatomic, retain) SharedData * sharedData;

-(void) saveLoginInfo:(NSString*) username Password: (NSString*) password fbId:(NSString *)fbId ggpId:(NSString*)ggpId;
-(NSString *) getAppURL;
-(NSString *) getFeedbackEmail;
-(void) switchisSoundOff:(BOOL)isSoundOff;
@end
