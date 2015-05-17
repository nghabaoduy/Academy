//
//  ShopVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ShopVC.h"
#import "PackageCell.h"
#import "UserShelfNavVC.h"
#import "AFNetworking.h"
#import "Package.h"

@interface ShopVC () <ModelDelegate>

@end

@implementation ShopVC {
    NSArray *tempArray;
    NSMutableArray *packageList;
    int cellInitHeight;
    NSIndexPath *curCellPath;
    int expansionHeight;
    int cellTopMargin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    packageList = [NSMutableArray new];
    tempArray = [NSArray arrayWithObjects:@"Basic", @"Intermediate", @"Advanced",nil];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    cellTopMargin = 10;
    cellInitHeight = screenWidth *3/10 +cellTopMargin;
    expansionHeight = screenWidth *3/10 *160/200 + cellTopMargin;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self retrievePackages];
}

-(void) retrievePackages {
    //Init new package just to find (i cant do static one)
    Package * toRetrivePackages = [Package new];
    //Assign Deleteage
    toRetrivePackages.delegate = self;
    //Call the function
    [toRetrivePackages getAllWithFilter:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return packageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"packCell" forIndexPath:indexPath];
    Package *pack = [packageList objectAtIndex:indexPath.row];
    [cell.textLabel setHidden:YES];
    [cell.packTitle setText:pack.name];
    [cell.packSubTitle setText:[NSString stringWithFormat:@"%i Words",pack.wordsTotal]];
    [cell.priceLb setText:pack.price];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curCellPath!=nil) {
        if (curCellPath.section == indexPath.section && curCellPath.row == indexPath.row) {
            return;
        }
        [self tableView:tableView minimizeCurCellAndExpandCellAtIndex:indexPath];
    }
    else
    {
        [self tableView:tableView expandCellAtIndex:indexPath];
    }
    
    
}

- (void)tableView:(UITableView *)tableView minimizeCurCellAndExpandCellAtIndex:(NSIndexPath *)indexPath
{
    [UIView animateWithDuration:0.2 animations:^{
        // move down cells which are below selected one
        for (UITableViewCell *cell in tableView.visibleCells) {
            NSIndexPath *cellIndexPath = [tableView indexPathForCell:cell];
            
            if (cellIndexPath.row > curCellPath.row) {
                CGRect frame = cell.frame;
                frame.origin.y -= expansionHeight;
                cell.frame = frame;
            }
        }
        // expand selected cell
        PackageCell *cell = (PackageCell *)[tableView cellForRowAtIndexPath:curCellPath];
        
        CGRect frame = cell.frame;
        frame.size.height -= expansionHeight;
        cell.frame = frame;
    } completion:^(BOOL finished) {
        [self tableView:tableView expandCellAtIndex:indexPath];
    }];
}
- (void)tableView:(UITableView *)tableView expandCellAtIndex:(NSIndexPath *)indexPath
{
    curCellPath = indexPath;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        for (UITableViewCell *cell in tableView.visibleCells) {
            NSIndexPath *cellIndexPath = [tableView indexPathForCell:cell];
            
            if (cellIndexPath.row > indexPath.row) {
                CGRect frame = cell.frame;
                frame.origin.y += expansionHeight;
                cell.frame = frame;
            }
        }
        // expand selected cell
        PackageCell *cell = (PackageCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        CGRect frame = cell.frame;
        frame.size.height += expansionHeight;
        cell.frame = frame;
    } completion:^(BOOL finished) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (curCellPath != nil)
        if (curCellPath.section == indexPath.section && curCellPath.row == indexPath.row) {
            return cellInitHeight+expansionHeight;
        }
    return cellInitHeight;
}
#pragma mark - Package
- (void)getAllSucessfull:(NSMutableArray *)allList {
    packageList = allList;
    [self.tableView reloadData];
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    
}

#pragma mark - Navigation
/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}
- (IBAction)gotoShelf:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
