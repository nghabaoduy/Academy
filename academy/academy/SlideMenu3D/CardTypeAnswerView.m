//
//  CardTypeAnswerView.m
//  academy
//
//  Created by Brian on 5/24/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "CardTypeAnswerView.h"
#import "SoundEngine.h"
@implementation CardTypeAnswerView
{
    IBOutlet UITextView *questionTV;
    IBOutlet UITextField *answerTF;
    IBOutlet UIButton *checkBtn;
    IBOutlet UIImageView *checkCrossHolder;
    IBOutlet UILabel *correctAnswerLb;
    IBOutlet UIImageView *questionImg;
    IBOutlet UIButton *speakerBtn;
    NSString *speakerWord;
    
}
@synthesize delegate;


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CardTypeAnswer" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CardTypeAnswer" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    return self;
}

-(void)displayQuestion:(NSString *) question
{
    [self clearDisplay];
    [questionTV setText:question];
    
}
-(void)displayImgQuestion:(NSString *) imgLink
{
    [self clearDisplay];
    [questionImg setHidden:NO];
    [questionImg setImage:[UIImage imageNamed:imgLink]];
    
}
-(void) displayWordSpeaker:(NSString *) word
{
    [self clearDisplay];
    [speakerBtn setHidden:NO];
    speakerWord = word;
    [[SoundEngine getInstance] readWord:word];
}
- (IBAction)speakerClicked:(id)sender {
    [[SoundEngine getInstance] readWord:speakerWord];
}
- (IBAction)checkAnswer:(id)sender {
    [checkBtn setEnabled:NO];
    [delegate CardTypeAnswerView:self checkAnswer:answerTF.text];
}

-(void) clearDisplay
{
    [checkBtn setEnabled:YES];
    questionTV.text = @"";
    answerTF.text = @"";
    checkCrossHolder.hidden = YES;
    correctAnswerLb.text = @"";
    [questionImg setHidden:YES];
    [speakerBtn setHidden:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [delegate CardTypeAnswerView:self textfieldStartEditing:textField];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [delegate CardTypeAnswerView:self textfieldEndEditing:textField];
}
-(void)dismissKeyboard {
    [answerTF resignFirstResponder];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void) displayCorrectChoice:(NSString *) correctAnswer isCorrect:(BOOL) isCorrect
{
    checkCrossHolder.hidden = NO;
    if (isCorrect) {
        [checkCrossHolder setImage:[UIImage imageNamed:@"tick.png"]];
    }
    else{
        [correctAnswerLb setText:correctAnswer];
        [checkCrossHolder setImage:[UIImage imageNamed:@"cross.png"]];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
