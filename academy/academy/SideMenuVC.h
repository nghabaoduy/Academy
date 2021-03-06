//
//  SideMenuVC.h
//  academy
//
//  Created by Brian on 5/16/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MSDynamicsDrawerViewController.h"
#import "FRDLivelyButton.h"

typedef NS_ENUM(NSUInteger, MSPaneViewControllerType) {
    ControllerAppInit,
    ControllerLogin,
    ControllerUserShelf,
    ControllerShop,
    ControllerProfile,
    ControllerSetting,
    ControllerTypeCount
};

@interface SideMenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

+ (id)getInstance;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) MSPaneViewControllerType paneViewControllerType;
@property (nonatomic, weak) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

@property (nonatomic, strong) FRDLivelyButton *paneRevealLeftBarButtonItem;
@property (nonatomic, strong) FRDLivelyButton *paneRevealRightBarButtonItem;

- (void)transitionToViewController:(MSPaneViewControllerType)paneViewControllerType animated:(BOOL) animated;
- (void)dynamicsDrawerRevealLeftBarButtonItemTapped:(id)sender;
@end
