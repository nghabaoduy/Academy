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
#import "AFNetworking.h"
#import "Package.h"
#import "UserPackage.h"
#import "User.h"
#import "DataEngine.h"
#import "MSDynamicsDrawerViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserShelfVC () <ModelDelegate>

@end

@implementation UserShelfVC {
    NSMutableArray *packageList;
    
    int cellInitHeight;
    NSIndexPath *curCellPath;
    int cellTopMargin;
    UIRefreshControl * refeshControl;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //enable sideMenu Drag
    MSDynamicsDrawerViewController *dynamicsDrawerViewController = (MSDynamicsDrawerViewController *)self.navigationController.parentViewController;
    
    MSDynamicsDrawerDirectionActionForMaskedValues(dynamicsDrawerViewController.possibleDrawerDirection, ^(MSDynamicsDrawerDirection drawerDirection) {
        [dynamicsDrawerViewController setPaneDragRevealEnabled:YES forDirection:drawerDirection];
    });
    
    
    packageList = [NSMutableArray new];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    cellTopMargin = 10;
    cellInitHeight = screenWidth *3/10 +cellTopMargin;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(retrievePackages)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refeshControl];
    [[DataEngine getInstance] setIsForceReload:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    if ([[DataEngine getInstance] isForceReload]) {
        [self retrievePackages];
        [[DataEngine getInstance] setIsForceReload:NO];
    }
}

-(void) retrievePackages
{
    [refeshControl beginRefreshing];
    UserPackage * userPackage = [UserPackage new];
    [userPackage setDelegate:self];
    [userPackage getAllWithFilter:@{@"user_id" : [[User currentUser] modelId]}];
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
    
    UserPackage * curUserPackage = [packageList objectAtIndex:indexPath.row];;
    Package *pack = curUserPackage.package;
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellInitHeight;
}

- (void)reloadData
{
    // Reload table data
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}
#pragma mark - Model Delegate

- (void)getAllSucessfull:(AModel*)model List:(NSMutableArray *)allList {
    packageList = allList;
    [self reloadData];

}

- (void)model:(AModel *)model ErrorMessage:(id)error StatusCode:(NSNumber *)statusCode {
    NSLog(@"error %@", error);
    [self.refreshControl endRefreshing];

}

#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goSetList"])
    {
        UserPackage * userPack = [packageList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        SetSelectVC * destination = segue.destinationViewController;
        [destination setTitle:userPack.package.name];
        destination.curPack = userPack.package;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

@end
