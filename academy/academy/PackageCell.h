//
//  PackageCell.h
//  academy
//
//  Created by Brian on 5/15/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PackageCell;
@protocol PackageCellDelegate <NSObject>
- (void)packageCellPurchaseBtnClicked:(PackageCell *) cell;
@end

@interface PackageCell : UITableViewCell
@property (nonatomic, weak) id <PackageCellDelegate> packageCellDelegate;

@property (strong, nonatomic) IBOutlet UIImageView *packageImg;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLb;
@property (strong, nonatomic) IBOutlet UILabel *priceLb;
@property (strong, nonatomic) IBOutlet UILabel *packTitle;
@property (strong, nonatomic) IBOutlet UILabel *packSubTitle;
@property (strong, nonatomic) IBOutlet UIImageView *rankImg;
@property (weak, nonatomic) IBOutlet UIButton *purchaseBtn;


@end
