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
#import "AFNetworking.h"
#import "Package.h"

@interface UserShelfVC ()

@end

@implementation UserShelfVC {
    NSMutableArray *packageList;
    
    int cellInitHeight;
    NSIndexPath *curCellPath;
    int cellTopMargin;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    cellTopMargin = 10;
    cellInitHeight = screenWidth *3/10 +cellTopMargin;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    packageList = [NSMutableArray new];
    [self retrievePackages];
}
-(void) retrievePackages
{
    
    NSString *requestURL = @"http://academy.openlabproduction.com/api/package";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *packages = responseObject;
        for (NSDictionary * packageDict in packages) {
            Package* pack = [[Package alloc] initWithDict:packageDict];
            [packageList addObject:pack];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSUInteger statusCode = [operation.response statusCode];
        NSString *errorMessage = @"SceduleList Error";
        NSLog(@"statusCode = %u",statusCode);
        NSLog(@"error = %@",[error description]);
        switch (statusCode) {
            case 404:
                errorMessage = @"User was not found.";
                break;
            case 500:
                errorMessage = @"Internal Error";
                break;
            default:
                break;
        }
        NSLog(@"error = %@",errorMessage);
    }];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goSetList"])
    {
        Package *pack = [packageList objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        SetSelectVC * destination = segue.destinationViewController;
        [destination setTitle:pack.name];
        destination.curPack = pack;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}
- (IBAction)gotoShop:(id)sender {
    ShopNavVC * view = [self.storyboard instantiateViewControllerWithIdentifier:@"shopNavView"];
    [self presentViewController:view animated:YES completion:nil];
}

@end
