//
//  CardTypeAnswerView.h
//  academy
//
//  Created by Brian on 5/24/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardTypeAnswerView;

@protocol CardTypeAnswerViewDelegate

-(void) CardTypeAnswerView:(CardTypeAnswerView *) cardView checkAnswer:(NSString *) answer;
-(void) CardTypeAnswerView:(CardTypeAnswerView *) cardView textfieldStartEditing:(UITextField *)textfield;
-(void) CardTypeAnswerView:(CardTypeAnswerView *) cardView textfieldEndEditing:(UITextField *)textfield;
-(NSString *) CardTypeAnswerViewGetLanguage;
@end

@interface CardTypeAnswerView : UIView <UITextFieldDelegate>
{
    id <CardTypeAnswerViewDelegate> delegate;
}
@property (retain) id delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) NSString *language;
-(void)displayQuestion:(NSString *) question;
-(void)displayImgQuestion:(NSString *) imgLink;
-(void) displayWordSpeaker:(NSString *) word;
-(void)clearDisplay;
-(void)dismissKeyboard;
-(void) displayCorrectChoice:(NSString *) correctAnswer isCorrect:(BOOL) isCorrect;

@end
