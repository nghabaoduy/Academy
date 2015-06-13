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
    
    int curMaxUnlocked;
}

@synthesize curPack;

- (void)viewDidLoad {
    [super viewDidLoad];
    curMaxUnlocked = 0;
    
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
        [self loadSetScore];
    }
}
-(void)loadSetScore
{
    scoreLoadCount = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    SetScore * newsScore = [SetScore new];
    for (LSet *set in curPack.setList) {
        newsScore.delegate = self;
        newsScore.set_id = set.modelId;
        [newsScore getAllWithFilter:@{@"user_id" : [[User currentUser] modelId]}];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for (LSet *set in curPack.setList) {
        if (set.grade > 0) if(set.orderNo>=curMaxUnlocked){
            curMaxUnlocked = set.orderNo+1;
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

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
        
        NSMutableArray * orderList = [setOrderArray lastObject];
        LSet *set = [orderList lastObject];
        set.orderNo < curMaxUnlocked? [cell.setDisplayer enableDisplayer]: [cell.setDisplayer disableDisplayer];
        return cell;
    }
    //other
    NSMutableArray * orderList = setOrderArray[indexPath.row];
    NSLog(@"curMaxUnlocked = %i",curMaxUnlocked);
    if (orderList.count == 1) {
        SetRow1Displayer *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell1Displayer" forIndexPath:indexPath];
        cell.setDisplayer.delegate = self;
        LSet *set = orderList[0];
        [cell.setDisplayer setLSet:set];
        set.orderNo <= curMaxUnlocked? [cell.setDisplayer enableDisplayer]: [cell.setDisplayer disableDisplayer];
        
        return cell;
    }
    else
    {
        SetRow2Displayer *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell2Displayer" forIndexPath:indexPath];
        cell.setDisplayer1.delegate = self;
        LSet *set = orderList[0];
        [cell.setDisplayer1 setLSet:set];
        set.orderNo <= curMaxUnlocked? [cell.setDisplayer1 enableDisplayer]: [cell.setDisplayer1 disableDisplayer];
        
        cell.setDisplayer2.delegate = self;
        LSet *set2 = orderList[1];
        [cell.setDisplayer2 setLSet:set2];
        set2.orderNo <= curMaxUnlocked? [cell.setDisplayer2 enableDisplayer]: [cell.setDisplayer2 disableDisplayer];
        
        return cell;
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
    isDisplayerClicked = YES;
    clickedSetDisplayer = _setDisplayer;
    
    if (!_setDisplayer.isFinalTest) {
        [self performSegueWithIdentifier:@"goSetDetail" sender:self];
    }
    else
    {
        [self retrieveAllSets];
    }
}

-(void) retrieveAllSets
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    fullWordList = [NSMutableArray new];
    setLoadCount = 0;
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
    if (setLoadCount >= curPack.setList.count) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        WordTestVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"wordTestView"];
        view.curPack = curPack;
        view.wordList = [fullWordList copy];
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
    if(allList)if(allList.count > 0)
    {
        NSLog(@"Get score successfull = %@",allList);
        [allList sortUsingComparator:^NSComparisonResult(SetScore * score1, SetScore * score2) {
            return (score1.score)>(score2.score);
        }];
        SetScore *finalScore = [allList lastObject];
        for (LSet *set in curPack.setList) {
            NSString *finalSetId = [NSString stringWithFormat:@"%@",finalScore.set_id];
            if ([set.modelId isEqualToString:finalSetId]) {
                set.score = finalScore;
                set.grade = finalScore.score;
                if (set.grade > 0) if(set.orderNo>=curMaxUnlocked){
                    curMaxUnlocked = set.orderNo+1;
                }
            }
        }
    }
    
    scoreLoadCount++;
     if (scoreLoadCount >= curPack.setList.count) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [self.tableView reloadData];
     }
}

@end
