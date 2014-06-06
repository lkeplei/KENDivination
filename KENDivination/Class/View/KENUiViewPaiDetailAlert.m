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
@property (nonatomic, strong) UIView* tempView;

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
    _originalPosition = CGPointMake(center.x, center.y);
    
    NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:zhenWei];
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
    NSString* imageName = [messageDic objectForKey:KDicKeyPaiImg];
    UIImage* image = [UIImage imageNamed:@"app_pai_bg.png"];
    
    _tempView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, image.size}];
    _tempView.center = CGPointMake(_originalPosition.x - image.size.width, _originalPosition.y);
    [self addSubview:_tempView];
    
    CATransform3D original = _tempView.layer.transform;
    
    UIImageView* imgView = [[UIImageView alloc] initWithImage:image];
    imgView.center = CGPointMake(image.size.width * 1.5, image.size.height / 2);
    [_tempView addSubview:imgView];
    
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CATransform3D rotation = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
                         CATransform3D scale = CATransform3DScale(original, 1.78, 1.78, 1.78);
//                         CATransform3D translation = CATransform3DMakeTranslation(self.center.x - _originalPosition.x, self.center.y - _originalPosition.y, 0);
//                         CATransform3D group = CATransform3DConcat(CATransform3DConcat(rotation, scale), translation);
                         CATransform3D group = CATransform3DConcat(rotation, scale);
                         _tempView.layer.transform = group;
//                         _tempView.center = self.center;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [imgView setImage:[UIImage imageNamed:[@"l_" stringByAppendingString:imageName]]];
                             if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
                                 CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI);
                                 CATransform3D rotation1 = CATransform3DMakeAffineTransform(rotation);
                                 CATransform3D scale = CATransform3DMakeRotation(M_PI, 0, 1, 0);
                                 CATransform3D group = CATransform3DConcat(rotation1, scale);
                                 imgView.layer.transform = group;
                             } else {
                                imgView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
                             }
                             
                             [UIView animateWithDuration:0.75  delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                 CATransform3D rotation = CATransform3DMakeRotation(-M_PI, 0, 1, 0);
//                                 CATransform3D scale = CATransform3DScale(original, 3.51, 3.58, 3.55);
                                 CATransform3D scale = CATransform3DScale(original, 3.53, 3.6, 3.55);
                                 CATransform3D translation = CATransform3DMakeTranslation(195 + self.center.x - _originalPosition.x,
                                                                                          self.center.y - _originalPosition.y, 0);
                                 CATransform3D group = CATransform3DConcat(CATransform3DConcat(rotation, scale), translation);
                                 _tempView.layer.transform = group;
                             } completion:^(BOOL finished){
                                 if (finished) {
                                     _paiView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"l_" stringByAppendingString:imageName]]];
                                     _paiView.center = self.center;
                                     if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
                                         _paiView.transform = CGAffineTransformMakeRotation(M_PI);
                                     }
                                     DebugLog(@"img.frame=(%f, %f, %f, %f) pai.frame=(%f, %f, %f, %f)", imgView.frame.origin.x,
                                              imgView.frame.origin.y, imgView.frame.size.width, imgView.frame.size.height,
                                              _paiView.frame.origin.x, _paiView.frame.origin.y, _paiView.frame.size.width,
                                              _paiView.frame.size.height);
                                     [self addSubview:_paiView];
                                     
                                     [_tempView removeFromSuperview];
                                     
                                     UIButton* button = (UIButton*)[self viewWithTag:KCloseButtonTag];
                                     if (button) {
                                         [button setEnabled:YES];
                                     }
                                 }
                             }];
                         }
                     }];
    
    return;
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

    UIFont* font = [UIFont fontWithName:KLabelFontArial size:12];
    //message
    float offx = CGRectGetMaxX(kaPai.frame) + 10;
    float width = _bgView.frame.size.width - offx - 20;
    NSString* string = [MyLocal(@"kapai_zhenwei") stringByAppendingString:[KENUtils getStringByInt:zhenWei + 1]];
    CGSize size = [KENUtils getFontSize:string font:font];
    float height = (size.height + 1);
    UILabel* label = [self addLabel:string frame:CGRectMake(offx, 15, width, height) font:font];
    
    string = [MyLocal(@"kapai_daibiao") stringByAppendingString:[[KENModel shareModel] getPaiZhenDaiBiao:zhenWei]];
    size = [KENUtils getFontSize:string font:font];
    float lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)
                      font:font];
    label.numberOfLines = lines > 1 ? 0 : 1;
    
    label = [self addLabel:[MyLocal(@"kapai_paiming") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiName]]
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)
                      font:font];
    
    string = [MyLocal(@"kapai_guanjianzhi") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiKeyword]];
    size = [KENUtils getFontSize:string font:font];
    lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)
                      font:font];
    label.numberOfLines = lines > 1 ? 0 : 1;
    
    if ([[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_zheng")];
    } else {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_fan")];
    }
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height) font:font];
    
    string = [MyLocal(@"kapai_jieyu") stringByAppendingString:[[KENModel shareModel] getPaiJieYu:zhenWei]];
    size = [KENUtils getFontSize:string font:font];
    lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)
                      font:font];
    label.numberOfLines = 0;
    
    //animate
    CATransform3D currentTransform = self.layer.transform;
    CATransform3D scaled = CATransform3DScale(self.layer.transform, 0.2, 0.2, 0.2);
    self.layer.transform = scaled;
    [UIView animateWithDuration:0.8 animations:^{
        self.layer.transform = currentTransform;
    }];
}

-(UILabel*)addLabel:(NSString*)content frame:(CGRect)frame font:(UIFont*)font{
    UILabel* label = [KENUtils labelWithTxt:content
                                      frame:frame
                                       font:font
                                      color:[UIColor whiteColor]];
    label.textAlignment = KTextAlignmentLeft;
    [_bgView addSubview:label];
    
    return label;
}

#pragma mark - setting btn
-(void)stopBtnClicked:(UIButton*)button{
    [button setEnabled:NO];
    //放声音
    [[KENModel shareModel] playVoiceByType:KENVoiceFanPaiHou];
    
//     [self addSubview:_paiView];
//     [_tempView removeFromSuperview];
    
    if (_paiView) {
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CATransform3D scale = CATransform3DScale(_paiView.layer.transform, 0.28, 0.28, 0.28);
            CATransform3D translation = CATransform3DMakeTranslation(_originalPosition.x - _paiView.center.x,
                                                                     _originalPosition.y - _paiView.center.y, 0);
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
