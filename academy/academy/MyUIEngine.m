//
//  MyUIEngine.m
//  academy
//
//  Created by Brian on 5/22/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "MyUIEngine.h"

@implementation MyUIEngine

+ (id)sharedUIEngine {
    static MyUIEngine *sharedUIEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUIEngine = [[self alloc] init];
    });
    return sharedUIEngine;
}

- (id)init {
    if (self = [super init]) {

    }
    return self;
}


- (void) appDelegateUICustomzation {
    
    
    UIColor *barTintColor = UIColorFromRGB(0x0ea3f7);
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    /*
    if ([UINavigationBar instancesRespondToSelector:@selector(setBackIndicatorImage:)]) {
        [[UINavigationBar appearance] setBackIndicatorImage:[[UIImage alloc] init]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage alloc] init]];
    }*/
    
    [[UINavigationBar appearance] setBarTintColor:barTintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"GothamRounded-Bold" size:20.0], NSFontAttributeName,
                                                            nil]];

    CGFloat verticalOffset = 4;
    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];

    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"GothamRounded-Book" size:16.0], NSFontAttributeName,
                                                          nil]
                                                forState:UIControlStateNormal];
    
    
    
}

+(void) popButton:(UIView *) button
{
    button.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.1 animations:^{
        button.transform = CGAffineTransformMakeScale(1.3, 1.3);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.45
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             button.transform = CGAffineTransformMakeScale(1, 1);
                         }completion:nil];
    }];
}
+(void) popAppearButton:(UIView *) button
{
    button.transform = CGAffineTransformMakeScale(0, 0);
    [MyUIEngine popAppearButton:button withDelay:0];
}
+(void) popAppearButton:(UIView *) button withDelay:(CGFloat) delay
{
    button.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.5
                          delay:delay
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(1, 1);
                     }completion:nil];
}
+(void) popDisappearButton:(UIView *) button
{
    //button.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
    }];
}
+(void) fadeOutButton:(UIView *) button
{
    [MyUIEngine fadeOutButton:button withDelay:0];
}
+(void) fadeOutButton:(UIView *) button withDelay:(CGFloat) delay
{
    
    [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.layer.opacity = 0;
    } completion:^(BOOL finished) {
    }];
}
+(void) fadeInButton:(UIView *) button
{
    [MyUIEngine fadeInButton:button withDelay:0];
}
+(void) fadeInButton:(UIView *) button withDelay:(CGFloat) delay
{
    button.layer.opacity = 0;
    [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        button.layer.opacity = 1;
    } completion:^(BOOL finished) {
    }];
}
@end
