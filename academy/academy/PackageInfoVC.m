//
//  PackageInfoVC.m
//  academy
//
//  Created by Brian on 5/18/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "PackageInfoVC.h"
#import "User.h"

@interface PackageInfoVC () <AuthDelegate>

@end

@implementation PackageInfoVC
@synthesize curPack, topPriceLb, topSubTitleLb,topTitleLb,contentTv;
@synthesize buyBtn,freeBtn,tryBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayInfo];
}
-(void) displayInfo
{
    [freeBtn setHidden:YES];
    [topPriceLb setText:curPack.price];
    [topTitleLb setText:curPack.name];
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
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user purchasePackage: curPack];
}
- (IBAction)try:(id)sender {
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user tryPackage: curPack];
}
- (IBAction)getFree:(id)sender {
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user purchasePackage: curPack];
    
}

#pragma mark - Auth delegate
- (void)userPurchasePackageSucessful:(User *)user {
    NSLog(@"purchase successful");
}

- (void)userPurchasePackageFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode {
    NSLog(@"purchase failed %@", error);
}

- (void)userTryPackageSucessful:(User *)user {
    NSLog(@"try successful");
}

- (void)userTryPackageFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode {
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
