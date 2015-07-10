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
#import "Word.h"
#import "User.h"
#import "PackageTryBuyStatus.h"
#import "SoundEngine.h"
#import "SideMenuVC.h"
#import <pop/POP.h>
@interface PackageDetailVC () <YSLTransitionAnimatorDataSource, CardInfoViewDelegate, AuthDelegate>

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
    
    BOOL isBack;
}
@synthesize curPack;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [backBtn setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    descTitleLb.alpha = 0;
    descContentTV.alpha = 0;
    [descContentTV setText:curPack.desc];
    [self resizeTextViewToFit:descContentTV];
    
    descTitleLb.transform = CGAffineTransformMakeTranslation(0, -10);
    descContentTV.transform = CGAffineTransformMakeTranslation(0, 20);
    cardInfo.alpha = 0;
    cardInfo.transform = CGAffineTransformMakeTranslation(0, 50);
    cardInfo.delegate = self;
    [self displayCard];
}

-(void) displayCard
{
    NSArray *words = [curPack getWordsFromPackageWithQuantity:1];
    if (words) {
        Word *word = [words firstObject];
        NSLog(@"word = %@",word);
        [cardInfo displayWord:word.name wordType:word.wordType phonetic:word.phonentic detailContent:[word getMeaning:curPack.language bExample:YES] wordSubDict:[word getWordSubDict:curPack.language]];
    }
}

-(void) resizeTextViewToFit:(UITextView *) tv
{
    CGFloat fixedWidth = tv.frame.size.width;
    CGSize newSize = [tv sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = tv.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    tv.frame = newFrame;
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
    
    PackageTryBuyStatus * status = (PackageTryBuyStatus*)[PackageTryBuyStatus getModelById:curPack.modelId from:[DataEngine getInstance].packStatusList];
    [packageNameLb setText:curPack.name withCompletionBlock:^{
        [subTitleLb setText:[NSString stringWithFormat:@"%i Từ Vựng",curPack.wordsTotal] withCompletionBlock:^{
            [viewCountLb setText:[NSString stringWithFormat:@"%i",status.tryCount]];
            [downloadCountLb setText:[NSString stringWithFormat:@"%i",status.buyCount] withCompletionBlock:^{
                if ([curPack.price intValue] == 0) {
                    [priceLb setText:@"FREE"];
                }
                else
                {
                    NSNumberFormatter *formatter = [NSNumberFormatter new];
                    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
                    
                    NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[curPack.price integerValue]]];
                    formatted = [formatted stringByReplacingOccurrencesOfString:@"," withString:@"."];
                    [priceLb setText:[NSString stringWithFormat:@"%@ đ",formatted]];
                }
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
#pragma mark -- CardInfoDelegate
-(NSString *)CardInfoViewGetLanguage
{
    return curPack.language;
}
-(void)cardIsTapped:(CardInfoView *)card
{
    POPSpringAnimation *anim;
    if ((anim = [card.layer pop_animationForKey:@"cardShake"])) {
        return;
    }
    [[SoundEngine getInstance] readWord:card.wordLb.text language:curPack.language];
    POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    shake.springBounciness = 20;
    shake.velocity = @(3000);
    [card.layer pop_addAnimation:shake forKey:@"cardShake"];
    
    
}
- (IBAction)buy:(id)sender {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user purchasePackage: curPack];
}
- (IBAction)try:(id)sender {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user tryPackage: curPack];
}
- (IBAction)getFree:(id)sender {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    User * user = [User currentUser];
    [user setAuthDelegate:self];
    [user purchasePackage: curPack];
    
}

#pragma mark - Auth delegate
- (void)userPurchasePackageSucessful:(User *)user {
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"purchase successful");
    isBack  = NO;
    [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:YES];
}

- (void)userPurchasePackageFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode {
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([[NSString stringWithFormat:@"%@",[error valueForKey:@"message"]] isEqualToString:@"Insufficient credit to purchase"]) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Thông Báo" message:@"Số dư tài khoản không đủ mua bộ ngôn ngữ này. Cập nhập phiên bản mới nhất để mua bộ ngôn ngữ này." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * dismiss = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             NSString *iTunesLink = [[DataEngine getInstance] getAppURL];
                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                                                         }];
        
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    NSLog(@"purchase failed %@", error);
}

- (void)userTryPackageSucessful:(User *)user {
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"try successful");
    isBack  = NO;
    [[SideMenuVC getInstance] transitionToViewController:ControllerUserShelf animated:YES];
}

- (void)userTryPackageFailed:(User *)user WithError:(id)error StatusCode:(NSNumber *)statusCode {
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"try failed %@", error);
}

@end
