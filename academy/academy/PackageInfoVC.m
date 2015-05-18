//
//  PackageInfoVC.m
//  academy
//
//  Created by Brian on 5/18/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "PackageInfoVC.h"

@interface PackageInfoVC ()

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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)buy:(id)sender {
}
- (IBAction)try:(id)sender {
}
- (IBAction)getFree:(id)sender {
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
