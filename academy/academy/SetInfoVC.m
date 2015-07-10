//
//  SetInfoVC.m
//  academy
//
//  Created by Mac Mini on 7/8/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#import "SetInfoVC.h"
#import "WordInfoVC.h"
#import "WordTestVC.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"
#import "TOMSMorphingLabel.h"

#import "SetInfoCollectionCell.h"


@interface SetInfoVC ()<YSLTransitionAnimatorDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *solidBG;
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *titleLb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation SetInfoVC{
    
    BOOL isBack;
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UIView *whiteSolid;
    
    BOOL isFirstLoad;
    NSArray *rowDataSource;
}

static NSString * const reuseIdentifier = @"CollectionCell";

- (void)viewWillDisappear:(BOOL)animated
{
    if (isBack) {
        [self.navigationController setNavigationBarHidden:NO];
        [self ysl_removeTransitionDelegate];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [self ysl_addTransitionDelegate:self];
    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
                                    cancelAnimationPointY:0
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
    [self animateViewAppear];
    
}

- (IBAction)backClicked:(id)sender {
    isBack = YES;
    [UIView animateWithDuration:0.17 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backBtn.transform = CGAffineTransformMakeTranslation(-40, 0);
    } completion:^(BOOL finished){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitView];
    isFirstLoad = YES;
    
    rowDataSource = @[@[@"easel.png",
                        @"Học ngay tất cả!",
                        @"Bắt đầu với tất cả từ vựng tại đây."],
                      @[@"tablet.png",
                        @"Lọc từ đã biết",
                        @"Kiểm tra xem bạn có biết từ nào chưa?"],
                      @[@"star.png",
                        @"Kiếm sao nào!",
                        @"Kiểm tra kết quả học tập và cùng nắm chắc kiến thức."]];
}

-(void) resetView
{
    [self.titleLb setTextWithoutMorphing:self.curSet.name];
    
    whiteSolid.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0, 0),CGAffineTransformMakeTranslation(0, 0));
    _headerImageView.transform = CGAffineTransformMakeTranslation(0, 0);
    
    for (int i = 0; i<rowDataSource.count; i++) {
        SetInfoCollectionCell *cell = (SetInfoCollectionCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell resetView];
    }
    backBtn.transform = CGAffineTransformMakeTranslation(0, 0);
}

#pragma mark -- Appear Animation
- (void) setupInitView
{
    _headerImageView.frame = CGRectMake(self.view.frame.size.width/2 - 128/2, 40, 128, 128);
    self.solidBG.layer.opacity = 0.8f;
    self.solidBG.backgroundColor = self.curSet.solidColor;
    whiteSolid.layer.cornerRadius = 128/2;
    whiteSolid.transform = CGAffineTransformMakeScale(0, 0);
    
    backBtn.transform = CGAffineTransformMakeTranslation(50, 0);
    backBtn.layer.opacity = 0;
    [backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    [self.titleLb setTextWithoutMorphing:self.curUserPack.package.name];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) animateViewAppear
{
    [self.titleLb setText:self.curSet.name];
    
    
    NSMutableArray* animationBlocks = [NSMutableArray new];
    
    typedef void(^animationBlock)(BOOL);
    
    // getNextAnimation
    // removes the first block in the queue and returns it
    animationBlock (^getNextAnimation)() = ^{
        animationBlock block = animationBlocks.count ? (animationBlock)[animationBlocks objectAtIndex:0] : nil;
        if (block){
            [animationBlocks removeObjectAtIndex:0];
            return block;
        }else{
            return ^(BOOL finished){};
        }
    };
    
    //block 1
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            backBtn.transform = CGAffineTransformMakeTranslation(0, 0);
            backBtn.layer.opacity = 1.0f;
            
        } completion: getNextAnimation()];
    }];
    
    //add a block to our queue
    [animationBlocks addObject:^(BOOL finished){;
        
    }];
    
    // execute the first block in the queue
    getNextAnimation()(YES);
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return rowDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"getrow runs");
    
    SetInfoCollectionCell *cell = (SetInfoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *rowData = [rowDataSource objectAtIndex:indexPath.row];
    [cell.itemImage setImage:[UIImage imageNamed:rowData[0]]];
    [cell.titleLb setText:rowData[1]];
    [cell.subTitleLb setText:rowData[2]];
    
    if (isFirstLoad) {
        [cell setAppearAfterDelay:indexPath.row * 0.4 + 0.3];
    }
    else
    {
        [cell resetView];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    isFirstLoad = NO;
    SetInfoCollectionCell *cell = (SetInfoCollectionCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
    [cell animateViewDisappearRight];
    for (int i = 0; i<rowDataSource.count; i++) {
        SetInfoCollectionCell *otherCell = (SetInfoCollectionCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (otherCell != cell) {
            [otherCell animateViewDisappearLeft];
        }
    }
    [self performSelector:@selector(navigateViewDidSelectItem) withObject:self afterDelay:1.5];
    [self disappearAnimation];
    [self performSelector:@selector(resetView) withObject:self afterDelay:3];

}

-(void) navigateViewDidSelectItem
{
    UIViewController * destination;
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 0) {
        WordInfoVC * view = [storyboard instantiateViewControllerWithIdentifier:@"wordInfoView"];
        view.curSet = self.curSet;
        view.isWordCheckSession = NO;
        destination = view;
    }
    if (indexPath.row == 1) {
        WordInfoVC * view = [storyboard instantiateViewControllerWithIdentifier:@"wordInfoView"];
        view.curSet = self.curSet;
        view.isWordCheckSession = YES;
        destination = view;
    }
    if (indexPath.row == 2) {
        WordTestVC * view = [storyboard instantiateViewControllerWithIdentifier:@"wordTestView"];
        view.curSet = self.curSet;
        view.curUserPack = self.curUserPack;
        destination = view;
    }
    destination.providesPresentationContextTransitionStyle = YES;
    destination.definesPresentationContext = YES;
    [destination setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:destination animated:YES completion:nil];
}

-(void) disappearAnimation
{
    [UIView animateWithDuration:0.17 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backBtn.transform = CGAffineTransformMakeTranslation(-40, 0);
    } completion:nil];
    [self.titleLb setText:@""];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    [UIView animateWithDuration:0.14 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.headerImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(35));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.1
                              delay:0.0
             usingSpringWithDamping:0.2
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.headerImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(0));
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                 self.headerImageView.transform = CGAffineTransformMakeTranslation(0, -10);
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                     self.headerImageView.transform = CGAffineTransformMakeTranslation(0, screenSize.height);
                                 } completion:nil];
                             }];
                         }];
    }];
    [UIView animateWithDuration:0.7
                          delay:0.5
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         whiteSolid.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                             whiteSolid.transform = CGAffineTransformMakeTranslation(0, -10);
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                 whiteSolid.transform = CGAffineTransformMakeTranslation(0, screenSize.height);
                             } completion:nil];
                         }];
                     }];
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(290, 80);
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)popTransitionImageView
{
    return self.headerImageView;
}

- (UIImageView *)pushTransitionImageView
{
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
