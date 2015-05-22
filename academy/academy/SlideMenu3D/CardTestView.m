//
//  CardTestView.m
//  academy
//
//  Created by Brian on 5/22/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "CardTestView.h"

@implementation CardTestView{
    
    IBOutlet UITextView *questionTV;
    IBOutlet UIButton *choice1Btn;
    IBOutlet UIButton *choice2Btn;
    IBOutlet UIButton *choice3Btn;
    IBOutlet UIButton *choice4Btn;
    IBOutlet UILabel *questionLb;
}

@synthesize delegate;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CardTest" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CardTest" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
    }
    return self;
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
}

- (IBAction)choiceClicked:(UIButton *)choiceBtn {
    [delegate choiceSelect:choiceBtn.titleLabel.text];
}
@end
