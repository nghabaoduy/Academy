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
    
}
- (NSString *)requestURL {
    return @"http://192.168.1.2:8000/";
    return @"http://academy.openlabproduction.com/";
}

-(void) saveLoginInfo:(NSString*) username Password: (NSString*) password
{
    if ([[DataEngine getInstance] isOffline]) {
        return;
    }
    NSLog(@"saveLoginInfo:%@ Password:%@",username,password);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:@"saveUsername"];
    [defaults setObject:password forKey:@"savePassword"];
    [defaults setObject:@YES forKey:@"isAutoLogin"];
    [defaults setObject:[NSNumber numberWithInteger:self.loginType] forKey:@"loginType"];
    [defaults synchronize];
}
-(NSDictionary*) loadLoginInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *saveUsername = [defaults objectForKey:@"saveUsername"];
    NSString *savePassword = [defaults objectForKey:@"savePassword"];
    NSLog(@"loadLoginInfo:%@ Password:%@",saveUsername,savePassword);
    NSMutableDictionary *loginDict = [[NSMutableDictionary alloc] init];
    if (saveUsername && savePassword) {
        [loginDict setObject:saveUsername forKey:@"saveUsername"];
        [loginDict setObject:savePassword forKey:@"savePassword"];
    }
    return loginDict;
}

@end
