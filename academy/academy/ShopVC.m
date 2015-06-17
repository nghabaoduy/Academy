//
//  ShopVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ShopVC.h"
#import "PackageCell.h"
#import "AFNetworking.h"
#import "Package.h"
#import "PackageInfoVC.h"
#import "UIImageView+AFNetworking.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "ShelfHeader.h"

@interface ShopVC () <ModelDelegate>

@end

@implementation ShopVC {
    NSArray *tempArray;
    NSMutableArray *packageList;
    int cellInitHeight;
    NSIndexPath *curCellPath;
    int expansionHeight;
    int cellTopMargin;
    
    NSMutableArray * packageLangList;
    NSMutableArray * languageList;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //Init new package just to find (i cant do static one)
    Package * toRetrivePackages = [Package new];
    //Assign Deleteage
    toRetrivePackages.delegate = self;
    //Call the function
    [toRetrivePackages getAllWithFilter:nil];
}
-(void) organizePackageList
{
    packageLangList = [NSMutableArray new];
    languageList = [NSMutableArray new];
    
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
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return languageList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *langArr = packageLangList[section];
    return langArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"packCell" forIndexPath:indexPath];
    
    NSMutableArray *langArr = packageLangList[indexPath.section];
    Package *pack = [langArr objectAtIndex:indexPath.row];
    [cell.textLabel setHidden:YES];
    [cell.packTitle setText:pack.name];
    [cell.packSubTitle setText:[NSString stringWithFormat:@"%i Words",pack.wordsTotal]];
    
    if ([pack.price intValue] == 0) {
        [cell.priceLb setText:@"FREE"];
    }
    else
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[pack.price integerValue]]];
        formatted = [formatted stringByReplacingOccurrencesOfString:@"," withString:@"."];
        [cell.priceLb setText:[NSString stringWithFormat:@"%@ đ",formatted]];
    }
    
    if (pack.imgURL)
        [cell.packageImg setImageWithURL:[NSURL URLWithString:pack.imgURL] placeholderImage:[UIImage imageNamed:@"dummyBanner.png"]];
    else
        [cell.packageImg setImage:[UIImage imageNamed:@"dummyBanner.png"]];
    
    return cell;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShelfHeader *headerView = [[ShelfHeader alloc] init];
    NSString * lang = [languageList objectAtIndex:section];
    lang = [NSString stringWithFormat:@"%@%@",[[lang substringToIndex:1] uppercaseString], [lang substringFromIndex:1]];
    headerView.titleLb.text = lang;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellInitHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
#pragma mark - Package

- (void)getAllSucessfull:(AModel*)model List:(NSMutableArray *)allList {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    packageList = allList;
    [self organizePackageList];
}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"goPackInfo"])
     {
         Package * pack = [packageList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
         PackageInfoVC * destination = segue.destinationViewController;
         [destination setTitle:pack.name];
         destination.curPack = pack;
     }
 }


@end
