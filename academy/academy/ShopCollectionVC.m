//
//  ShelfCollectionVC.m
//  academy
//
//  Created by Mac Mini on 6/30/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ShopCollectionVC.h"
#import "ShelfCollectionCell.h"
#import "PackageDetailVC.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

#import "SetSelectVC.h"
#import "AFNetworking.h"
#import "Package.h"
#import "Package.h"
#import "User.h"
#import "DataEngine.h"
#import "LanguageControl.h"
#import "ShelfCollectionVC.h"
#import "MSDynamicsDrawerViewController.h"
#import "UIImageView+AFNetworking.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "SideMenuVC.h"
#import "PackageTryBuyStatus.h"

@interface ShopCollectionVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, YSLTransitionAnimatorDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *parallaxCollectionView;
@property (nonatomic, strong) NSMutableArray* images;

@end

@implementation ShopCollectionVC{
    NSMutableArray *packageList;
    
    int cellInitHeight;
    NSIndexPath *curCellPath;
    int cellTopMargin;
    NSMutableArray * packageLangList;
    NSMutableArray * languageList;
    
    BOOL isFirstLoad;
}

int defaultNavY;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [self performSelector:@selector( organizePackageList) withObject:self afterDelay:0.7];
    
}



-(void) organizePackageList
{
    packageLangList = [NSMutableArray new];
    languageList = [NSMutableArray new];
    packageList = [NSMutableArray new];
    User * curUser = [User currentUser];
    for (Package * pack in [DataEngine getInstance].packageList) {
        if([curUser canViewThisPackage:pack])
            [packageList addObject:pack];
    }
    
    [packageList sortUsingComparator:^NSComparisonResult(Package * pack1, Package * pack2) {
        return [pack1.orderCode compare:pack2.orderCode];
    }];
    
    for (Package * package in packageList) {
        BOOL isAvai = NO;
        for(NSString * langStr in languageList) {
            if ([package.language isEqualToString:langStr]) {
                isAvai = YES;
            }
        }
        if (!isAvai) {
            [languageList addObject:package.language];
        }
    }
    for (NSString *langStr in languageList) {
        [packageLangList addObject:[NSMutableArray new]];
    }
    for (Package * package in packageList) {
        for(int i = 0; i<languageList.count;i++) {
            NSString * langStr = languageList[i];
            if ([package.language isEqualToString:langStr]) {
                NSMutableArray *langArr = packageLangList[i];
                [langArr addObject:package];
            }
        }
    }
    isFirstLoad = YES;
    [self.parallaxCollectionView reloadData];
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
    [self.navigationController setNavigationBarHidden:NO];
    CALayer *layer = self.navigationController.navigationBar.layer;
    layer.position = CGPointMake(layer.position.x, -layer.frame.size.height);
    [self animateNavigationBarUp:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self ysl_addTransitionDelegate:self];
    [self ysl_pushTransitionAnimationWithToViewControllerImagePointY:0
                                                   animationDuration:0.3];
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
    Package *pack = [langArr objectAtIndex:indexPath.row];
    
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
    [self animateNavigationBarUp:YES];
    PackageDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"packageDetailView"];
    NSMutableArray *langArr = packageLangList[indexPath.section];
    Package *pack = [langArr objectAtIndex:indexPath.row];

    vc.curPack = pack;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)animateNavigationBarUp:(BOOL) hide
{
    CALayer *layer = self.navigationController.navigationBar.layer;
    
    if(hide) {
        [UIView animateWithDuration:0.25 animations:^{
            layer.position = CGPointMake(layer.position.x, -layer.frame.size.height);
        }];
    } else {
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

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)pushTransitionImageView
{
    ShelfCollectionCell *cell = (ShelfCollectionCell *)[self.parallaxCollectionView cellForItemAtIndexPath:[[self.parallaxCollectionView indexPathsForSelectedItems] firstObject]];
    return cell.MJImageView;
}

- (UIImageView *)popTransitionImageView
{
    return nil;
}


@end
