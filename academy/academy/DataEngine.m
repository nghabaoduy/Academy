//
//  DataEngine.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "DataEngine.h"
#import "User.h"

@implementation DataEngine
{
    NSMutableDictionary * storedData;
}

static DataEngine * instance = nil;

+ (id)getInstance {
    if (instance == nil) {
        instance = [DataEngine new];
        [instance loadSaveData];
    }
    return instance;
}
-(void) loadSaveData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int loginTypeInt = [[defaults objectForKey:@"loginType"] intValue];
    switch (loginTypeInt) {
        case 0:
            [self setLoginType:LoginNormal];
            break;
        case 1:
            [self setLoginType:LoginFacebook];
            break;
        case 2:
            [self setLoginType:LoginGooglePlus];
            break;
        default:
            [self setLoginType:LoginNormal];
            break;
    }
    [self setIsSoundOff:[[defaults valueForKey:@"isSoundOff"] boolValue]];
    
}
- (NSString *)requestURL {
    //return @"http://192.168.1.6:8000/";
    return @"http://academy.openlabproduction.com/";
}

-(void) saveLoginInfo:(NSString*) username Password: (NSString*) password fbId:(NSString *)fbId ggpId:(NSString*)ggpId
{
    if ([[DataEngine getInstance] isOffline]) {
        return;
    }
    NSLog(@"saveLoginInfo:%@ Password:%@",username,password);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:username forKey:@"saveUsername"];
    [defaults setValue:password forKey:@"savePassword"];
    [defaults setValue:fbId forKey:@"facebook_id"];
    [defaults setValue:ggpId forKey:@"ggp_id"];
    [defaults setValue:@YES forKey:@"isAutoLogin"];
    [defaults setValue:[NSNumber numberWithInteger:self.loginType] forKey:@"loginType"];
    [defaults synchronize];
}

-(NSString *) getAppURL
{
    return @"https://itunes.apple.com/us/app/vnacademy/id1008312086?ls=1&mt=8";
}
-(NSString *) getFeedbackEmail
{
    return @"openlab.helpdesk@gmail.com";
}
-(void) switchisSoundOff:(BOOL)isSoundOff
{
    [self setIsSoundOff:isSoundOff];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@([self isSoundOff]) forKey:@"isSoundOff"];
    [defaults synchronize];
}

@end
