//
//  PackageInfoVC.m
//  academy
//
//  Created by Brian on 5/18/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//
#import <MBProgressHUD/MBProgressHUD.h>
#import "PackageInfoVC.h"
#import "User.h"
#import "SideMenuVC.h"
#import "UIImageView+AFNetworking.h"

@interface PackageInfoVC () <AuthDelegate>

@end

@implementation PackageInfoVC
@synthesize curPack, topPriceLb, oldPriceLb, topSubTitleLb,topTitleLb,contentTv, packageImg;
@synthesize buyBtn,freeBtn,tryBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayInfo];
}
-(void) displayInfo
{
    [freeBtn setHidden:YES];
    
    if ([curPack.oldPrice intValue] == 0) {
        [oldPriceLb setText:@""];
    }
    else
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[curPack.oldPrice integerValue]]];
        formatted = [formatted stringByReplacingOccurrencesOfString:@"," withString:@"."];
        [oldPriceLb setText:[NSString stringWithFormat:@"%@ đ",formatted]];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:oldPriceLb.attributedText];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@1
                                range:NSMakeRange(0, [attributeString length])];
        [oldPriceLb setAttributedText:attributeString];
    }
    
    if ([curPack.price intValue] == 0) {
        [topPriceLb setText:@"FREE"];
    }
    else
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[curPack.price integerValue]]];
        formatted = [formatted stringByReplacingOccurrencesOfString:@"," withString:@"."];
        [topPriceLb setText:[NSString stringWithFormat:@"%@ đ",formatted]];
    }
    [topTitleLb setText:curPack.name];
    [packageImg setImageWithURL:[NSURL URLWithString:curPack.imgURL] placeholderImage:[UIImage imageNamed:@"dummyBanner.png"]];
    [topSubTitleLb setText:[NSString stringWithFormat:@"%i Words",curPack.wordsTotal]];
    [contentTv setText:curPack.desc];
    
    if ([curPack.price intValue] == 0) {
        [buyBtn setHidden:YES];
        [tryBtn setHidden:YES];
        [freeBtn setHidden:NO];
    } else {
        [buyBtn setHidden:NO];
        [tryBtn setHidden:NO];
        [freeBtn setHidden:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)buy:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user purchasePackage: curPack];
}
- (IBAction)try:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user tryPackage: curPack];
}
- (IBAction)getFree:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user purchasePackage: curPack];
    
}

#pragma mark - Auth delegate
- (void)userPurchasePackageSucessful:(User *)user {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"purchase successful");
    [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:YES];
}

- (void)userPurchasePackageFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([[NSString stringWithFormat:@"%@",[error valueForKey:@"message"]] isEqualToString:@"Insufficient credit to purchase"]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Số dư tài khoản không đủ mua bộ ngôn ngữ này. Cập nhập phiên bản mới nhất để mua bộ ngôn ngữ này." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             NSString *iTunesLink = [[DataEngine getInstance] getAppURL];
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSLog(@"purchase failed %@", error);
}

- (void)userTryPackageSucessful:(User *)user {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"try successful");
    [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:YES];
}

- (void)userTryPackageFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"try failed %@", error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
