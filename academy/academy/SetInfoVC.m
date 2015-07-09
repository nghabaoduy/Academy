//
//  SetInfoVC.m
//  academy
//
//  Created by Mac Mini on 7/8/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetInfoVC.h"

#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"
#import "TOMSMorphingLabel.h"
#import "UIButton+Extensions.h"

@interface SetInfoVC ()<YSLTransitionAnimatorDataSource>

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIView *solidBG;
@property (weak, nonatomic) IBOutlet TOMSMorphingLabel *titleLb;

@end

@implementation SetInfoVC{
    
    BOOL isBack;
    __weak IBOutlet UIButton *backBtn;
}


- (void)viewWillDisappear:(BOOL)animated
{
    if (isBack) {
        [self.navigationController setNavigationBarHidden:NO];
        [self ysl_removeTransitionDelegate];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [self ysl_addTransitionDelegate:self];
    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
                                    cancelAnimationPointY:0
                                        animationDuration:0.3
                                  isInteractiveTransition:YES];
    //[self performSelector:@selector(animateViewAppear) withObject:self afterDelay:0.2];
    [self animateViewAppear];
}

- (IBAction)backClicked:(id)sender {
    isBack = YES;
    [UIView animateWithDuration:0.17 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backBtn.transform = CGAffineTransformMakeTranslation(-40, 0);
    } completion:^(BOOL finished){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitView];
}

#pragma mark -- Appear Animation
- (void) setupInitView
{
    _headerImageView.frame = CGRectMake(self.view.frame.size.width/2 - 128/2, 40, 128, 128);
    self.solidBG.layer.opacity = 0.8f;
    self.solidBG.backgroundColor = self.curSet.solidColor;
    
    backBtn.transform = CGAffineTransformMakeTranslation(50, 0);
    backBtn.layer.opacity = 0;
    [backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    
    [self.titleLb setTextWithoutMorphing:self.curUserPack.package.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) animateViewAppear
{
    [self.titleLb setText:self.curSet.name];
    
    
    NSMutableArray* animationBlocks = [NSMutableArray new];
    
    typedef void(^animationBlock)(BOOL);
    
    // getNextAnimation
    // removes the first block in the queue and returns it
    animationBlock (^getNextAnimation)() = ^{
        animationBlock block = animationBlocks.count ? (animationBlock)[animationBlocks objectAtIndex:0] : nil;
        if (block){
            [animationBlocks removeObjectAtIndex:0];
            return block;
        }else{
            return ^(BOOL finished){};
        }
    };
    
    //block 1
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            backBtn.transform = CGAffineTransformMakeTranslation(0, 0);
            backBtn.layer.opacity = 1.0f;
            
        } completion: getNextAnimation()];
    }];
    
    //block 2
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        } completion: getNextAnimation()];
    }];
    
    //block 3
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion: getNextAnimation()];
    }];
    //block 4
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion: getNextAnimation()];
    }];
    //block 5
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion: getNextAnimation()];
    }];
    //block 6
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion: getNextAnimation()];
    }];
    
    //add a block to our queue
    [animationBlocks addObject:^(BOOL finished){;
        
    }];
    
    // execute the first block in the queue
    getNextAnimation()(YES);
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)popTransitionImageView
{
    return self.headerImageView;
}

- (UIImageView *)pushTransitionImageView
{
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
