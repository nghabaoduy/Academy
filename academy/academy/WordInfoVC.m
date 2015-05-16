//
//  WordInfoVC.m
//  academy
//
//  Created by Brian on 5/14/15.
//  Copyright (c) 2015 Openlabproduction. All rights reserved.
//

#import "WordInfoVC.h"

@interface WordInfoVC ()

@end


@implementation WordInfoVC{
    NSArray *wordList;
    int curWordNo;
    BOOL isFront;
}

@synthesize wordCard = _wordCard;
@synthesize wordNoLb = _wordNoLb;
@synthesize curSet;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    _wordCard.delegate = self;
    _wordCard.view.bounds = _wordCard.bounds;
    
    wordList = curSet.wordList;
   /*wordList = @[@[@"abash",@"v",@"ə'bæ∫t",@"to make embarrassed or ashamed",@"Làm bối rối, làm lúng túng, làm luống cuống"],
                @[@"aboriginal",@"a",@",æbə'ridʒənl",@"original",@"(thuộc) thổ dân; (thuộc) thổ sản, (thuộc) đặc sản"],
                @[@"eradicate",@"v",@"i'rædikeit",@"get rid of pull up by the roots",@"Nhổ rễ"],
                 @[@"surcharge",@"v",@"´sə:¸tʃa:dʒ",@"additional load/charge",@"Phần chất thêm, số lượng chất thêm (quá tải)\nSố tiền tính thêm, tiền trả thêm\nThuế phạt (phạt kẻ khai man số tài sản phải chịu thuế)"],
                @[@"trickle",@"n",@"trikəl",@"flow in drops",@"Dòng chảy nhỏ giọt (nước)"],
                @[@"intrepid",@"a",@"in´trepid",@"fearless brave undaunted",@"Gan dạ, dũng cảm"],
                @[@"inculcate",@"v",@"inkʌl¸keit",@"fix firmly by repetition",@"ghi nhớ, khắc sâu, in sâu (vào tâm trí)"],
                 @[@"embellish",@"v",@"m´beliʃ",@"make beautiful",@"Làm đẹp, trang điểm, tô son điểm phấn"],
                 @[@"fulsome",@"a",@"´fulsəm",@"disgusting offensive due to excessiveness",@"Quá đáng, thái quá, Đê tiện"],
                @[@"corporeal",@"a",@"kɔ:´pɔ:riəl",@"physical of or for the body",@"Vật chất, cụ thể, hữu hình; (pháp lý) cụ thể"]];*/
    curWordNo = 0;
    isFront = YES;
    [self displayCurWord];
    
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) displayCurWord
{
    [_wordNoLb setText:[NSString stringWithFormat:@"%i/%i",curWordNo+1,wordList.count]];
    Word *word = wordList[curWordNo];
    if (isFront) {
        [_wordCard displayWord:word.name wordType:[word getWordType:@"English"] phonetic:word.phonentic detailContent:[word getMeaning:@"English" bExample:YES]];
    }
    else
    {
        [_wordCard displayWord:word.name wordType:[word getWordType:@"Vietnamese"] phonetic:word.phonentic detailContent:[word getMeaning:@"Vietnamese" bExample:NO]];
    }
}
- (IBAction)next:(id)sender {
    isFront = YES;
    if (curWordNo< wordList.count -1) {
        if ([self startMove:_wordCard:YES]) {
            curWordNo++;
        }
        
    };
}
- (IBAction)prev:(id)sender
{
    isFront = YES;
    if (curWordNo>0) {
        if ([self startMove:_wordCard:NO])
        {
            curWordNo--;
        }
    }

}
-(BOOL) startMove:(CardInfoView *)wordCard :(BOOL) moveLeft
{
    return [super startMove:wordCard :moveLeft];
}
-(void) startEndMove:(CardInfoView *)wordCard :(BOOL) moveLeft :(int)startX
{
    [self displayCurWord];
    [super startEndMove:wordCard :moveLeft :startX];
}
-(void) endMove
{
    
}
-(BOOL) startFlip:(CardInfoView *)wordCard
{
    return [super startFlip:wordCard];
}
-(void) startEndFlip:(CardInfoView *)wordCard
{
    isFront = !isFront;
    [self displayCurWord];
    [super startEndFlip:wordCard];
}
-(void) endFlip
{
    
}
-(void) cardIsTapped:(CardInfoView *)card
{
    NSLog(@"cardIsTapped");
    [self startFlip:_wordCard];
}

@end
