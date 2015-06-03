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


@interface SetSelectVC ()

@end

@implementation SetSelectVC{
    NSMutableArray *setOrderArray;
    NSArray *tempArray;
    LSet *clickedSet;
    BOOL isDisplayerClicked;
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
    return setOrderArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 142;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
         LSet *set = clickedSet;
        SetDetailVC * destination = segue.destinationViewController;
        [destination setTitle:set.name];
        destination.curSet = set;
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
    clickedSet = [_setDisplayer getLSet];
    [self performSegueWithIdentifier:@"goSetDetail" sender:self];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
