//
//  SetCollectionVC.m
//  academy
//
//  Created by Mac Mini on 7/8/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetCollectionVC.h"
#import "SetInfoVC.h"
#import "LSet.h"
#import "User.h"
#import "SetCollectionCell.h"
#import "WordTestVC.h"
#import "FRDLivelyButton.h"
#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIColor+FlatColors/UIColor+FlatColors.h>

@interface SetCollectionVC ()<UICollectionViewDelegateFlowLayout, YSLTransitionAnimatorDataSource>

@property (nonatomic, strong) NSMutableArray *items;


@end
int defaultNavY;

@implementation SetCollectionVC{
    FRDLivelyButton *backButton;
    
    NSMutableArray *setOrderArray;
    NSArray *tempArray;
    //SetDisplayer *clickedSetDisplayer;
    BOOL isDisplayerClicked;
    
    int scoreLoadCount;
    int setLoadCount;
    NSMutableArray * fullWordList;
    
    int maxUnlock;
    int curUnlock;
    NSMutableArray *curUnlockList;
    
    Package * curPack;
    BOOL isFirstLoad;
    
    NSMutableArray * colorArray;
    NSMutableArray * iconArray;
}

@synthesize curUserPack;
static NSString * const reuseIdentifier = @"CollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.collectionView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height + 10, 0, 0, 0)];
    
    backButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,26)];
    [backButton setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    [backButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [backButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                          kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                          kFRDLivelyButtonColor: [UIColor whiteColor]
                          }];
    
    self.navigationItem.leftBarButtonItem = buttonItem;
    [backButton setStyle:kFRDLivelyButtonStyleCaretLeft animated:YES];
    
    self.navigationItem.title = self.curUserPack.package.name;
    defaultNavY = self.navigationController.navigationBar.layer.position.y;
    
    [self performSelector:@selector(organizeSet) withObject:self afterDelay:0.5];
    isFirstLoad = YES;
}
-(void) organizeSet
{
    maxUnlock = 2;
    curPack = curUserPack.package;
    //self.tableView.allowsSelection = NO;
    setOrderArray = [NSMutableArray new];
    
    for (LSet *set in curPack.setList) {
        set.solidColor = [self getRdColor];
        set.imgURL = [self getRdIcon];
        NSLog(@"set = %@",set);
        int row = set.orderNo/2;
        while (setOrderArray.count <= row) {
            [setOrderArray addObject:[NSMutableArray new]];
        }
        NSMutableArray * orderList = setOrderArray[row];
        [orderList addObject:set];
        [orderList sortUsingComparator:^NSComparisonResult(LSet * set1, LSet * set2) {
            return (set1.orderNo%2)>(set2.orderNo%2);
        }];
    }
    [self refreshTable];
}

-(void) dismissView
{
    
    [self.navigationController popViewControllerAnimated:YES];
    [backButton setStyle:kFRDLivelyButtonStyleHamburger animated:YES];
}

-(void) refreshTable
{
    curUnlock = 0;
    curUnlockList = [NSMutableArray new];
    isFirstLoad = YES;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    //float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    [self ysl_addTransitionDelegate:self];
    [self ysl_pushTransitionAnimationWithToViewControllerImagePointY:60
                                                   animationDuration:0.3];
}
-(void)viewWillAppear:(BOOL)animated
{
    if (isFirstLoad) {
        return;
    }
    [self.navigationController setNavigationBarHidden:NO];
    CALayer *layer = self.navigationController.navigationBar.layer;
    layer.position = CGPointMake(layer.position.x, -layer.frame.size.height);
    [self animateNavigationBarUp:NO];
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!curPack) {
        return 0;
    }
    if (curPack.setList.count == 0) {
        return 0;
    }
    return curPack.setList.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"getrow runs");
    SetCollectionCell *cell = (SetCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //final row
    if (indexPath.row == curPack.setList.count) {
        
        cell.solidColor = [UIColor flatSunFlowerColor];
        UIImage *img = [UIImage imageNamed:@"sticker_finaltest.png"];
        [cell.itemImage setImage:img];
        //[cell setFinalTest:curPack];
        
        /*[self isAllSetIsRanked]? [cell.setDisplayer enableDisplayer]: [cell.setDisplayer disableDisplayer];
        if([[[User currentUser] role] isEqualToString:@"admin"] || [[[User currentUser] role] isEqualToString:@"tester"])
        {
            [cell.setDisplayer enableDisplayer];
        }*/
    }else{
        //cell.setDisplayer.delegate = self;
        LSet *set = curPack.setList[indexPath.row];
        cell.curSet = set;
        //[self checkUnlockSetDisplayer:cell.setDisplayer];
        
        UIImage *img = [UIImage imageNamed:set.imgURL];
        [cell.itemImage setImage:img];
        cell.solidColor = set.solidColor;
    }
    if (isFirstLoad) {
        [cell setAppearAfterDelay:indexPath.row * 0.3];
    }
    else
    {
        [cell resetView];
    }
    return cell;
    

}

-(BOOL) isAllSetIsRanked
{
    for (LSet * set in curPack.setList) {
        if (set.grade == 0) {
            return NO;
        }
    }
    return YES;
}
-(void) checkUnlockSetDisplayer:(SetDisplayer *) setDisplayer
{
    if([[[User currentUser] role] isEqualToString:@"admin"] || [[[User currentUser] role] isEqualToString:@"tester"])
    {
        [setDisplayer enableDisplayer];
        return;
    }
    if ((curUnlock < maxUnlock && !setDisplayer.isEnabled) || (curUnlockList.count <=maxUnlock && [curUnlockList containsObject:setDisplayer])) {
        [setDisplayer enableDisplayer];
        curUnlock++;
        if (![curUnlockList containsObject:setDisplayer]) {
            [curUnlockList addObject:setDisplayer];
        }
        
    }
}

-(NSString *) getRdIcon
{
    if (!iconArray) {
        
        iconArray = [@[
                       @"arrows.png",
                       @"bag.png",
                       @"basket.png",
                       @"book.png",
                       @"box.png",
                       @"browser.png",
                       @"building.png",
                       @"calculator.png",
                       @"calendar.png",
                       @"call.png",
                       @"camera.png",
                       @"clock.png",
                       @"cloudupload.png",
                       @"comment.png",
                       @"compass.png",
                       @"config.png",
                       @"console.png",
                       @"count.png",
                       @"creditcard.png",
                       @"disk.png",
                       @"diskette.png",
                       @"download.png",
                       @"drop.png",
                       @"easel.png",
                       @"film.png",
                       @"flag.png",
                       @"football.png",
                       @"graph.png",
                       @"home.png",
                       @"hotcup.png",
                       @"letter.png",
                       @"lifesaver.png",
                       @"lock.png",
                       @"love.png",
                       @"mail.png",
                       @"money.png",
                       @"monitor.png",
                       @"music.png",
                       @"news.png",
                       @"notes.png",
                       @"officephone.png",
                       @"openmail.png",
                       @"phone.png",
                       @"photo.png",
                       @"portfolio.png",
                       @"printer.png",
                       @"radio.png",
                       @"rain.png",
                       @"ribbon.png",
                       @"safe.png",
                       @"search.png",
                       @"setting.png",
                       @"shop.png",
                       @"speech.png",
                       @"statistic.png",
                       @"switch.png",
                       @"tablet.png",
                       @"ticket.png",
                       @"truck.png",
                       @"tv.png",
                       @"upload.png",
                       @"user.png",
                       @"user2.png",
                       @"view.png",
                       @"voicemail.png",
                       @"wallet.png",
                       @"weather.png",
                       @"worldglobe.png"
                       ] mutableCopy];
    }
    NSString *getIcon = [iconArray objectAtIndex:arc4random_uniform(iconArray.count)];
    [iconArray removeObject:getIcon];
    return getIcon;
}

-(UIColor *) getRdColor
{
    if (!colorArray) {
        
    colorArray = [@[[UIColor flatAlizarinColor],[UIColor flatAmethystColor],
                            [UIColor flatAsbestosColor],[UIColor flatBelizeHoleColor],
                            [UIColor flatCarrotColor],[UIColor flatPeterRiverColor],
                            [UIColor flatConcreteColor],[UIColor flatEmeraldColor],
                            [UIColor flatGreenSeaColor],[UIColor flatMidnightBlueColor],
                            [UIColor flatNephritisColor],[UIColor flatOrangeColor],
                            [UIColor flatPumpkinColor],
                            [UIColor flatSunFlowerColor],[UIColor flatTurquoiseColor],
                            [UIColor flatWetAsphaltColor],[UIColor flatWisteriaColor]] mutableCopy];
    }
    UIColor *getColor = [colorArray objectAtIndex:arc4random_uniform(colorArray.count)];
    [colorArray removeObject:getColor];
    return getColor;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectItemAtIndexPath");
    if (indexPath.row == curPack.setList.count) {
        [self addWordListToFullWordList];
        return;
    }
    isFirstLoad = NO;
    [self animateNavigationBarUp:YES];
    SetCollectionCell *cell = (SetCollectionCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
    SetInfoVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"setInfoView"];
    vc.curSet = cell.curSet;
    vc.curUserPack = self.curUserPack;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) addWordListToFullWordList
{
    fullWordList = [NSMutableArray new];
    for (LSet * set in curPack.setList) {
        [fullWordList addObjectsFromArray:set.wordList];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WordTestVC * view = [storyboard instantiateViewControllerWithIdentifier:@"wordTestView"];
    view.curPack = curPack;
    view.wordList = [fullWordList copy];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self presentViewController:view animated:YES completion:nil];
}


#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"isInDoubleRowAtIndexPath:%li = %@",(long)indexPath.row, [self isInDoubleRowAtIndexPath:indexPath]?@"YES":@"NO");
    if (indexPath.row == curPack.setList.count) {
        return CGSizeMake(collectionView.frame.size.width, 142);
    }
    
    if ([self isInDoubleRowAtIndexPath:indexPath]) {
        return CGSizeMake(collectionView.frame.size.width/2, 142);
    }
    else{
        return CGSizeMake(collectionView.frame.size.width, 142);
    }
    
}
-(BOOL) isInDoubleRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"is In Double Row At IndexPath");
    if (indexPath.row == curPack.setList.count) {
        return NO;
    }
    LSet *curSet = curPack.setList[indexPath.row];
    for(NSMutableArray * orderList in setOrderArray)
    {
        if ([orderList containsObject:curSet]) {
            NSLog(@"orderList = %@",orderList);
            if (orderList.count > 1) {
                return YES;
            }
            return NO;
        }
    }
    return NO;
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
#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)pushTransitionImageView
{
    SetCollectionCell *cell = (SetCollectionCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
    return cell.itemImage;
}

- (UIImageView *)popTransitionImageView
{
    return nil;
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isFirstLoad) {
        isFirstLoad = NO;
    }
}
#pragma mark - SetDisplayer
-(void)setDisplayerClicked:(SetDisplayer *)_setDisplayer
{
    if (_setDisplayer.isEnabled) {
        isDisplayerClicked = YES;
        //clickedSetDisplayer = _setDisplayer;
        
        if (!_setDisplayer.isFinalTest) {
            [self performSegueWithIdentifier:@"goSetDetail" sender:self];
        } else {
            [self retrieveAllSets];
        }
    } else {
        if ([curUserPack.purchaseType isEqualToString:@"try"]) {
            
        }
    }
    
}

-(void) retrieveAllSets
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    fullWordList = [NSMutableArray new];
    setLoadCount = 0;
    scoreLoadCount = 0;
    for (LSet *set in curPack.setList) {
        if (set.wordList.count > 0) {
            [self addWordListToFullWordList:set.wordList];
        }
        else
        {
            [set setDelegate:self];
            [set findId:set.modelId];
        }
    }
}
#pragma mark - Model Delegate
- (void)findIdSuccessful:(LSet *)model {
    [self addWordListToFullWordList:model.wordList];
}
-(void) addWordListToFullWordList:(NSArray *) wordList
{
    if (wordList) {
        [fullWordList addObjectsFromArray:wordList];
    }
    setLoadCount++;
    NSLog(@"setLoadCount = %i",setLoadCount);
    if (setLoadCount >= curPack.setList.count) {
        NSLog(@"direct view");
        /*WordTestVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"wordTestView"];
        view.curPack = curPack;
        view.wordList = [fullWordList copy];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self presentViewController:view animated:YES completion:nil];*/
    }
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    if ([model class] == [LSet class]) {
        [self addWordListToFullWordList:nil];
    }
    else if([model class] == [SetScore class])
    {
        [self handleScoreList:nil];
    }
}

- (void)getAllSucessfull:(AModel*)model List:(NSMutableArray *)allList {
    
    [self handleScoreList:allList];
    
}
-(void) handleScoreList:(NSMutableArray *)allList
{
    //NSLog(@"handleScoreList runs");
    if(allList)if(allList.count > 0)
    {
        [allList sortUsingComparator:^NSComparisonResult(SetScore * score1, SetScore * score2) {
            return (score1.score)>(score2.score);
        }];
        SetScore *finalScore = [allList lastObject];
        for (LSet *set in curPack.setList) {
            NSString *finalSetId = [NSString stringWithFormat:@"%@",finalScore.set_id];
            if ([set.modelId isEqualToString:finalSetId]) {
                set.score = finalScore;
                set.grade = finalScore.score;
            }
        }
    }
    scoreLoadCount++;
    
    if (scoreLoadCount >= curPack.setList.count) {
        NSLog(@"handleScoreList done");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self refreshTable];
    }
}

@end
