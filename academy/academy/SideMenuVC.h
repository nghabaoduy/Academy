//
//  SideMenuVC.h
//  academy
//
//  Created by Brian on 5/16/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"
typedef NS_ENUM(NSUInteger, MSPaneViewControllerType) {
    ControllerLogin,
    ControllerMenuList,
    ControllerTypeCount
};

@interface SideMenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) MSPaneViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType;
@end
