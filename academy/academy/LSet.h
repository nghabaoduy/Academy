//
//  LSet.h
//  academy
//
//  Created by Brian on 5/17/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AModel.h"
#import "SetScore.h"


@interface LSet : AModel

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * desc;
@property int orderNo;
@property (nonatomic, strong) NSString * package_id;

@property (nonatomic, retain) NSMutableArray * wordList;
@property (nonatomic, retain) NSNumber * grade;
@property (nonatomic, retain) SetScore * score;
@property (nonatomic, retain) NSString * imgURL;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * dummyImgName;

@property (nonatomic, retain) UIColor * solidColor;
@end
