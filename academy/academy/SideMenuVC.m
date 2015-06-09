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
#import "DataEngine.h"

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
@property (nonatomic, strong) NSDictionary *paneViewControllerIdentifiers;
#else
@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
#endif
@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealLeftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealRightBarButtonItem;

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
                                      @(ControllerLogin) : @"Đăng Nhập",
                                      @(ControllerUserShelf) : @"Tủ Sách",
                                      @(ControllerShop) : @"Thư Viện",
                                      @(ControllerProfile) : @"Cá Nhân"
                                      };
#if !defined(STORYBOARD)
    self.paneViewControllerClasses = @{
                                       @(ControllerLogin) : [LoginVC class],
                                       @(ControllerUserShelf) : [UserShelfVC class],
                                       @(ControllerShop) : [ShopVC Class],
                                       @(ControllerProfile) : [ProfileVC Class]
                                       };
#else
    self.paneViewControllerIdentifiers = @{
                                           @(ControllerLogin) : @"loginView",
                                           @(ControllerUserShelf) : @"userShelfView",
                                           @(ControllerShop) : @"shopView",
                                           @(ControllerProfile) : @"profileView"
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
            break;
        case 1:
            return ControllerShop;
        case 2:
            return ControllerProfile;
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
    UIViewController *paneViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
#else
    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    UIViewController *paneViewController = (UIViewController *)[paneViewControllerClass new];
#endif
    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    if (paneViewControllerType != ControllerLogin) {
        self.paneRevealLeftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MenuBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
        paneViewController.navigationItem.leftBarButtonItem = self.paneRevealLeftBarButtonItem;
    }
    
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
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
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    //facebook
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
    //google plus
    [[GPPSignIn sharedInstance] signOut];
}

@end
