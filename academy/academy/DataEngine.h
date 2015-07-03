//
//  DataEngine.h
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedData.h"
#import "FMDatabase.h"

typedef NS_ENUM(NSUInteger, LoginType) {
    LoginNormal = 0,
    LoginFacebook = 1,
    LoginGooglePlus = 2,
    LoginTypeCount
};

@protocol LocalDBSetupDelegate <NSObject>
- (void)finishSetupDBSuccessful;
- (void)finishSetupDBWithErrorMessage:(NSString *)error;
@end

typedef void(^needUpdate)(BOOL doesNeedUpdate, BOOL downloadNewVer);
typedef void(^completion)(BOOL finished);

@interface DataEngine : NSObject

+ (DataEngine *)getInstance;
- (NSString*)requestURL;

@property (nonatomic, weak) id <LocalDBSetupDelegate> localDBDelegate;
@property (nonatomic, assign) BOOL isForceReload;
@property (nonatomic, assign) BOOL isOffline;
@property (nonatomic, assign) BOOL isSoundOff;
@property (nonatomic, assign) LoginType loginType;
@property (nonatomic, retain) SharedData * sharedData;
@property (nonatomic, retain) NSArray * packageList;
@property (nonatomic, retain) NSArray * setList;
@property (nonatomic, retain) NSArray * wordList;
@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, retain) NSString * localDBUpdateDate;

-(void) saveLoginInfo:(NSString*) username Password: (NSString*) password fbId:(NSString *)fbId ggpId:(NSString*)ggpId;
-(NSString *) getAppURL;
-(NSString *) getFeedbackEmail;
-(void) switchisSoundOff:(BOOL)isSoundOff;

-(void) clearAllLocalDB;
-(void) setupDataFromLocalDB;

- (void)addPackagesToDB:(NSArray *) packList;
- (void) addWordsToDB:(NSArray *) wordList;
- (void) addSetWordsToDB:(NSArray *) setwordList;
- (void)addSetsToDB:(NSArray *) wordList;

-(void) checkIfNeedUpdateData:(needUpdate) block;
-(void) saveLocalDBUpdateDate;
@end
