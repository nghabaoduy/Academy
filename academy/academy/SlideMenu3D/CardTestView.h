//
//  CardTestView.h
//  academy
//
//  Created by Brian on 5/22/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardTestViewDelegate

-(void) choiceSelect:(NSString *) choice;

@end

@interface CardTestView : UIView
{
    id <CardTestViewDelegate> delegate;
}
@property (retain) id delegate;
@property (strong, nonatomic) IBOutlet UIView *view;


-(void) displayMessage:(NSString *) message;
-(void)displayMultipleChoiceQuestion:(NSString *) question
                             choice1:(NSString *) choice1
                             choice2:(NSString *) choice2
                             choice3:(NSString *) choice3
                             choice4:(NSString *) choice4;
-(void)clearDisplay;
@end
