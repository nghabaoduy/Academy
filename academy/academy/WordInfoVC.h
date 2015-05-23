//
//  WordInfoVC.h
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordDisplayView.h"
#import "CardInfoView.h"
#import "Word.h"
#import "LSet.h"
@interface WordInfoVC : WordDisplayView <CardInfoViewDelegate>

@property (strong, nonatomic) LSet *curSet;

@property (strong, nonatomic) IBOutlet CardInfoView *wordCard;
@property (strong, nonatomic) IBOutlet UILabel *wordNoLb;
@property (strong, nonatomic) IBOutlet UILabel *setTitleLb;

@property BOOL isWordCheckSession;

@end
