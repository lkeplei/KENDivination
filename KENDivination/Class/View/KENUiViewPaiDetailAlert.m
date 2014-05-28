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

@interface KENUiViewPaiDetailAlert ()

@property (nonatomic, strong) UIImageView* bgView;

@end

@implementation KENUiViewPaiDetailAlert

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jie_pai_bg.png"]];
        _bgView.center = CGPointMake(160, _bgView.frame.size.height / 2 + 50);
        [_bgView setExclusiveTouch:YES];
        
        [self addSubview:_bgView];
        
        UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                             image:[UIImage imageNamed:@"button_close.png"]
                                          imagesec:[UIImage imageNamed:@"button_close_sec.png"]
                                            target:self
                                            action:@selector(closeBtnClicked:)];
        button.center = CGPointMake(170, CGRectGetMaxY(_bgView.frame) - button.frame.size.height + 10);
        [self addSubview:button];
    }
    return self;
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

    //message
    float offx = CGRectGetMaxX(kaPai.frame) + 10;
    float width = _bgView.frame.size.width - offx - 20;
    NSString* string = [MyLocal(@"kapai_zhenwei") stringByAppendingString:[KENUtils getStringByInt:zhenWei + 1]];
    CGSize size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    float height = (size.height + 1);
    UILabel* label = [self addLabel:string frame:CGRectMake(offx, 15, width, height)];
    
    string = [MyLocal(@"kapai_daibiao") stringByAppendingString:[[KENModel shareModel] getPaiZhenDaiBiao:zhenWei]];
    size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    float lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)];
    label.numberOfLines = lines > 1 ? 0 : 1;
    
    label = [self addLabel:[MyLocal(@"kapai_paiming") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiName]]
             frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)];
    
    string = [MyLocal(@"kapai_guanjianzhi") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiKeyword]];
    size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)];
    label.numberOfLines = lines > 1 ? 0 : 1;
    
    if ([[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_zheng")];
    } else {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_fan")];
    }
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)];
    
    string = [MyLocal(@"kapai_jieyu") stringByAppendingString:[[KENModel shareModel] getPaiJieYu:zhenWei]];
    size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)];
    label.numberOfLines = 0;
    
    //animate
    CATransform3D currentTransform = self.layer.transform;
    CATransform3D scaled = CATransform3DScale(self.layer.transform, 0.2, 0.2, 0.2);
    self.layer.transform = scaled;
    [UIView animateWithDuration:0.8 animations:^{
        self.layer.transform = currentTransform;
    }];
}

-(UILabel*)addLabel:(NSString*)content frame:(CGRect)frame{
    UILabel* label = [KENUtils labelWithTxt:content
                                      frame:frame
                                       font:[UIFont fontWithName:KLabelFontArial size:12]
                                      color:[UIColor whiteColor]];
    label.textAlignment = KTextAlignmentLeft;
    [_bgView addSubview:label];
    
    return label;
}

#pragma mark - setting btn
-(void)closeBtnClicked:(UIButton*)button{
    [self removeFromSuperview];
}
@end
