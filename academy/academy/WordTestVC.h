//
//  WordTestVC.h
//  academy
//
//  Created by Brian on 5/22/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordDisplayView.h"
#import "CardTestView.h"
#import "WordInfoVC.h"
#import "Word.h"
#import "LSet.h"

@interface WordTestVC : WordDisplayView <CardTestViewDelegate>

@property (strong, nonatomic) LSet *curSet;

@property (strong, nonatomic) IBOutlet CardTestView *wordCard;
@property (strong, nonatomic) IBOutlet UILabel *wordNoLb;
@property (strong, nonatomic) IBOutlet UILabel *setTitleLb;

@property (strong, nonatomic) NSArray *wordList;
@property (strong, nonatomic) WordInfoVC *wordInfoView;
@end
