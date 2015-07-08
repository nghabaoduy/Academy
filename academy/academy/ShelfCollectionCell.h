//
//  ShelfCollectionCell.h
//  academy
//
//  Created by Mac Mini on 6/30/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPackage.h"
#define IMAGE_HEIGHT 200
#define IMAGE_OFFSET_SPEED 25

@interface ShelfCollectionCell : UICollectionViewCell

/*
 
 image used in the cell which will be having the parallax effect
 
 */

@property (nonatomic, strong, readwrite) UIImageView *MJImageView;
@property (nonatomic, strong, readwrite) UIImage *image;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic, strong, readwrite) UIView *imageContainer;
@property (weak, nonatomic) IBOutlet UIView *imageContainerHolder;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *viewCountLb;
@property (weak, nonatomic) IBOutlet UILabel *downloadCountLb;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;

/*
 Image will always animate according to the imageOffset provided. Higher the value means higher offset for the image
 */
@property (nonatomic, assign, readwrite) CGPoint imageOffset;

-(void) setCellWithPackage:(Package *) pack;
@end

