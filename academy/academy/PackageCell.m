//
//  PackageCell.m
//  academy
//
//  Created by Brian on 5/15/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "PackageCell.h"

@implementation PackageCell
@synthesize packageCellDelegate;
- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)try:(id)sender {
    NSLog(@"try package");
}
- (IBAction)buy:(id)sender {
    NSLog(@"buy package");
    [packageCellDelegate packageCellPurchaseBtnClicked:self];
}

@end
