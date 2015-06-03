//
//  MeaningPopupDisplayer.h
//  academy
//
//  Created by Brian on 6/3/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeaningPopupDisplayer : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
-(void) displayText:(NSString *) text atPos:(CGPoint) newPos;
-(void) fadeOut;
@end
