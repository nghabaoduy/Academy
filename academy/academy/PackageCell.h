//
//  PackageCell.h
//  academy
//
//  Created by Brian on 5/15/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *packageImg;
@property (strong, nonatomic) IBOutlet UILabel *priceLb;
@property (strong, nonatomic) IBOutlet UIImageView *packageInfoBG;
@property (strong, nonatomic) IBOutlet UITextView *contentTV;
@property (strong, nonatomic) IBOutlet UIButton *tryBtn;
@property (strong, nonatomic) IBOutlet UIButton *buyBtn;
@property (strong, nonatomic) IBOutlet UILabel *packTitle;
@property (strong, nonatomic) IBOutlet UILabel *packSubTitle;


@end
