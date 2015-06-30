//
//  ShelfCollectionVC.m
//  academy
//
//  Created by Mac Mini on 6/30/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ShelfCollectionVC.h"
#import "ShelfCollectionCell.h"
#import "PackageDetailVC.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

@interface ShelfCollectionVC () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout, YSLTransitionAnimatorDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *parallaxCollectionView;
@property (nonatomic, strong) NSMutableArray* images;

@end

@implementation ShelfCollectionVC

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    [self.parallaxCollectionView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    [self ysl_addTransitionDelegate:self];
    [self ysl_pushTransitionAnimationWithToViewControllerImagePointY:statusHeight + navigationHeight
                                                   animationDuration:0.3];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDatasource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShelfCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MJCell" forIndexPath:indexPath];
    
    //get image name and assign
    NSString* imageName = [self.images objectAtIndex:indexPath.item];
    cell.image = [UIImage imageNamed:imageName];
    
    //set offset accordingly
    CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - cell.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
    cell.imageOffset = CGPointMake(0.0f, yOffset);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"collectionViewCell selected");
    [self.navigationController setNavigationBarHidden:YES];
    PackageDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"packageDetailView"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for(ShelfCollectionCell *view in self.parallaxCollectionView.visibleCells) {
        CGFloat yOffset = ((self.parallaxCollectionView.contentOffset.y - view.frame.origin.y) / IMAGE_HEIGHT) * IMAGE_OFFSET_SPEED;
        view.imageOffset = CGPointMake(0.0f, yOffset);
    }
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.frame.size.width / 2) - 9, (self.view.frame.size.width / 2) - 9);
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
