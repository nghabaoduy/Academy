//
//  SideMenuVC.m
//  FoodOrder
//
//  Created by Brian on 5/20/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//


#import "SideMenuVC.h"
#import "LoginVC.h"
#import "SideMenuCell.h"
#import "SideMenuHeader.h"
#import "UserShelfVC.h"
#import "ShopVC.h"

NSString * const MenuCellReuseIdentifier = @"menuCell";
NSString * const MenuHeaderReuseIdentifier = @"menuHeader";

typedef NS_ENUM(NSUInteger, MSMenuViewControllerTableViewSectionType) {
    MSMenuViewControllerTableViewSectionTypeOptions,
    MSMenuViewControllerTableViewSectionTypeExamples,
    MSMenuViewControllerTableViewSectionTypeAbout,
    MSMenuViewControllerTableViewSectionTypeCount
};

@interface SideMenuVC ()

@property (nonatomic, strong) NSDictionary *paneViewControllerTitles;
#if defined(STORYBOARD)
@property (nonatomic, strong) NSDictionary *paneViewControllerIdentifiers;
#else
@property (nonatomic, strong) NSDictionary *paneViewControllerClasses;
#endif
@property (nonatomic, strong) NSDictionary *sectionTitles;
@property (nonatomic, strong) NSArray *tableViewSectionBreaks;

@property (nonatomic, strong) UIBarButtonItem *paneStateBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealLeftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *paneRevealRightBarButtonItem;

@property (nonatomic, strong) NSArray *menuIconList;
@property (nonatomic, strong) NSArray *menuTitleList;
@property (nonatomic, strong) NSArray *menuNavList;
@property (nonatomic, strong) NSArray *menuHeaderTitle;

@end


@implementation SideMenuVC

static SideMenuVC * instance = nil;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (instance) {
        return instance;
    }
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    instance = self ;
    return instance;
}
+ (id)getInstance{
    return instance;
}
#pragma mark - UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (instance) {
        return instance;
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    instance = self;
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[SideMenuCell class] forCellReuseIdentifier:MenuCellReuseIdentifier];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MSMenuViewController

- (void)initialize
{
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerTitles = @{
                                      @(ControllerLogin) : @"Login",
                                      @(ControllerUserShelf) : @"Shelf",
                                      @(ControllerShop) : @"Shop"
                                      };
#if !defined(STORYBOARD)
    self.paneViewControllerClasses = @{
                                       @(ControllerLogin) : [LoginVC class],
                                       @(ControllerUserShelf) : [UserShelfVC class],
                                        @(ControllerShop) : [ShopVC Class]
                                       };
#else
    self.paneViewControllerIdentifiers = @{
                                           @(ControllerLogin) : @"loginView",
                                           @(ControllerUserShelf) : @"userShelfView",
                                            @(ControllerShop) : @"shopView"
                                           };
#endif
    self.sectionTitles = @{
                           
                           };
    
    self.tableViewSectionBreaks = @[
                                    
                                    ];
    
    self.menuIconList = @[
                          @"book.png",
                          @"shop.png",
                          @"wallet.png",
                          @"user.png",
                          @"config.png"
                          ];
    self.menuTitleList = @[
                           @"Shelf",
                           @"Store",
                           @"Top Up",
                           @"Privacy",
                           @"Setting",
                           @"Log out"
                           ];
    
    self.menuHeaderTitle = @[@"Menu"];
}

- (MSPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath *)indexPath
{
    /*MSPaneViewControllerType paneViewControllerType;
    if (indexPath.section == 0) {
        paneViewControllerType = indexPath.row;
    } else {
        paneViewControllerType = ([self.tableViewSectionBreaks[(indexPath.section - 1)] integerValue] + indexPath.row);
    }*/
    switch (indexPath.row) {
        case 0:
            return ControllerUserShelf;
            break;
        case 1:
            return ControllerShop;
            
        default:
            break;
    }
    return ControllerUserShelf;
    //NSAssert(paneViewControllerType < MSPaneViewControllerTypeCount, @"Invalid Index Path");
    //return paneViewControllerType;
}

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType
{
    // Close pane if already displaying the pane view controller
    if (paneViewControllerType == self.paneViewControllerType) {
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:YES allowUserInterruption:YES completion:nil];
        return;
    }
    
    BOOL animateTransition = self.dynamicsDrawerViewController.paneViewController != nil;
    
#if defined(STORYBOARD)
    UIViewController *paneViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
#else
    Class paneViewControllerClass = self.paneViewControllerClasses[@(paneViewControllerType)];
    UIViewController *paneViewController = (UIViewController *)[paneViewControllerClass new];
#endif
    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
    
    if (paneViewControllerType != ControllerLogin) {
        self.paneRevealLeftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(dynamicsDrawerRevealLeftBarButtonItemTapped:)];
        paneViewController.navigationItem.leftBarButtonItem = self.paneRevealLeftBarButtonItem;
    }
    
    
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [self.dynamicsDrawerViewController setPaneViewController:paneNavigationViewController animated:animateTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender
{
    NSLog(@"dynamicsDrawerRevealLeftBarButtonItemTapped called");
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:nil];
}

- (void)dynamicsDrawerRevealRightBarButtonItemTapped:(id)sender
{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionRight animated:YES allowUserInterruption:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.menuHeaderTitle.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.menuTitleList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SideMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuCellReuseIdentifier];
    
    cell.titleLb.text = [self.menuTitleList objectAtIndex:indexPath.row];
    if (indexPath.row <= self.menuIconList.count -1) {
        [cell.icon setImage:[UIImage imageNamed:[self.menuIconList objectAtIndex:indexPath.row]]];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SideMenuHeader *headerView = [[SideMenuHeader alloc] init];
    headerView.titleLb.text = [self.menuHeaderTitle objectAtIndex:section];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MSPaneViewControllerType paneViewControllerType = [self paneViewControllerTypeForIndexPath:indexPath];
    [self transitionToViewController:paneViewControllerType];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
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
