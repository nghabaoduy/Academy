//
//  PackageDetailVC.m
//  academy
//
//  Created by Mac Mini on 6/30/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "PackageDetailVC.h"
#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"
#import "TOMSMorphingLabel.h"
#import "CardInfoView.h"
@interface PackageDetailVC () <YSLTransitionAnimatorDataSource>

@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;

@end

@implementation PackageDetailVC{
    
    __weak IBOutlet TOMSMorphingLabel *packageNameLb;
    __weak IBOutlet TOMSMorphingLabel *subTitleLb;
    __weak IBOutlet UIButton *buyBtn;
    __weak IBOutlet UIButton *tryBtn;
    __weak IBOutlet UIView *infoSection;
    __weak IBOutlet TOMSMorphingLabel *priceLb;
    __weak IBOutlet TOMSMorphingLabel *viewCountLb;
    __weak IBOutlet TOMSMorphingLabel *downloadCountLb;
    __weak IBOutlet UIButton *backBtn;
    __weak IBOutlet UILabel *descTitleLb;
    __weak IBOutlet UITextView *descContentTV;
    __weak IBOutlet CardInfoView *cardInfo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController setNavigationBarHidden:NO];
    [self ysl_removeTransitionDelegate];
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
    [UIView animateWithDuration:0.17 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backBtn.transform = CGAffineTransformMakeTranslation(-30, 0);
    } completion:^(BOOL finished){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupInitView];
    CGRect rect = [UIScreen mainScreen].bounds;
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    // header
    // If you're using a xib and storyboard. Be sure to specify the frame
    _headerImageView.frame = CGRectMake(0, statusHeight, rect.size.width, rect.size.width * 17.0/32);
    
    // custom navigation left item
    __weak PackageDetailVC *weakself = self;
    [self ysl_setUpReturnBtnWithColor:[UIColor lightGrayColor]
                      callBackHandler:^{
                          [weakself.navigationController popViewControllerAnimated:YES];
                      }];
}
#pragma mark -- Appear Animation
- (void) setupInitView
{
    [self clearAnimatedLabel:packageNameLb];
    [self clearAnimatedLabel:subTitleLb];
    [self clearAnimatedLabel:priceLb];
    [self clearAnimatedLabel:viewCountLb];
    [self clearAnimatedLabel:downloadCountLb];
    
    buyBtn.transform = CGAffineTransformMakeScale(0,0);
    tryBtn.transform = CGAffineTransformMakeScale(0,0);
    infoSection.transform = CGAffineTransformMakeScale(1,0);
    
    infoSection.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    infoSection.layer.shadowOffset = CGSizeMake(0, 3);
    infoSection.layer.shadowOpacity = .3;
    infoSection.layer.shadowRadius = 5.0;
    
    backBtn.transform = CGAffineTransformMakeTranslation(50, 0);
    descTitleLb.alpha = 0;
    descContentTV.alpha = 0;
    
    descTitleLb.transform = CGAffineTransformMakeTranslation(0, -10);
    descContentTV.transform = CGAffineTransformMakeTranslation(0, 20);
    cardInfo.alpha = 0;
    cardInfo.transform = CGAffineTransformMakeTranslation(0, 50);
}
-(void) clearAnimatedLabel:(TOMSMorphingLabel *) animatedLabel
{
    [animatedLabel setMorphingEnabled:NO];
    animatedLabel.text = @"";
    [animatedLabel setMorphingEnabled:YES];
    [animatedLabel setAnimationDuration:0.2];
}
- (void) animateViewAppear
{
    [packageNameLb setText:@"IETLS TOEFL Basic" withCompletionBlock:^{
        [subTitleLb setText:@"100 words" withCompletionBlock:^{
            [viewCountLb setText:@"520"];
            [downloadCountLb setText:@"158" withCompletionBlock:^{
                [priceLb setText:@"FREE"];
            }];
        }];
    }];
    
    
    
    
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
            buyBtn.transform = CGAffineTransformMakeScale(1.2,1.2);
            infoSection.transform = CGAffineTransformMakeScale(1,1);
            backBtn.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion: getNextAnimation()];
    }];
    
    //block 2
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            buyBtn.transform = CGAffineTransformMakeScale(1,1);
            tryBtn.transform = CGAffineTransformMakeScale(1.2,1.2);
        } completion: getNextAnimation()];
    }];
    
    //block 3
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            tryBtn.transform = CGAffineTransformMakeScale(1,1);
            
        } completion: getNextAnimation()];
    }];
    //block 4
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            descTitleLb.transform = CGAffineTransformMakeTranslation(0, 0);
            descTitleLb.alpha = 1;
            
        } completion: getNextAnimation()];
    }];
    //block 5
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            descContentTV.alpha = 1;
            descContentTV.transform = CGAffineTransformMakeTranslation(0, 0);
            
        } completion: getNextAnimation()];
    }];
    //block 6
    [animationBlocks addObject:^(BOOL finished){;
        [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cardInfo.alpha = 1;
            cardInfo.transform = CGAffineTransformMakeTranslation(0, 0);
            
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

@end
