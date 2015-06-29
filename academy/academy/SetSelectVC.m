//
//  SetSelectVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetSelectVC.h"
#import "SetDetailVC.h"
#import "LSet.h"
#import "WordTestVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "User.h"

@interface SetSelectVC ()

@end

@implementation SetSelectVC{
    NSMutableArray *setOrderArray;
    NSArray *tempArray;
    SetDisplayer *clickedSetDisplayer;
    BOOL isDisplayerClicked;
    
    int scoreLoadCount;
    int setLoadCount;
    NSMutableArray * fullWordList;
    
    int maxUnlock;
    int curUnlock;
    NSMutableArray *curUnlockList;
    
    Package * curPack;
}

@synthesize curUserPack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    curPack = curUserPack.package;
    
    maxUnlock = 2;
    self.tableView.allowsSelection = NO;
    setOrderArray = [NSMutableArray new];
    
    for (LSet *set in curPack.setList) {
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
}
-(void)loadSetScore
{
    setLoadCount = 0;
    scoreLoadCount = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    for (LSet *set in curPack.setList) {
        SetScore * newsScore = [SetScore new];
        newsScore.delegate = self;
        newsScore.set_id = set.modelId;
        [newsScore getAllWithFilter:@{@"user_id" : [[User currentUser] modelId]}];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshTable];
    if ([curUserPack.purchaseType isEqualToString:@"buy"]) {
        [self loadSetScore];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void) refreshTable
{
    curUnlock = 0;
    curUnlockList = [NSMutableArray new];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!curPack) {
        return 0;
    }
    return setOrderArray.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //final row
    if (indexPath.row == setOrderArray.count) {
        SetRow1Displayer *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell1Displayer" forIndexPath:indexPath];
        cell.setDisplayer.delegate = self;
        [cell.setDisplayer setFinalTest:curPack];
        
        [self isAllSetIsRanked]? [cell.setDisplayer enableDisplayer]: [cell.setDisplayer disableDisplayer];
        if([[[User currentUser] role] isEqualToString:@"admin"] || [[[User currentUser] role] isEqualToString:@"tester"])
        {
            [cell.setDisplayer enableDisplayer];
        }
        return cell;
    }
    //other
    NSMutableArray * orderList = setOrderArray[indexPath.row];
    if (orderList.count == 1) {
        SetRow1Displayer *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell1Displayer" forIndexPath:indexPath];
        cell.setDisplayer.delegate = self;
        LSet *set = orderList[0];
        [cell.setDisplayer setLSet:set];
        [self checkUnlockSetDisplayer:cell.setDisplayer];
        return cell;
    }
    else
    {
        SetRow2Displayer *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell2Displayer" forIndexPath:indexPath];
        cell.setDisplayer1.delegate = self;
        LSet *set = orderList[0];
        [cell.setDisplayer1 setLSet:set];
        [self checkUnlockSetDisplayer:cell.setDisplayer1];
        
        cell.setDisplayer2.delegate = self;
        LSet *set2 = orderList[1];
        [cell.setDisplayer2 setLSet:set2];
        [self checkUnlockSetDisplayer:cell.setDisplayer2];
        return cell;
    }
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goSetDetail"])
    {
        if (!clickedSetDisplayer.isFinalTest) {
            LSet *set = [clickedSetDisplayer getLSet];
            SetDetailVC * destination = segue.destinationViewController;
            [destination setTitle:set.name];
            destination.curSet = set;
            destination.curUserPack = curUserPack;
        }
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return isDisplayerClicked;
}

#pragma mark - SetDisplayer
-(void)setDisplayerClicked:(SetDisplayer *)_setDisplayer
{
    if (_setDisplayer.isEnabled) {
        isDisplayerClicked = YES;
        clickedSetDisplayer = _setDisplayer;
        
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
        WordTestVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"wordTestView"];
        view.curPack = curPack;
        view.wordList = [fullWordList copy];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self presentViewController:view animated:YES completion:nil];
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
