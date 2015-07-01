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
    
    [[UINavigationBar appearance] setBarTintColor:barTintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"GothamRounded-Bold" size:20.0], NSFontAttributeName,
                                                            nil]];
    

    //CGFloat verticalOffset = 4;
    //[[UINavigationBar appearance] setTitleVerticalPositionAdjustment:verticalOffset forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];

    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont fontWithName:@"GothamRounded-Book" size:16.0], NSFontAttributeName,
                                                          nil]
                                                forState:UIControlStateNormal];
    
    
    
}

@end
