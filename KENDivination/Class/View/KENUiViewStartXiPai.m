//
//  KENUiViewStartXiPai.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-18.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewStartXiPai.h"
#import "KENUtils.h"
#import "KENConfig.h"


@interface KENUiViewStartXiPai ()

@property (assign) KENViewType currentViewType;
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UIButton* stepButton;
@property (nonatomic, strong) UIImageView* imageView;

@end

@implementation KENUiViewStartXiPai

- (id)initWithFrame:(CGRect)frame type:(KENViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeStartXiPai;
        [self initViewWithType:type];
    }
    return self;
}

-(void)initViewWithType:(KENViewType)type{
    _currentViewType = type;
    
    if (type == KENUiViewTypeStartFanPai) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chou_pai_bg.png"]];
        _imageView.center = CGPointMake(160, 80);
        [self addSubview:_imageView];
        
        UIImage* image = [UIImage imageNamed:@"app_pai_bg.png"];
        int count = [[KENModel shareModel] getPaiZhenNumber];
        float width = 240 / count;
        float space = width;
        if (width < image.size.width) {
            width = (240 - image.size.width) / (count - 1);
            space = image.size.width;
        }
        float offset = (_imageView.frame.size.width - 240) / 2;
        for (int i = 0; i < count; i++) {
            UIImageView* pai = [[UIImageView alloc] initWithImage:image];
            pai.center = CGPointMake(offset + space / 2 + width * i, _imageView.frame.size.height / 2);
            [_imageView addSubview:pai];
        }
    } else {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
        _imageView.center = CGPointMake(160, 80);
        if (_currentViewType == KENUiViewTypeStartXiPai || _currentViewType == KENUiViewTypeStartQiePai) {
            _imageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
        [self addSubview:_imageView];
    }
    
    NSString* content = nil;
    UIImage* img = nil;
    UIImage* imgSec = nil;
    switch (_currentViewType) {
        case KENUiViewTypeStartXiPai:{
            content = MyLocal(@"xipai_content");
            img = [UIImage imageNamed:@"button_start_xipai.png"];
            imgSec = [UIImage imageNamed:@"button_start_xipai_sec.png"];
        }
            break;
        case KENUiViewTypeStartQiePai:{
            content = MyLocal(@"qipai_content");
            img = [UIImage imageNamed:@"button_start_qiepai.png"];
            imgSec = [UIImage imageNamed:@"button_start_qiepai_sec.png"];
        }
            break;
        case KENUiViewTypeStartChouPai:{
            content = MyLocal(@"choupai_content");
            img = [UIImage imageNamed:@"button_start_choupai.png"];
            imgSec = [UIImage imageNamed:@"button_start_choupai_sec.png"];
            _imageView.center = KPaiCenter;
        }
            break;
        case KENUiViewTypeStartFanPai:{
            content = MyLocal(@"fanpai_content");
            img = [UIImage imageNamed:@"button_start_fanpai.png"];
            imgSec = [UIImage imageNamed:@"button_start_fanpai_sec.png"];
        }
            break;
        default:
            break;
    }
    _contentLabel = [KENUtils labelWithTxt:content
                                      frame:CGRectMake(60, 140, 210, 170)
                                       font:[UIFont fontWithName:KLabelFontArial size:17]
                                      color:[UIColor whiteColor]];
    _contentLabel.textAlignment = KTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    _contentLabel.alpha = 0;
    [self addSubview:_contentLabel];
    
    _stepButton = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:img
                                      imagesec:imgSec
                                        target:self
                                        action:@selector(btnClicked:)];
    _stepButton.center = CGPointMake(160, 340);
    _stepButton.alpha = 0;
//    [_stepButton setEnabled:NO];
    [self addSubview:_stepButton];
    
    [self initQiePaiAnimate];
}

-(void)viewDealWithAd{
    self.animationStep = -1;
}

-(void)startBaseAnimation{
    if (self.animationStep == -1) {
        _stepButton.alpha = 1;
        _contentLabel.alpha = 1;
        self.animationStep = 0;
    }
    
    [self startQiePaiAnimate];
}

#pragma mark - button
-(void)btnClicked:(UIButton*)button{
    //按键声音
    [[KENModel shareModel] playVoiceByType:KENVoiceAnJian];
    
    if (self.delegate) {
        [self startQiePaiAnimate];
    }
}

-(void)initQiePaiAnimate{
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _stepButton.alpha = 1;
        _contentLabel.alpha = 1;
    }
                     completion:^(BOOL finished) {
                         if (finished) {

                         }
                     }];

}

-(void)startQiePaiAnimate{
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _stepButton.alpha = 0;
        _contentLabel.alpha = 0;
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             if (self.animationStep == -1) {
                                 _stepButton.alpha = 1;
                                 _contentLabel.alpha = 1;
                                 return;
                             }
                             switch (_currentViewType) {
                                 case KENUiViewTypeStartXiPai:{
                                    [self.delegate showViewWithType:KENUiViewTypeEndXiPai];
                                 }
                                     break;
                                 case KENUiViewTypeStartQiePai:{
                                     [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                                         _imageView.center = CGPointMake(160, 160);
                                         _imageView.center = CGPointMake(160, KPaiCenter.y + 80);
                                     }
                                                      completion:^(BOOL finished) {
                                                          if (finished) {
                                                              if (_currentViewType == KENUiViewTypeStartQiePai) {
                                                                  [self.delegate showViewWithType:KENUiViewTypeQiePai];
                                                              }
                                                          }
                                                      }];
                                 }
                                     break;
                                 case KENUiViewTypeStartChouPai:{
                                    [self.delegate showViewWithType:KENUiViewTypeChouPai];
                                 }
                                     break;
                                 case KENUiViewTypeStartFanPai:{
                                     [SysDelegate.viewController removeAd];
                                     
                                     [self.delegate showViewWithType:KENUiViewTypeFanPai];
                                 }
                                     break;
                                 default:
                                     break;
                             }
                         }
                     }];
}
@end
