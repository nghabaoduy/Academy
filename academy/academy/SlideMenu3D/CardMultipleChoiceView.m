//
//  CardMultipleChoiceView.m
//  academy
//
//  Created by Brian on 5/24/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "CardMultipleChoiceView.h"

@implementation CardMultipleChoiceView{
    
    IBOutlet UITextView *questionTV;
    IBOutlet UIButton *choice1Btn;
    IBOutlet UIButton *choice2Btn;
    IBOutlet UIButton *choice3Btn;
    IBOutlet UIButton *choice4Btn;
    IBOutlet UILabel *questionLb;
    IBOutlet UIImageView *questionImg;
    
    NSArray *btnList;
}

@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

-(void) initView
{
    [[NSBundle mainBundle] loadNibNamed:@"CardTestMultipleChoice" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    
    choice1Btn.titleLabel.numberOfLines = 2;
    choice1Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    choice1Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    choice2Btn.titleLabel.numberOfLines = 2;
    choice2Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    choice2Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    choice3Btn.titleLabel.numberOfLines = 2;
    choice3Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    choice3Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    choice4Btn.titleLabel.numberOfLines = 2;
    choice4Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    choice4Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)clearDisplay
{
    [self hideAllComponent];
    [questionTV setText:@""];
    [choice1Btn setTitle:@"" forState:UIControlStateNormal];
    [choice2Btn setTitle:@"" forState:UIControlStateNormal];
    [choice3Btn setTitle:@"" forState:UIControlStateNormal];
    [choice4Btn setTitle:@"" forState:UIControlStateNormal];
}
-(void) hideAllComponent
{
    NSArray *objectList = @[questionLb, questionTV, choice1Btn, choice2Btn, choice3Btn, choice4Btn];
    for (UIView * view in objectList) {
        view.hidden = YES;
    }
    [questionImg setHidden:YES];
}
//========== Display Info ============//

-(void) displayMessage:(NSString *) message
{
    [self clearDisplay];
    NSArray *objectList = @[questionTV];
    for (UIView * view in objectList) {
        view.hidden = NO;
    }
    
    
    [questionTV setText:message];
}

-(void)displayMultipleChoiceQuestion:(NSString *) question
                             choice1:(NSString *) choice1
                             choice2:(NSString *) choice2
                             choice3:(NSString *) choice3
                             choice4:(NSString *) choice4
{
    // remove mute bracket
    question = [question stringByReplacingOccurrencesOfString:@"{" withString:@""];
    question = [question stringByReplacingOccurrencesOfString:@"}" withString:@""];
    
    [self clearDisplay];
    NSArray *objectList = @[questionLb, questionTV, choice1Btn, choice2Btn, choice3Btn, choice4Btn];
    for (UIView * view in objectList) {
        view.hidden = NO;
    }
    
    [questionTV setText:question];
    [choice1Btn setTitle:choice1 forState:UIControlStateNormal];
    [choice2Btn setTitle:choice2 forState:UIControlStateNormal];
    [choice3Btn setTitle:choice3 forState:UIControlStateNormal];
    [choice4Btn setTitle:choice4 forState:UIControlStateNormal];
    
    btnList = @[choice1Btn,choice2Btn,choice3Btn,choice4Btn];
    for (UIButton * choice in btnList) {
        [choice setBackgroundImage:[UIImage imageNamed:@"medium-blue-btn.png"] forState:UIControlStateNormal];
    }
}
-(void)displayMultipleChoiceImgQuestion:(NSString *) imgLink
                             choice1:(NSString *) choice1
                             choice2:(NSString *) choice2
                             choice3:(NSString *) choice3
                             choice4:(NSString *) choice4
{
    [self clearDisplay];
    NSArray *objectList = @[questionLb, questionTV, choice1Btn, choice2Btn, choice3Btn, choice4Btn];
    for (UIView * view in objectList) {
        view.hidden = NO;
    }
    [questionImg setHidden:NO];
    [questionImg setImage:[UIImage imageNamed:imgLink]];
    [choice1Btn setTitle:choice1 forState:UIControlStateNormal];
    [choice2Btn setTitle:choice2 forState:UIControlStateNormal];
    [choice3Btn setTitle:choice3 forState:UIControlStateNormal];
    [choice4Btn setTitle:choice4 forState:UIControlStateNormal];
    
    btnList = @[choice1Btn,choice2Btn,choice3Btn,choice4Btn];
    for (UIButton * choice in btnList) {
        [choice setBackgroundImage:[UIImage imageNamed:@"medium-blue-btn.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)choiceClicked:(UIButton *)choiceBtn {
    [delegate CardMultipleChoiceView:self choiceSelect:choiceBtn.titleLabel.text];
}

-(void) displayCorrectChoice:(NSString *) correctAnswer wrongChoice:(NSString *) wrongAnswer
{
    for (UIButton * choice in btnList) {
        if ([choice.titleLabel.text isEqual:correctAnswer]) {
            [choice setBackgroundImage:[UIImage imageNamed:@"medium-green-btn.png"] forState:UIControlStateNormal];
        }
        if ([choice.titleLabel.text isEqual:wrongAnswer]) {
            [choice setBackgroundImage:[UIImage imageNamed:@"medium-red-btn.png"] forState:UIControlStateNormal];
        }
    }
}

@end
