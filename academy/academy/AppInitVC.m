//
//  AppInitVC.m
//  academy
//
//  Created by Mac Mini on 7/2/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "AppInitVC.h"
#import "Word.h"
#import "DataEngine.h"
#import "Package.h"
#import "SetWord.h"
#import "LSet.h"
@interface AppInitVC () <ModelDelegate>

@end

@implementation AppInitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self intPackageDB];
    //[self initWordDB];
    //[self initSetWordDB];
    [self intSetDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) intPackageDB
{
    NSLog(@"intPackageDB");
    Package * toRetrivePackages = [Package new];
    toRetrivePackages.delegate = self;
    [toRetrivePackages getAllWithFilter:nil];
}
-(void) intSetDB
{
    NSLog(@"intPackageDB");
    LSet * toRetriveSets = [LSet new];
    toRetriveSets.delegate = self;
    [toRetriveSets getAllWithFilter:nil];
}
-(void) initWordDB
{
    NSLog(@"initWordDB");
    Word * toRetrieveWord = [[Word alloc] init];
    toRetrieveWord.delegate = self;
    [toRetrieveWord getAllWithFilter:nil];
}
-(void) initSetWordDB
{
    NSLog(@"initSetWordDB");
    SetWord * toRetrieveSetWord = [[SetWord alloc] init];
    toRetrieveSetWord.delegate = self;
    [toRetrieveSetWord getAllWithFilter:nil];
}


#pragma mark - Package

- (void)getAllSucessfull:(AModel*)model List:(NSMutableArray *)allList {
    if ([model class] == [Package class]) {
        [DataEngine getInstance].packageList = allList;
        NSLog(@"getAllSucessfull package List = [%i]",allList.count);
        [[DataEngine getInstance] addPackagesToDB:allList];
    }
    if ([model class] == [Word class]) {
        [DataEngine getInstance].wordList = allList;
        NSLog(@"getAllSucessfull words List = [%i]",allList.count);
        [[DataEngine getInstance] addWordsToDB:allList];
    }
    if ([model class] == [SetWord class]) {
        NSLog(@"getAllSucessfull SetWord List = [%i]",allList.count);
        [[DataEngine getInstance] addSetWordsToDB:allList];
    }
    if ([model class] == [LSet class]) {
        NSLog(@"getAllSucessfull LSet List = [%i]",allList.count);
        [[DataEngine getInstance] addSetsToDB:allList];
    }
    
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    NSLog(@"error[%i] = %@",[statusCode intValue],error);
}


@end
