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


@interface SetSelectVC ()

@end

@implementation SetSelectVC{
    NSMutableArray *setOrderArray;
    NSArray *tempArray;
    SetDisplayer *clickedSetDisplayer;
    BOOL isDisplayerClicked;
    
    int setLoadCount;
    NSMutableArray * fullWordList;
    
}

@synthesize curPack;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
        
        return cell;
    }
    //other
    NSMutableArray * orderList = setOrderArray[indexPath.row];
    
    if (orderList.count == 1) {
        SetRow1Displayer *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell1Displayer" forIndexPath:indexPath];
        cell.setDisplayer.delegate = self;
        LSet *set = orderList[0];
        [cell.setDisplayer setLSet:set];
        
        return cell;
    }
    else
    {
        SetRow2Displayer *cell = [tableView dequeueReusableCellWithIdentifier:@"setCell2Displayer" forIndexPath:indexPath];
        cell.setDisplayer1.delegate = self;
        LSet *set = orderList[0];
        [cell.setDisplayer1 setLSet:set];
        
        cell.setDisplayer2.delegate = self;
        LSet *set2 = orderList[1];
        [cell.setDisplayer2 setLSet:set2];
        
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
    [self addWordListToFullWordList:nil];
}


@end
