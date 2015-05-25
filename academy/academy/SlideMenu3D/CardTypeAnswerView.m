//
//  CardTypeAnswerView.m
//  academy
//
//  Created by Brian on 5/24/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "CardTypeAnswerView.h"

@implementation CardTypeAnswerView
{
    IBOutlet UITextView *questionTV;
    IBOutlet UITextField *answerTF;
    IBOutlet UIButton *checkBtn;
    
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
- (IBAction)checkAnswer:(id)sender {
    [delegate CardTypeAnswerView:self checkAnswer:answerTF.text];
}
-(void) clearDisplay
{
    questionTV.text = @"";
    answerTF.text = @"";
}
-(void)dismissKeyboard {
    [answerTF resignFirstResponder];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
