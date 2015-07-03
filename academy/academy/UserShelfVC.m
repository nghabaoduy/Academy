//
//  UserShelfVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "UserShelfVC.h"
#import "SetSelectVC.h"
#import "PackageCell.h"
#import "AFNetworking.h"
#import "Package.h"
#import "UserPackage.h"
#import "User.h"
#import "DataEngine.h"
#import "ShelfHeader.h"
#import "MSDynamicsDrawerViewController.h"
#import "UIImageView+AFNetworking.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SideMenuVC.h"


@interface UserShelfVC () <ModelDelegate, AuthDelegate, PackageCellDelegate>

@end

@implementation UserShelfVC {
    NSMutableArray *packageList;
    
    int cellInitHeight;
    NSIndexPath *curCellPath;
    int cellTopMargin;
    UIRefreshControl * refeshControl;
    NSMutableArray * packageLangList;
    NSMutableArray * languageList;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //enable sideMenu Drag
    MSDynamicsDrawerViewController *dynamicsDrawerViewController = (MSDynamicsDrawerViewController *)self.navigationController.parentViewController;
    
    MSDynamicsDrawerDirectionActionForMaskedValues(dynamicsDrawerViewController.possibleDrawerDirection, ^(MSDynamicsDrawerDirection drawerDirection) {
        [dynamicsDrawerViewController setPaneDragRevealEnabled:YES forDirection:drawerDirection];
    });
    
    
    packageList = [NSMutableArray new];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    cellTopMargin = 10;
    cellInitHeight = screenWidth *3/10 +cellTopMargin;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupRefreshControl];
    
    [[DataEngine getInstance] setIsForceReload:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)setupRefreshControl{
    if ([[DataEngine getInstance] isOffline]) {
        return;
    }
    self.sunnyRefreshControl = [YALSunnyRefreshControl attachToScrollView:self.tableView
                                                                   target:self
                                                            refreshAction:@selector(sunnyControlDidStartAnimation)];
    
}

-(void)sunnyControlDidStartAnimation{
    
    [self retrievePackages];
}

-(IBAction)endAnimationHandle{
    
    [self.sunnyRefreshControl endRefreshing];
}
- (void)viewDidAppear:(BOOL)animated {
    if ([[DataEngine getInstance] isForceReload]) {
        [self retrievePackages];
        [[DataEngine getInstance] setIsForceReload:NO];
    }
}

-(void) retrievePackages
{
    NSLog(@"retrievePackages runs");
    
    [refeshControl beginRefreshing];
    UserPackage * userPackage = [UserPackage new];
    [userPackage setDelegate:self];
    NSLog(@"curUser.id = %@",[[User currentUser] modelId]);
    [userPackage getAllWithFilter:@{@"user_id" : [[User currentUser] modelId], @"needLoadPackage":@"NO"}];
}
-(void) organizePackageList
{
    [packageList sortUsingComparator:^NSComparisonResult(UserPackage * upack1, UserPackage * upack2) {
        return [upack1.package.orderCode compare:upack2.package.orderCode];
    }];
    
    packageLangList = [NSMutableArray new];
    languageList = [NSMutableArray new];
    
    for (UserPackage * uPackage in packageList) {
        BOOL isAvai = NO;
        for(NSString * langStr in languageList) {
            if ([uPackage.package.language isEqualToString:langStr]) {
                isAvai = YES;
            }
        }
        if (!isAvai) {
            [languageList addObject:uPackage.package.language];
        }
    }
    for (NSString *langStr in languageList) {
        [packageLangList addObject:[NSMutableArray new]];
    }
    for (UserPackage * uPackage in packageList) {
        for(int i = 0; i<languageList.count;i++) {
            NSString * langStr = languageList[i];
            if ([uPackage.package.language isEqualToString:langStr]) {
                NSMutableArray *langArr = packageLangList[i];
                [langArr addObject:uPackage];
            }
        }
    }
    [self reloadData];
    [self checkToBuyPack];
    
    
}
-(void) checkToBuyPack
{
    if (packageList.count == 0) {
        if ([[DataEngine getInstance] isOffline]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Bạn hãy đăng nhập lại với kết nối Internet đễ có thể thử ngay bộ ngôn ngữ đầu tiên nhé!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                             }];
            [alertController addAction:dismiss];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Bạn chưa có bộ ngôn ngữ nào trong tử sách. Vào thư viên ngay!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [[SideMenuVC getInstance] transitionToViewController:ControllerShop animated:YES];
                                                             }];
            
            [alertController addAction:dismiss];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return languageList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *langArr = packageLangList[section];
    return langArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"packCell" forIndexPath:indexPath];
    
    NSMutableArray *langArr = packageLangList[indexPath.section];
    UserPackage * curUserPackage = [langArr objectAtIndex:indexPath.row];
    Package *pack = curUserPackage.package;
    [cell.textLabel setHidden:YES];
    [cell.packTitle setText:pack.name];
    [cell.purchaseBtn setHidden:YES];
    cell.packageCellDelegate = self;
    [cell.packSubTitle setText:[NSString stringWithFormat:@"%i Words",pack.wordsTotal]];
    if([curUserPackage.purchaseType isEqualToString:@"try"])
    {
        [cell.purchaseBtn setHidden:NO];
        [cell.purchaseBtn setTitle:@"Mua Ngay" forState:UIControlStateNormal];
    }
    else
    {
        if ([curUserPackage isExpired]) {
            [cell.purchaseBtn setHidden:NO];
            [cell.purchaseBtn setTitle:@"Gia Hạn" forState:UIControlStateNormal];
        }
    }
    if ([curUserPackage.score intValue] > 0) {
        [cell.rankImg setHidden:NO];
        [cell.rankImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"packRankStar_%i.png",[curUserPackage.score intValue]]]];
    }   else   {
        [cell.rankImg setHidden:YES];
    }
    
    if ([pack.price intValue] == 0) {
        [cell.priceLb setText:@"FREE"];
    }
    else
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[pack.price integerValue]]];
        formatted = [formatted stringByReplacingOccurrencesOfString:@"," withString:@"."];
        [cell.priceLb setText:[NSString stringWithFormat:@"%@ đ",formatted]];
    }
    

    if (pack.imgURL)
        [cell.packageImg setImageWithURL:[NSURL URLWithString:pack.imgURL] placeholderImage:[UIImage imageNamed:@"dummyBanner.png"]];
    else
        [cell.packageImg setImage:[UIImage imageNamed:@"dummyBanner.png"]];
    
    User *curUser = [User currentUser];
    cell.packageImg.layer.opacity = [curUser canViewThisPackage:pack]?1:0.5f;
    
    
    return cell;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShelfHeader *headerView = [[ShelfHeader alloc] init];
    NSString * lang = [languageList objectAtIndex:section];
    lang = [NSString stringWithFormat:@"%@%@",[[lang substringToIndex:1] uppercaseString], [lang substringFromIndex:1]];
    headerView.titleLb.text = lang;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellInitHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    [self.sunnyRefreshControl endRefreshing];
}
#pragma mark - Model Delegate

- (void)getAllSucessfull:(AModel*)model List:(NSMutableArray *)allList {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    packageList = allList;
    [self organizePackageList];
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"error %@", error);
    //[self.refreshControl endRefreshing];
    [self.sunnyRefreshControl endRefreshing];

}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goSetList"])
    {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        NSMutableArray *langArr = packageLangList[indexPath.section];
        UserPackage * userPack = [langArr objectAtIndex:indexPath.row];
        
        SetSelectVC * destination = segue.destinationViewController;
        [destination setTitle:userPack.package.name];
        destination.curUserPack = userPack;
    }
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"goSetList"])
    {
        User *curUser = [User currentUser];
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        NSMutableArray *langArr = packageLangList[indexPath.section];
        UserPackage * userPack = [langArr objectAtIndex:indexPath.row];
  
        if (![curUser canViewThisPackage:userPack.package]) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Gói ngôn ngữ này đang được cập nhập." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                             }];
            
            [alertController addAction:dismiss];
            [self presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
        
        if ([userPack isExpired]) {
            [self showRenewAlertForUserPackage:userPack];
            return NO;
        }
    }
    return YES;
}
-(void) showRenewAlertForUserPackage:(UserPackage *)userPack
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[userPack.package.price integerValue]]];
    formatted = [formatted stringByReplacingOccurrencesOfString:@"," withString:@"."];
    
    NSString * price = [userPack.package.price intValue] == 0?@"miễn phí":[NSString stringWithFormat:@"với %@đ",formatted];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:[NSString stringWithFormat:@"Gói ngôn ngữ này đã hết hạn sữ dụng. Bạn có muốn gia hạn %@?",price] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * buy = [UIAlertAction actionWithTitle:@"Gia Hạn"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                                     User * user = [User currentUser];
                                                     [user setAuthDelegate:self];
                                                     [user renewPurchase: userPack];
                                                 }];
    UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"Để Sau"
                                                       style:UIAlertActionStyleCancel
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    
    [alertController addAction:buy];
    [alertController addAction:dismiss];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - Auth delegate
- (void)userRenewPurchaseSucessful:(User *)user {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"purchase successful");
    [self retrievePackages];
}

- (void)userRenewPurchaseFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([[NSString stringWithFormat:@"%@",[error valueForKey:@"message"]] isEqualToString:@"Insufficient credit to purchase"]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Số dư tài khoản không đủ mua bộ ngôn ngữ này. Cập nhập phiên bản mới nhất để mua bộ ngôn ngữ này." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             NSString *iTunesLink = [[DataEngine getInstance] getAppURL];
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSLog(@"purchase failed %@", error);
}
- (void)userPurchasePackageSucessful:(User *)user {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"purchase successful");
    [self retrievePackages];
}

- (void)userPurchasePackageFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([[NSString stringWithFormat:@"%@",[error valueForKey:@"message"]] isEqualToString:@"Insufficient credit to purchase"]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Số dư tài khoản không đủ mua bộ ngôn ngữ này. Cập nhập phiên bản mới nhất để mua bộ ngôn ngữ này." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             NSString *iTunesLink = [[DataEngine getInstance] getAppURL];
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSLog(@"purchase failed %@", error);
}

#pragma mark - PackageCellDelegate
-(void)packageCellPurchaseBtnClicked:(PackageCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSMutableArray *langArr = packageLangList[indexPath.section];
    UserPackage * userPack = [langArr objectAtIndex:indexPath.row];
    
    if ([cell.purchaseBtn.titleLabel.text isEqualToString:@"Mua Ngay"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        User * user = [User currentUser];
        [user setAuthDelegate:self];
        [user purchasePackage: userPack.package];
    }
    if ([cell.purchaseBtn.titleLabel.text isEqualToString:@"Gia Hạn"]) {
        [self showRenewAlertForUserPackage:userPack];
    }
    
}

@end
