//
//  SetCollectionCell.m
//  academy
//
//  Created by Mac Mini on 7/8/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "SetCollectionCell.h"
#import "DataEngine.h"
#import <pop/POP.h>


@interface SetCollectionCell ()<POPAnimationDelegate>{
    CGFloat _progressLength;
    CGFloat _diameter;
    CGRect _solidFrame;
    
    BOOL isFirstLoad;
}

@end


@implementation SetCollectionCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}
-(void) initView
{
    [[NSBundle mainBundle] loadNibNamed:@"SetCollectionViewCell" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.layer.bounds = self.view.bounds;
    
    self.solidBG.layer.cornerRadius = 7;
    self.solidBGAnimation.layer.cornerRadius = self.solidBGAnimation.frame.size.width/2;
    
    self.solidBG.layer.opacity = 0.8f;
    self.solidBGAnimation.layer.opacity = 0.8f;
}

-(void) resetView
{
    self.solidBG.backgroundColor = self.solidColor;
    self.solidBGAnimation.backgroundColor = [UIColor clearColor];
    [self.itemLabel setText:self.curSet.name];
}

-(void) setAppearAfterDelay:(CGFloat) time
{
    self.solidBG.backgroundColor = [UIColor clearColor];
    self.solidBGAnimation.backgroundColor = self.solidColor;
    self.solidBGAnimation.layer.cornerRadius = 50;
    self.solidBGAnimation.transform = CGAffineTransformMakeScale(0,0);

    CGAffineTransform transformScale = CGAffineTransformMakeScale(0,0);
    self.itemImage.transform = transformScale;
    
    [self.itemLabel setText:self.curSet?self.curSet.name:@"Tổng Kết"];
    self.itemLabel.transform = CGAffineTransformMakeScale(0,0);
    
    [self performSelector:@selector(animateViewAppear) withObject:self afterDelay:time];
}
-(void) initAnimation
{
    self.userInteractionEnabled = NO;
    [self animateView:self.solidBGAnimation];
}

- (void) animateView:(UIView *) animView {
    
    _progressLength = self.bounds.size.width - 12;
    CGFloat height = self.bounds.size.height - 10;
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(self.solidBGAnimation.center.x - _progressLength/2,
                                                       self.solidBGAnimation.center.y - height/2,
                                                       _progressLength,
                                                       height)];
    anim.springBounciness = 3;
    anim.springSpeed = 0.01f;
    [anim setValue:@"stretchRound" forKey:@"animName"];
    anim.delegate = self;
    [animView.layer pop_addAnimation:anim forKey:@"stretchRound"];
    
    POPBasicAnimation *cornerRad = [POPBasicAnimation animation];
    POPAnimatableProperty *cornerRadius = [POPAnimatableProperty propertyWithName:@"layer.cornerRadius"
                                                                      initializer:^(POPMutableAnimatableProperty *prop) {
                                                                          // read value
                                                                          prop.readBlock = ^(id obj, CGFloat values[]) {
                                                                              values[0] = [obj cornerRadius];
                                                                          };
                                                                          // write value
                                                                          prop.writeBlock = ^(id obj, const CGFloat values[]) {
                                                                              [obj setCornerRadius:values[0]];
                                                                          };
                                                                          // dynamics threshold
                                                                          prop.threshold = 0.01;
                                                                      }];
    
    cornerRad.property = cornerRadius;
    cornerRad.duration = 0.8f;
    cornerRad.toValue = @(7);
    
    [animView.layer pop_addAnimation:cornerRad forKey:@"cornerRadius"];
}


- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    
    if (finished) {

    }
}

- (void) animateViewAppear
{
    self.itemImage.layer.position = CGPointMake(self.itemImage.layer.position.x, self.itemImage.layer.position.y +20);
    [UIView animateWithDuration:0.7f delay:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.solidBGAnimation.transform = CGAffineTransformMakeScale(1,1);
    } completion:^(BOOL finished) {
        [self animateView:self.solidBGAnimation];
    }];
    
    
    CGFloat height = self.bounds.size.height - 10;
    _progressLength = height + (self.bounds.size.width - height)/4;
    
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
    [animationBlocks addObject:^(BOOL finished){
        [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGAffineTransform transformScale = CGAffineTransformMakeScale(1.2,1.2);
            self.itemImage.transform = transformScale;
        } completion: getNextAnimation()];
    }];
    
    //block 2
    [animationBlocks addObject:^(BOOL finished){
        [UIView animateWithDuration:0.4f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGAffineTransform transformScale = CGAffineTransformMakeScale(1,1);
            self.itemImage.transform = transformScale;
        } completion: getNextAnimation()];
    }];
    
    //block 3
    [animationBlocks addObject:^(BOOL finished){
        [UIView animateWithDuration:0.4 delay:0.4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.itemImage.layer.position = CGPointMake(self.itemImage.layer.position.x, self.itemImage.layer.position.y -20);
            self.itemLabel.transform = CGAffineTransformMakeScale(1.2,1.2);
        } completion: getNextAnimation()];
    }];
    //block 4
    [animationBlocks addObject:^(BOOL finished){
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.itemLabel.transform = CGAffineTransformMakeScale(1,1);
            
        } completion: getNextAnimation()];
    }];
    //block 5
    [animationBlocks addObject:^(BOOL finished){
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

            
        } completion: getNextAnimation()];
    }];
    //block 6
    [animationBlocks addObject:^(BOOL finished){
        [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        } completion: getNextAnimation()];
    }];
    
    //add a block to our queue
    [animationBlocks addObject:^(BOOL finished){;
        
    }];
    
    // execute the first block in the queue
    getNextAnimation()(YES);
}

#pragma mark - UIScrollViewdelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isFirstLoad) {
        isFirstLoad = NO;
    }
}
@end
