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
    
    NSArray *imgList = @[@"banner_1.png",@"banner_2.png",@"banner_3.png",@"banner_4.png",@"banner_5.png"];
    [cell.packageImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgList[arc4random_uniform(imgList.count)]]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
