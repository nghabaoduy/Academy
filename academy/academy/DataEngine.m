//
//  DataEngine.m
//  academy
//
//  Created by Nguyen Ha Bao Duy on 17/5/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "DataEngine.h"
#import "User.h"
#import "Word.h"
#import "SetWord.h"
#import "LSet.h"

@implementation DataEngine
{
    NSMutableDictionary * storedData;
}

static DataEngine * instance = nil;

+ (DataEngine *)getInstance {
    if (instance == nil) {
        instance = [DataEngine new];
        [instance loadSaveData];
        [instance dbInit];
        instance.sharedData = [[SharedData alloc] init];
    }
    return instance;
}

-(void) loadSaveData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int loginTypeInt = [[defaults objectForKey:@"loginType"] intValue];
    NSLog(@"loginType = %@",loginTypeInt == 0?@"Normal":(loginTypeInt == 1?@"facebook":@"GGP"));
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


//FMDB
-(void) dbInit
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    
    self.database = [FMDatabase databaseWithPath:path];
    [self.database open];
    /*NSLog(@"Delete table package %@",[self.database executeUpdate:@"DROP TABLE package"]?@"successful":@"failed");
    
    [self.database executeUpdate:@"create table package(id text primary key, name text, description text, category text, old_price text, price text, no_of_words text, language text, expiry_time text, role_can_view text, imgURL text)"];
    [self.database executeUpdate:@"create table word(id text primary key, name text, phonetic text, word_type text)"];
    [self.database executeUpdate:@"create table meaning(id text primary key, word_id text, language text, content text, example text, word_sub_dict text)"];
    [self.database executeUpdate:@"create table set_word(word_id text, set_id text)"];*/
    [self.database executeUpdate:@"create table lset(id text primary key, name text, description text, language text, package_id text, order_number text, imgURL text)"];
    [self.database close];
    
    self.wordList = [self getWordsFromDB];
    self.setList = [self getSetFromDB];
    self.packageList = [self getPackagesFromDB];
}
- (void)addPackagesToDB:(NSArray *) packList{
    
    [self.database open];
    NSLog(@"Delete all from package %@",[self.database executeUpdate:@"DELETE FROM package"]?@"successful":@"failed");
    for (Package * pack in packList) {
        NSString *addPackQuery = @"insert into package (id, name, description, category, old_price, price, no_of_words, language, expiry_time, role_can_view, imgURL) values (? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,?)";
        
        [self.database executeUpdate:addPackQuery,pack.modelId,pack.name,pack.desc,pack.category,pack.oldPrice,pack.price,[NSString stringWithFormat:@"%i",pack.wordsTotal],pack.language,pack.expiryTime, pack.roleCanView, pack.imgURL?:@""];
    }
    [self.database close];
}
- (void)addSetsToDB:(NSArray *) setList{
    [self.database open];
    NSLog(@"Delete all from lset %@",[self.database executeUpdate:@"DELETE FROM lset"]?@"successful":@"failed");
    for (LSet * set in setList) {
        NSString *addWordQuery = @"insert into lset(id, name, description, language, package_id, order_number, imgURL) values (?, ?, ?, ?, ?, ?, ?)";
        
        [self.database executeUpdate:addWordQuery,set.modelId, set.name, set.desc, set.language, set.package_id, [NSString stringWithFormat:@"%i",set.orderNo], set.imgURL];
    }
    
    [self.database close];
}
- (void)addWordsToDB:(NSArray *) wordList{

    [self.database open];
    for (Word * word in wordList) {
        NSString *addWordQuery = @"insert into word (id, name, phonetic, word_type) values (?, ?, ?, ?)";
        
        [self.database executeUpdate:addWordQuery,word.modelId, word.name, word.phonentic, word.wordType];
        for(Meaning * meaningObj in word.meaningList)
        {
            NSString *addMeaningQuery = @"insert into meaning (id, word_id, language, content, example, word_sub_dict) values (?, ?, ?, ?, ?, ?)";
            [self.database executeUpdate:addMeaningQuery,meaningObj.modelId, word.modelId, meaningObj.language, meaningObj.content, meaningObj.example, meaningObj.wordSubDictStr];
        }
    }
    
    [self.database close];
}
- (void)addSetWordsToDB:(NSArray *) setwordList{
    
    [self.database open];
    //NSLog(@"Delete all from set_word %@",[self.database executeUpdate:@"DELETE FROM set_word"]?@"successful":@"failed");
    
    for (SetWord * setword in setwordList) {
        NSString *addSWordQuery = @"insert into set_word (word_id, set_id) values (?, ?)";
        
        [self.database executeUpdate:addSWordQuery,setword.wordId,setword.setId];
    }
    FMResultSet *results = [self.database executeQuery:@"select * from set_word"];
     
     while([results next]) {
         NSLog(@"setword[%@][%@]",[results stringForColumn:@"word_id"], [results stringForColumn:@"set_id"]);
     }
    
    [self.database close];
    
}
-(NSArray *) getWordsFromDB
{
    NSMutableArray * wordList = [NSMutableArray new];
    
    [self.database open];
    FMResultSet *results = [self.database executeQuery:@"select * from word"];
    
    while([results next]) {
        NSDictionary * wordDict = @{@"id":      [results stringForColumn:@"id"],
                                   @"name":     [results stringForColumn:@"name"],
                                   @"phonetic": [results stringForColumn:@"phonetic"],
                                   @"word_type":[results stringForColumn:@"word_type"]};
        Word *word = [[Word alloc] initWithDict:wordDict];
        [wordList addObject:word];
    }
    
    FMResultSet *results2 = [self.database executeQuery:@"select * from meaning"];
    
    while([results2 next]) {
        NSDictionary * meaningDict = @{@"id":           [results2 stringForColumn:@"id"],
                                       @"word_id":      [results2 stringForColumn:@"word_id"],
                                       @"language":     [results2 stringForColumn:@"language"],
                                       @"content":      [results2 stringForColumn:@"content"],
                                       @"example":      [results2 stringForColumn:@"example"],
                                       @"word_sub_dict":[results2 stringForColumn:@"word_sub_dict"]};
        Meaning *meaning = [[Meaning alloc] initWithDict:meaningDict];
        Word * word = (Word*)[AModel getModelById:[results2 stringForColumn:@"word_id"] from:wordList];
        if (word) {
            [word.meaningList addObject:meaning];
        }
    }
    return wordList;
}
-(NSArray *) getPackagesFromDB
{
    NSMutableArray * packList = [NSMutableArray new];
    
    [self.database open];
    FMResultSet *results = [self.database executeQuery:@"select * from package"];

    while([results next]) {
        NSDictionary * packDict = @{@"id":            [results stringForColumn:@"id"],
                                    @"name":          [results stringForColumn:@"name"],
                                    @"description":   [results stringForColumn:@"description"],
                                    @"category":      [results stringForColumn:@"category"],
                                    @"old_price":     [results stringForColumn:@"old_price"],
                                    @"price":         [results stringForColumn:@"price"],
                                    @"no_of_words":   [results stringForColumn:@"no_of_words"],
                                    @"language":      [results stringForColumn:@"language"],
                                    @"expiry_time":   [results stringForColumn:@"expiry_time"],
                                    @"role_can_view": [results stringForColumn:@"role_can_view"],
                                    @"imgURL":        [results stringForColumn:@"imgURL"]?:@""};
        Package *pack = [[Package alloc] initWithDict:packDict];
        [packList addObject:pack];
    }
    return packList;
}
-(NSArray *) getSetFromDB
{
    NSMutableArray * setList = [NSMutableArray new];
    
    [self.database open];
    FMResultSet *results = [self.database executeQuery:@"select * from lset"];
    
    while([results next]) {
        NSDictionary * setDict = @{@"id":            [results stringForColumn:@"id"],
                                    @"name":          [results stringForColumn:@"name"],
                                    @"description":   [results stringForColumn:@"description"],
                                    @"language":      [results stringForColumn:@"language"],
                                    @"package_id":   [results stringForColumn:@"package_id"],
                                    @"order_number": [results stringForColumn:@"order_number"],
                                    @"imgURL":        [results stringForColumn:@"imgURL"]?:@""};
        LSet *set = [[LSet alloc] initWithDict:setDict];
        [setList addObject:set];
    }
    return setList;
}
@end
