//
//  UserShelfVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "UserShelfVC.h"
#import "SetSelectVC.h"
#import "PackageCell.h"
#import "ShopNavVC.h"

@interface UserShelfVC ()

@end

@implementation UserShelfVC {
    NSArray *tempArray;
    
    int cellInitHeight;
    NSIndexPath *curCellPath;
    int cellTopMargin;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    tempArray = [NSArray arrayWithObjects:@"Basic", @"Intermediate", @"Advanced",nil];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    cellTopMargin = 10;
    cellInitHeight = screenWidth *3/10 +cellTopMargin;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tempArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"packCell" forIndexPath:indexPath];
    
    [cell.textLabel setHidden:YES];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellInitHeight;
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
    return YES;
}
- (IBAction)gotoShop:(id)sender {
    ShopNavVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"shopNavView"];
    [self presentViewController:view animated:YES completion:nil];
}

@end
