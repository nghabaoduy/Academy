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
    ControllerUserShelf,
    ControllerShop,
    ControllerTypeCount
};

@interface SideMenuVC : UITableViewController
@property (nonatomic, assign) MSPaneViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType;
@end
