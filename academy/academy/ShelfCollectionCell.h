//
//  ShelfCollectionCell.h
//  academy
//
//  Created by Mac Mini on 6/30/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IMAGE_HEIGHT 100
#define IMAGE_OFFSET_SPEED 25

@interface ShelfCollectionCell : UICollectionViewCell

/*
 
 image used in the cell which will be having the parallax effect
 
 */

@property (nonatomic, strong, readwrite) UIImageView *MJImageView;
@property (nonatomic, strong, readwrite) UIImage *image;

/*
 Image will always animate according to the imageOffset provided. Higher the value means higher offset for the image
 */
@property (nonatomic, assign, readwrite) CGPoint imageOffset;

@end

