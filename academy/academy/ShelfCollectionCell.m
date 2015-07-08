//
//  ShelfCollectionCell.m
//  academy
//
//  Created by Mac Mini on 6/30/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "ShelfCollectionCell.h"
#import "DataEngine.h"
#import "PackageTryBuyStatus.h"
@interface ShelfCollectionCell()



@end

@implementation ShelfCollectionCell

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
    [[NSBundle mainBundle] loadNibNamed:@"ShelfCellView" owner:self options:nil];
    self.bounds = self.view.bounds;
    [self addSubview:self.view];
    //self.layer.anchorPoint = CGPointMake(0.5, 0);
    self.layer.bounds = self.view.bounds;
    
    [self setupImageView];
    UIFont *smallInfoFont = [UIFont fontWithName:@"GothamRounded-Book" size:[UIFont systemFontSize]];
    [self.viewCountLb setFont:smallInfoFont];
    [self.downloadCountLb setFont:smallInfoFont];
    [self.priceLb setFont:smallInfoFont];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - Setup Method
- (void)setupImageView
{
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat cellHeight = (630.0f/1242) * screenWidth;
    CGFloat scaleRatio = screenWidth/1242.0;
    int containerMargin = 20 * scaleRatio;
    int containerBottomSpace = 51 * cellHeight/self.bounds.size.height;
    // Clip subviews
    self.imageContainer = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x + containerMargin,
                                             self.bounds.origin.y + containerMargin,
                                             screenWidth - containerMargin*2,
                                             cellHeight - containerMargin - containerBottomSpace)];

    [self.imageContainerHolder addSubview:self.imageContainer];
    [self.imageContainerHolder setBackgroundColor:[UIColor clearColor]];
    self.imageContainer.clipsToBounds = YES;
    [self.imageContainer.layer setCornerRadius:3];
    
    // Add image subview
    self.MJImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageContainer.bounds.origin.x, self.imageContainer.bounds.origin.y, self.imageContainer.bounds.size.width,  self.imageContainer.bounds.size.height*1.2)];
    self.MJImageView.backgroundColor = [UIColor redColor];
    self.MJImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.MJImageView.clipsToBounds = NO;
    [self.imageContainer addSubview:self.MJImageView];
    self.MJImageView.userInteractionEnabled = NO;
    
}

# pragma mark - Setters

- (void)setImage:(UIImage *)image
{
    // Store image
    self.MJImageView.image = image;
    
    // Update padding
    [self setImageOffset:self.imageOffset];
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    // Store padding value
    _imageOffset = imageOffset;
    
    // Grow image view
    CGRect frame = self.MJImageView.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.MJImageView.frame = offsetFrame;
}

-(void) setCellWithPackage:(Package *) pack
{
    [self.titleLb setText:pack.name];
    [self.subTitleLb setText:[NSString stringWithFormat:@"%i Từ Vựng",pack.wordsTotal]];
    
    
    PackageTryBuyStatus * status = (PackageTryBuyStatus*)[PackageTryBuyStatus getModelById:pack.modelId from:[DataEngine getInstance].packStatusList];
    if (status) {
        self.viewCountLb.text = [NSString stringWithFormat:@"%i",status.tryCount];
        self.downloadCountLb.text = [NSString stringWithFormat:@"%i",status.buyCount];
    }
    
    if ([pack.price intValue] == 0) {
        [self.priceLb setText:@" FREE"];
    }
    else
    {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[pack.price integerValue]]];
        formatted = [formatted stringByReplacingOccurrencesOfString:@"," withString:@"."];
        [self.priceLb setText:[NSString stringWithFormat:@" %@ đ",formatted]];
    }
    
    
    if ([pack.oldPrice intValue] != 0) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:[pack.oldPrice integerValue]]];
        formatted = [formatted stringByReplacingOccurrencesOfString:@"," withString:@"."];

        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ đ",formatted]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@1
                                range:NSMakeRange(0, [attributeString length])];
        [attributeString addAttribute:NSForegroundColorAttributeName
                                value:[UIColor lightGrayColor]
                                range:NSMakeRange(0, [attributeString length])];
        
        [attributeString insertAttributedString:self.priceLb.attributedText atIndex:attributeString.length];
        [self.priceLb setAttributedText:attributeString];
    }
    
}

@end
