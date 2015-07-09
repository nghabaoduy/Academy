//
//  SideMenuVC.m
//  FoodOrder
//
//  Created by Brian on 5/20/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

#import "SideMenuVC.h"
#import "LoginVC.h"
#import "SideMenuCell.h"
#import "SideMenuHeader.h"
#import "UserShelfVC.h"
#import "ShopVC.h"
#import "ProfileVC.h"
#import "AppSettingVC.h"
#import "DataEngine.h"
#import "AppInitVC.h"
#import "ShelfCollectionVC.h"
#import "ShopCollectionVC.h"


#import "LTCustomNavigationBar.h"

NSString * const MenuCellReuseIdentifier = @"menuCell";
NSString * const MenuHeaderReuseIdentifier = @"menuHeader";

typedef NS_ENUM(NSUInteger, MSMenuViewControllerTableViewSectionType) {
    MSMenuViewControllerTableViewSectionTypeOptions,
    MSMenuViewControllerTableViewSectionTypeExamples,
    MSMenuViewControllerTableViewSectionTypeAbout,
    MSMenuViewControllerTableViewSectionTypeCount
};

@interface SideMenuVC ()

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;
#if defined(STORYBOARD)
@property (nonatomic, strong) NSDictionary *paneViewControllerStoryboards;
@property (nonatomic, strong) NSDictionary *paneViewControllerIdentifiers;
#else
@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
#endif
@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;


@property (nonatomic, strong) NSArray *menuIconList;
@property (nonatomic, strong) NSArray *menuTitleList;
@property (nonatomic, strong) NSArray *menuNavList;
@property (nonatomic, strong) NSArray *menuHeaderTitle;

@end


@implementation SideMenuVC

static SideMenuVC * instance = nil;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (instance) {
        return instance;
    }
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    instance = self ;
    return instance;
}
+ (id)getInstance{
    return instance;
}
#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (instance) {
        return instance;
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    instance = self;
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[SideMenuCell class] forCellReuseIdentifier:MenuCellReuseIdentifier];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MSMenuViewController

- (void)initialize
{
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerTitles = @{
                                      @(ControllerAppInit): @"",
                                      @(ControllerLogin) : @"Đăng Nhập",
                                      @(ControllerUserShelf) : @"Tủ Sách",
                                      @(ControllerShop) : @"Thư Viện",
                                      @(ControllerProfile) : @"Cá Nhân",
                                      @(ControllerSetting) : @"Điều Chỉnh"
                                      };
#if !defined(STORYBOARD)
    self.paneViewControllerClasses = @{
                                       @(ControllerAppInit) : [AppInitVC class],
                                       @(ControllerLogin) : [LoginVC class],
                                       @(ControllerUserShelf) : [ShelfCollectionVC class],
                                       @(ControllerShop) : [ShopCollectionVC class],
                                       @(ControllerProfile) : [ProfileVC class],
                                       @(ControllerSetting) : [AppSettingVC class]
                                       };
#else
    self.paneViewControllerStoryboards = @{
                                           @(ControllerAppInit) : @"Main",
                                           @(ControllerLogin) : @"Main",
                                           @(ControllerUserShelf) : @"PackageStoryboard",
                                           @(ControllerShop) : @"PackageStoryboard",
                                           @(ControllerProfile) : @"Main",
                                           @(ControllerSetting) : @"Main"
                                           };
    self.paneViewControllerIdentifiers = @{
                                           @(ControllerAppInit) : @"appInitView",
                                           @(ControllerLogin) : @"loginView",
                                           @(ControllerUserShelf) : @"shelfCollectionView",
                                           @(ControllerShop) : @"shopCollectionView",
                                           @(ControllerProfile) : @"profileView",
                                           @(ControllerSetting) : @"appSettingView"
                                           };
#endif
    self.sectionTitles = @{
                           
                           };
    
    self.tableViewSectionBreaks = @[
                                    
                                    ];
    
    self.menuIconList = @[
                          @"book.png",
                          @"shop.png",
                          //@"wallet.png",
                          @"user.png",
                          @"config.png"
                          ];
    self.menuTitleList = @[
                           @"Tủ Sách",
                           @"Thư Viện",
                           //@"Nạp Thẻ",
                           @"Cá Nhân",
                           @"Điều Chỉnh",
                           @"Thoát"
                           ];
    
    self.menuHeaderTitle = @[@"Menu"];
}

- (MSPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return ControllerUserShelf;
        case 1:
            return ControllerShop;
        case 2:
            return ControllerProfile;
        case 3:
            return ControllerSetting;
        case 4:
            return ControllerLogin;
        default:
            break;
    }
    return ControllerUserShelf;
}

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType animated:(BOOL) animated
{
    // Close pane if already displaying the pane view controller
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.dynamicsDrawerViewController.paneViewController != nil && animated;
    
#if defined(STORYBOARD)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:self.paneViewControllerStoryboards[@(paneViewControllerType)] bundle:nil];
    UIViewController *paneViewController = [storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
#else
    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    UIViewController *paneViewController = (UIViewController *)[paneViewControllerClass new];
#endif
    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    if (paneViewControllerType != ControllerLogin) {
        
        self.paneRevealLeftBarButtonItem = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,22)];
        [self.paneRevealLeftBarButtonItem setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
        [self.paneRevealLeftBarButtonItem addTarget:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:self.paneRevealLeftBarButtonItem];
        self.navigationItem.rightBarButtonItem = buttonItem;
        
        [self.paneRevealLeftBarButtonItem setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                              kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                              kFRDLivelyButtonColor: [UIColor whiteColor]
                              }];
        
        paneViewController.navigationItem.leftBarButtonItem = buttonItem;
    }
    
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [paneNavigationViewController setValue:[[LTCustomNavigationBar alloc]init] forKeyPath:@"navigationBar"];
    [self.dynamicsDrawerViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender
{
    NSLog(@"dynamicsDrawerRevealLeftBarButtonItemTapped called");
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:nil];
}

- (void)dynamicsDrawerRevealRightBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionRight animated:YES allowUserInterruption:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.menuHeaderTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.menuTitleList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuCellReuseIdentifier];
    
    cell.titleLb.text = [self.menuTitleList objectAtIndex:indexPath.row];
    if (indexPath.row <= self.menuIconList.count -1) {
        [cell.icon setImage:[UIImage imageNamed:[self.menuIconList objectAtIndex:indexPath.row]]];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SideMenuHeader *headerView = [[SideMenuHeader alloc] init];
    headerView.titleLb.text = [self.menuHeaderTitle objectAtIndex:section];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    if ([[DataEngine getInstance] isOffline]) {
        if (paneViewControllerType == ControllerProfile || paneViewControllerType == ControllerShop) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Bạn chỉ sử dụng được ứng dụng này khi kết nối với internet." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 
                                                             }];
            [alertController addAction:dismiss];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
    }
    
    if (paneViewControllerType == ControllerLogin) {
        //logout
        [self logout];
        [self transitionToViewController:paneViewControllerType animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else
    {
        [self transitionToViewController:paneViewControllerType animated:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
//=== LOG OUT ===//
-(void) logout
{
    NSString *saveUsername = @"";
    if ([[DataEngine getInstance] loginType] == LoginNormal ) {
        saveUsername = [[NSUserDefaults standardUserDefaults]valueForKey:@"saveUsername"];
    }
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    //facebook
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    //google plus
    [[GPPSignIn sharedInstance] signOut];
    
    if (![saveUsername isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setValue:saveUsername forKey:@"saveUsername"];
    }
}

@end
