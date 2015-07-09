//
//  ShelfCollectionVC.m
//  academy
//
//  Created by Mac Mini on 6/30/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ShelfCollectionVC.h"
#import "ShelfCollectionCell.h"
#import "SetCollectionVC.h"

#import "SetSelectVC.h"
#import "AFNetworking.h"
#import "Package.h"
#import "UserPackage.h"
#import "User.h"
#import "DataEngine.h"
#import "LanguageControl.h"
#import "SideMenuVC.h"
#import "PackageTryBuyStatus.h"

#import "MSDynamicsDrawerViewController.h"
#import "UIImageView+AFNetworking.h"
#import <MBProgressHUD/MBProgressHUD.h>


@interface ShelfCollectionVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, ModelDelegate, AuthDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *parallaxCollectionView;
@property (nonatomic, strong) NSMutableArray* images;

@end

@implementation ShelfCollectionVC{
    NSMutableArray *packageList;
    
    int cellInitHeight;
    NSIndexPath *curCellPath;
    int cellTopMargin;
    NSMutableArray * packageLangList;
    NSMutableArray * languageList;
    BOOL isNavBarNormal;
    BOOL isFirstLoad;
}

int defaultNavY;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    isNavBarNormal = NO;
    
    //enable sideMenu Drag
    MSDynamicsDrawerViewController *dynamicsDrawerViewController = (MSDynamicsDrawerViewController *)self.navigationController.parentViewController;
    
    MSDynamicsDrawerDirectionActionForMaskedValues(dynamicsDrawerViewController.possibleDrawerDirection, ^(MSDynamicsDrawerDirection drawerDirection) {
        [dynamicsDrawerViewController setPaneDragRevealEnabled:YES forDirection:drawerDirection];
    });
    
    defaultNavY = self.navigationController.navigationBar.layer.position.y;
    // Do any additional setup after loading the view, typically from a nib.
    
    // Fill image array with images
    NSUInteger index;
    for (index = 0; index < 14; ++index) {
        // Setup image name
        NSString *name = [NSString stringWithFormat:@"image%03ld.jpg", (unsigned long)index];
        if(!self.images)
            self.images = [NSMutableArray arrayWithCapacity:0];
        [self.images addObject:name];
    }
    
    [[DataEngine getInstance] setIsForceReload:YES];
     [self retrievePackages];
    
    
}


-(void) retrievePackages
{
    NSLog(@"retrievePackages runs");
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
    isFirstLoad = YES;
    [self.parallaxCollectionView reloadData];
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
-(void)viewWillAppear:(BOOL)animated
{
    
    [self animateNavigationBarUp:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDatasource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [packageLangList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableArray *langArr = packageLangList[section];
    return langArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShelfCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];
    
    NSMutableArray *langArr = packageLangList[indexPath.section];
    UserPackage * curUserPackage = [langArr objectAtIndex:indexPath.row];
    Package *pack = curUserPackage.package;
    
    [cell setCellWithPackage:pack];
    //get image name and assign
    NSString* imageName = [self.images objectAtIndex:arc4random_uniform(self.images.count)];
    cell.image = [UIImage imageNamed:imageName];
    
    //set offset accordingly
    CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    
    if (isFirstLoad) {
        [cell setAppearAfterDelay:indexPath.row * 0.5];
    }
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        ShelfCollectionCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
        
        NSString * lang = [languageList objectAtIndex:indexPath.section];
        lang = [NSString stringWithFormat:@"- %@ -",[[LanguageControl getInstance] getLanguageTranslateByLang:lang]];
        headerView.titleLb.text = lang;
        reusableview = headerView;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.bounds.size.width, 40);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self animateNavigationBarUp:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SetStoryboard" bundle:nil];
    SetCollectionVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"setCollectionView"];
    NSMutableArray *langArr = packageLangList[indexPath.section];
    UserPackage * curUserPackage = [langArr objectAtIndex:indexPath.row];
    vc.curUserPack = curUserPackage;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)animateNavigationBarUp:(BOOL) hide
{
    if (hide == NO && isNavBarNormal) {
        return;
    }
    isNavBarNormal = !hide;

    if(hide) {
        CALayer *layer = self.navigationController.navigationBar.layer;
        layer.position = CGPointMake(layer.position.x, defaultNavY);
        [UIView animateWithDuration:0.25 animations:^{
            layer.position = CGPointMake(layer.position.x, -layer.frame.size.height);
        }];
    } else {
        CALayer *layer = self.navigationController.navigationBar.layer;
        layer.position = CGPointMake(layer.position.x, -layer.frame.size.height);
        [UIView animateWithDuration:0.25 animations:^{
            layer.position = CGPointMake(layer.position.x,defaultNavY);
        }];
    }
}
#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isFirstLoad) {
        isFirstLoad = NO;
    }
    
    for(ShelfCollectionCell *view in self.parallaxCollectionView.visibleCells) {
        CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * (630.0f/1242));
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
    
}


@end
