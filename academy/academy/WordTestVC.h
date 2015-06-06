//
//  WordTestVC.h
//  academy
//
//  Created by Brian on 5/22/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordDisplayView.h"
#import "cardMultipleChoiceView.h"
#import "CardTypeAnswerView.h"
#import "WordInfoVC.h"
#import "Word.h"
#import "LSet.h"
#import "TestMaker.h"
#import "AlertTestModePickView.h"

@interface WordTestVC : WordDisplayView <CardMultipleChoiceViewDelegate, CardTypeAnswerViewDelegate, TestMakerDelegate, TestPickDelegate>

@property (strong, nonatomic) LSet *curSet;

@property (strong, nonatomic) IBOutlet CardMultipleChoiceView *cardMultipleChoice;
@property (strong, nonatomic) IBOutlet CardTypeAnswerView *cardTypeAnswer;
@property (strong, nonatomic) IBOutlet UILabel *wordNoLb;
@property (strong, nonatomic) IBOutlet UILabel *setTitleLb;

@property (strong, nonatomic) NSArray *wordList;
@property (strong, nonatomic) WordInfoVC *wordInfoView;

-(void) restartTest;
@end
