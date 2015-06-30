//
//  PackageDetailVC.m
//  academy
//
//  Created by Mac Mini on 6/30/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "PackageDetailVC.h"
#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"

@interface PackageDetailVC () <YSLTransitionAnimatorDataSource>

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;

@end

@implementation PackageDetailVC

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self ysl_removeTransitionDelegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self ysl_addTransitionDelegate:self];
    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
                                    cancelAnimationPointY:0
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
}
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    // header
    // If you're using a xib and storyboard. Be sure to specify the frame
    _headerImageView.frame = CGRectMake(0, statusHeight + navigationHeight, rect.size.width, 250);
    
    // custom navigation left item
    __weak PackageDetailVC *weakself = self;
    [self ysl_setUpReturnBtnWithColor:[UIColor lightGrayColor]
                      callBackHandler:^{
                          [weakself.navigationController popViewControllerAnimated:YES];
                      }];
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)popTransitionImageView
{
    return self.headerImageView;
}

- (UIImageView *)pushTransitionImageView
{
    return nil;
}

@end
