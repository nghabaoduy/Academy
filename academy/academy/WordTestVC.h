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
#import "UserPackage.h"
#import "TestMaker.h"
#import "AlertTestModePickView.h"

@interface WordTestVC : WordDisplayView <CardMultipleChoiceViewDelegate, CardTypeAnswerViewDelegate, TestMakerDelegate, TestPickDelegate>

@property (strong, nonatomic) Package *curPack;
@property (strong, nonatomic) LSet *curSet;
@property (strong, nonatomic) UserPackage * curUserPack;
@property (strong, nonatomic) IBOutlet CardMultipleChoiceView *cardMultipleChoice;
@property (strong, nonatomic) IBOutlet CardTypeAnswerView *cardTypeAnswer;
@property (strong, nonatomic) IBOutlet TOMSMorphingLabel *wordNoLb;
@property (strong, nonatomic) IBOutlet TOMSMorphingLabel *setTitleLb;

@property (strong, nonatomic) NSArray *wordList;
@property (strong, nonatomic) WordInfoVC *wordInfoView;

-(void) restartTest;
@end
