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
#import "TOMSMorphingLabel.h"
@interface WordInfoVC : WordDisplayView <CardInfoViewDelegate>

@property (strong, nonatomic) LSet *curSet;

@property (strong, nonatomic) IBOutlet CardInfoView *wordCard;
@property (strong, nonatomic) IBOutlet TOMSMorphingLabel *wordNoLb;
@property (strong, nonatomic) IBOutlet TOMSMorphingLabel *setTitleLb;
@property (nonatomic, strong) NSString * language;
@property BOOL isWordCheckSession;

@end
