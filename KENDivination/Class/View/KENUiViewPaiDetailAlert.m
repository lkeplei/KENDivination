//
//  KENUiViewPaiDetailAlert.m
//  KENDivination
//
//  Created by apple on 14-5-27.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewPaiDetailAlert.h"
#import "KENUtils.h"
#import "KENModel.h"
#import "KENConfig.h"

#define KCloseButtonTag         (1001)

@interface KENUiViewPaiDetailAlert ()

@property (assign) CGPoint originalPosition;
@property (nonatomic, strong) UIImageView* bgView;
@property (nonatomic, strong) UIImageView* paiView;

@end

@implementation KENUiViewPaiDetailAlert

-(id)initWithFrame:(CGRect)frame animate:(BOOL)animate{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jie_pai_bg.png"]];
        _bgView.center = CGPointMake(160, _bgView.frame.size.height / 2 + 50);
        [_bgView setExclusiveTouch:YES];
        
        [self addSubview:_bgView];

        if (animate) {
            _bgView.layer.transform = CATransform3DScale(self.layer.transform, 4, 4, 4);
            
            UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                                 image:nil
                                              imagesec:nil
                                                target:self
                                                action:@selector(stopBtnClicked:)];
            button.tag = KCloseButtonTag;
            button.frame = self.frame;
            [button setEnabled:NO];
            [self addSubview:button];
        } else {
            UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                                 image:[UIImage imageNamed:@"button_close.png"]
                                              imagesec:[UIImage imageNamed:@"button_close_sec.png"]
                                                target:self
                                                action:@selector(closeBtnClicked:)];
            button.center = CGPointMake(170, CGRectGetMaxY(_bgView.frame) - button.frame.size.height + 10);
            [self addSubview:button];
        }
    }
    return self;
}

-(void)animateKaPai:(NSInteger)zhenWei center:(CGPoint)center rate:(float)rate{
    _bgView.alpha = 0.65;
    _originalPosition = CGPointMake(center.x, center.y);

    NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:zhenWei];
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
    NSString* imageName = [messageDic objectForKey:KDicKeyPaiImg];

    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    imgView.center = CGPointMake(center.x, center.y);
    imgView.layer.anchorPoint = CGPointMake(0.0f, 0.5f);
    [self addSubview:imgView];
    
    _paiView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"l_" stringByAppendingString:imageName]]];
    _paiView.center = CGPointMake(center.x, center.y);
    _paiView.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
    if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        UIImageView* newView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"l_" stringByAppendingString:imageName]]];
        [newView setImage:[UIImage imageNamed:[@"l_" stringByAppendingString:imageName]]];
        newView.transform = CGAffineTransformMakeRotation(M_PI);
        [_paiView addSubview:newView];
    }
    
    [UIView animateWithDuration:0.75  delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        CATransform3D rotation = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        CATransform3D scale = CATransform3DScale(imgView.layer.transform, 2, 2, 2);
        CATransform3D group = CATransform3DConcat(rotation, scale);
        imgView.layer.transform = group;
    } completion:^(BOOL finished){
        if (finished) {
            [imgView removeFromSuperview];
            
            [self addSubview:_paiView];
            CATransform3D rotation = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
            CATransform3D scale = CATransform3DScale(_paiView.layer.transform, 0.5, 0.5, 0.5);
            _paiView.layer.transform = CATransform3DConcat(rotation, scale);
            
            [UIView animateWithDuration:1  delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                CATransform3D scale = CATransform3DMakeRotation(0, 0, 1, 0);
                CATransform3D translation = CATransform3DMakeTranslation(self.center.x - _originalPosition.x + _paiView.bounds.size.width / 2,
                                                                         self.center.y - _originalPosition.y - KNotificationHeight / 2, 0);
                _paiView.layer.transform = CATransform3DConcat(translation, scale);
            } completion:^(BOOL finished){
                UIButton* button = (UIButton*)[self viewWithTag:KCloseButtonTag];
                if (button) {
                    [button setEnabled:YES];
                }
            }];
        }
    }];
}

-(void)setKaPaiMessage:(NSInteger)zhenWei{
    NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:zhenWei];
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
    UIImageView* kaPai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"m_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
    kaPai.center = CGPointMake(kaPai.frame.size.width / 2 + 25, kaPai.frame.size.height / 2 + 15);
    if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        kaPai.transform = CGAffineTransformMakeRotation(M_PI);
    }
    [_bgView addSubview:kaPai];

    //scroll view
    UIScrollView* scrollView = [[UIScrollView alloc]initWithFrame:(CGRect){CGPointZero, _bgView.frame.size.width,
        _bgView.frame.size.height - 40}];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [_bgView addSubview:scrollView];

    UIFont* font = [UIFont fontWithName:KLabelFontArial size:13];
    //message
    float offx = CGRectGetMaxX(kaPai.frame) + 10;
    float width = _bgView.frame.size.width - offx - 20;
    NSString* string = [MyLocal(@"kapai_zhenwei") stringByAppendingString:[KENUtils getStringByInt:zhenWei + 1]];
    CGSize size = [KENUtils getFontSize:string font:font];
    float height = (size.height + 1);
    UILabel* label = [self addLabel:string
                     frame:CGRectMake(offx, 15, width, height)
                      font:font index:3 view:scrollView];
    
    string = [MyLocal(@"kapai_daibiao") stringByAppendingString:[[KENModel shareModel] getPaiZhenDaiBiao:zhenWei]];
    size = [KENUtils getFontSize:string font:font];
    float lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)
                      font:font index:3 view:scrollView];
    label.numberOfLines = lines > 1 ? 0 : 1;

    label = [self addLabel:[MyLocal(@"kapai_paiming") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiName]]
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)
                      font:font index:3 view:scrollView];
    
    string = [MyLocal(@"kapai_guanjianzhi") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiKeyword]];
    size = [KENUtils getFontSize:string font:font];
    lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)
                      font:font index:4 view:scrollView];
    label.numberOfLines = lines > 1 ? 0 : 1;
    
    if ([[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_zheng")];
    } else {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_fan")];
    }
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)
                      font:font index:3 view:scrollView];
    
    string = [MyLocal(@"kapai_jieyu") stringByAppendingString:[[KENModel shareModel] getPaiJieYu:zhenWei]];
    size = [KENUtils getFontSize:string font:font];
    lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines)
                      font:font index:3 view:scrollView];
    label.numberOfLines = 0;

    //scroll view 设置
    scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(label.frame));
    scrollView.contentOffset  = CGPointMake(0, 0);
    [_bgView setUserInteractionEnabled:YES];
    
    //animate
    CATransform3D currentTransform = self.layer.transform;
    CATransform3D scaled = CATransform3DScale(self.layer.transform, 0.2, 0.2, 0.2);
    self.layer.transform = scaled;
    [UIView animateWithDuration:0.8 animations:^{
        self.layer.transform = currentTransform;
    }];
}

-(UILabel*)addLabel:(NSString*)content frame:(CGRect)frame font:(UIFont*)font index:(int)index view:(UIScrollView*)view{
    UILabel* label = [KENUtils labelWithTxt:content
                                      frame:frame
                                       font:font
                                      color:[UIColor whiteColor]];
    label.textAlignment = KTextAlignmentLeft;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    [str addAttribute:NSForegroundColorAttributeName value:KJiePaiKeyColor range:NSMakeRange(0, index)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(index, [content length] - index)];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
    label.attributedText = str;
    
//    [_bgView addSubview:label];
    [view addSubview:label];
    
    return label;
}

#pragma mark - setting btn
-(void)stopBtnClicked:(UIButton*)button{
    [button setEnabled:NO];
    //放声音
    [[KENModel shareModel] playVoiceByType:KENVoiceFanPaiHou];

    if (_paiView) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CATransform3D scale = CATransform3DScale(_paiView.layer.transform, 0.285, 0.279, 0.28);
            CATransform3D translation = CATransform3DMakeTranslation(_originalPosition.x - self.center.x - _paiView.bounds.size.width / 2 + 22,
                                                                     _originalPosition.y - self.center.y + KNotificationHeight / 2, 0);
            CATransform3D group = CATransform3DConcat(scale, translation);
            _paiView.layer.transform = group;
        } completion:^(BOOL finished){
            if (finished) {
                if (self.alertBlock) {
                    self.alertBlock();
                }
                [self removeFromSuperview];
            }
        }];
    } else {
        [self removeFromSuperview];
    }
}

-(void)closeBtnClicked:(UIButton*)button{
    [self removeFromSuperview];
}
@end
