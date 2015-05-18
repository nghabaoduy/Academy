//
//  PackageInfoVC.h
//  academy
//
//  Created by Brian on 5/18/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Package.h"

@interface PackageInfoVC : UIViewController

@property (nonatomic, strong) Package *curPack;

@property (strong, nonatomic) IBOutlet UIImageView *packageImg;
@property (strong, nonatomic) IBOutlet UILabel *topPriceLb;
@property (strong, nonatomic) IBOutlet UILabel *topTitleLb;
@property (strong, nonatomic) IBOutlet UILabel *topSubTitleLb;
@property (strong, nonatomic) IBOutlet UITextView *contentTv;
@property (strong, nonatomic) IBOutlet UIButton *tryBtn;
@property (strong, nonatomic) IBOutlet UIButton *buyBtn;
@property (strong, nonatomic) IBOutlet UIButton *freeBtn;


@end
