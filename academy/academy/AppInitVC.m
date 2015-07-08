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
#import "PackageTryBuyStatus.h"

#import "SideMenuVC.h"
#import "SIAlertView.h"
#import "ASProgressPopUpView.h"

@interface AppInitVC () <ModelDelegate, LocalDBSetupDelegate, ASProgressPopUpViewDataSource>

@end

@implementation AppInitVC
{
    __weak IBOutlet ASProgressPopUpView *progressView;
    BOOL needUpdateLocalDB;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //disable sideMenu Drag
    MSDynamicsDrawerViewController *dynamicsDrawerViewController = (MSDynamicsDrawerViewController *)self.navigationController.parentViewController;
    
    MSDynamicsDrawerDirectionActionForMaskedValues(dynamicsDrawerViewController.possibleDrawerDirection, ^(MSDynamicsDrawerDirection drawerDirection) {
        [dynamicsDrawerViewController setPaneDragRevealEnabled:NO forDirection:drawerDirection];
    });
    
    [self.navigationController setNavigationBarHidden:YES];
    [DataEngine getInstance].localDBDelegate = self;
    [[DataEngine getInstance] checkIfNeedUpdateData:^(BOOL doesNeedUpdate, BOOL downloadNewVer) {
        NSLog(@"NeedUpdate = %@",doesNeedUpdate?@"YES":@"NO");
        NSLog(@"downloadNewVer = %@",downloadNewVer?@"YES":@"NO");
        needUpdateLocalDB = doesNeedUpdate;
        if (downloadNewVer) {
            [self alertDownloadNewVer];
        }else{
            [self refreshLocalDB];
        }
        
    }];
    
    
    progressView.font = [UIFont fontWithName:@"GothamRounded-Bold" size:26];
    progressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
    progressView.popUpViewCornerRadius = 16.0;
    progressView.dataSource = self;
    [progressView setProgress:0.1 animated:YES];
}

-(void) alertDownloadNewVer
{
    SIAlertView * siAlertView = [[SIAlertView alloc] initWithTitle:@"Thông Báo" message:@"Cập nhật ngay phiên bản mới nhất để trải nghiệm vnAcademy một cách toàn diện nhất!"];
    
    [siAlertView addButtonWithTitle:@"Để Sau"
                               type:SIAlertViewButtonTypeCancel
                            handler:^(SIAlertView *alert) {
                                [self performSelector:@selector(refreshLocalDB) withObject:self afterDelay:.5];
                                
                            }];
    [siAlertView addButtonWithTitle:@"Cập Nhập Ngay"
                               type:SIAlertViewButtonTypeDefault
                            handler:^(SIAlertView *alert) {
                                NSString *iTunesLink = [[DataEngine getInstance] getAppURL];
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                                [self refreshLocalDB];
                            }];
    

        [siAlertView show];
}
-(void) refreshLocalDB
{
    if (needUpdateLocalDB) {
        [progressView setProgress:0.2 animated:YES];
        [[DataEngine getInstance] clearAllLocalDB];
        [self initWordDB];
    }else{
        [[DataEngine getInstance] setupDataFromLocalDB];
    }
}

-(void) goToLoginView
{
    [[SideMenuVC getInstance] transitionToViewController:ControllerLogin animated:NO];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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


#pragma mark - AModel

- (void)getAllSucessfull:(AModel*)model List:(NSMutableArray *)allList {
    if ([model class] == [Package class]) {
        [progressView setProgress:0.8 animated:YES];
        [DataEngine getInstance].packageList = allList;
        NSLog(@"getAllSucessfull package List = [%i]",allList.count);
        [[DataEngine getInstance] addPackagesToDB:allList];
    }
    if ([model class] == [Word class]) {
        [DataEngine getInstance].wordList = allList;
        NSLog(@"[DataEngine getInstance].wordList = %@",[DataEngine getInstance].wordList);
        NSLog(@"getAllSucessfull words List = [%i]",allList.count);
        [[DataEngine getInstance] addWordsToDB:allList];
        [self initSetWordDB];
        [progressView setProgress:0.5 animated:YES];
    }
    if ([model class] == [SetWord class]) {
        NSLog(@"getAllSucessfull SetWord List = [%i]",allList.count);
        [[DataEngine getInstance] addSetWordsToDB:allList];
        [self intSetDB];
        [progressView setProgress:0.6 animated:YES];
    }
    if ([model class] == [LSet class]) {
        NSLog(@"getAllSucessfull LSet List = [%i]",allList.count);
        [[DataEngine getInstance] addSetsToDB:allList];
        [self intPackageDB];
        [progressView setProgress:0.7 animated:YES];
    }
    
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    NSLog(@"error[%i] = %@",[statusCode intValue],error);
}

#pragma mark - LocalDBSetupDelegate

-(void)finishSetupDBSuccessful
{
    NSLog(@"finishSetupDBSuccessful");
    [progressView setProgress:0.9 animated:YES];
    //load package status
    PackageTryBuyStatus *toRetriveStatus = [[PackageTryBuyStatus alloc] init];
    [toRetriveStatus refreshPackStatuswithCompletion:^(BOOL finished) {
        [progressView setProgress:1.0 animated:YES];
        [self performSelector:@selector(goToLoginView) withObject:self afterDelay:1];
    }];
    
    
}
-(void)finishSetupDBWithErrorMessage:(NSString *)error
{
    NSLog(@"finishSetupDBWithErrorMessage: %@", error);
}

#pragma mark - ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *s;
    if (progress < 0.2) {
        s = @"Bắt Đầu";
    } else if (progress > 0.4 && progress < 0.6) {
        s = @"Nữa Đường";
    } else if (progress >= 0.75 && progress < 1.0) {
        s = @"Sắp Xong";
    } else if (progress >= 1.0) {
        s = @"Hoàn Thành";
    }
    return s;
}
@end
