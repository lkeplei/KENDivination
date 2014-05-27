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
        
        UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                             image:[UIImage imageNamed:@"button_close.png"]
                                          imagesec:[UIImage imageNamed:@"button_close_sec.png"]
                                            target:self
                                            action:@selector(closeBtnClicked:)];
        button.center = CGPointMake(160, CGRectGetMaxY(_bgView.frame) - button.frame.size.height - 40);
        [_bgView addSubview:button];
        
        [self addSubview:_bgView];
    }
    return self;
}

-(void)setKaPaiMessage:(NSInteger)zhenWei{
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:1];
    UIImageView* kaPai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"m_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
    kaPai.center = CGPointMake(kaPai.frame.size.width / 2 + 25, kaPai.frame.size.height / 2 + 15);
    [_bgView addSubview:kaPai];

    //message
    float offx = CGRectGetMaxX(kaPai.frame) + 10;
    float width = _bgView.frame.size.width - offx - 20;
    NSString* string = [MyLocal(@"kapai_zhenwei") stringByAppendingString:[KENUtils getStringByInt:zhenWei]];
    CGSize size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    float height = (size.height + 1);
    UILabel* label = [self addLabel:string frame:CGRectMake(offx, 15, width, height)];
    
    label = [self addLabel:MyLocal(@"kapai_daibiao") frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)];
    
    label = [self addLabel:[MyLocal(@"kapai_paiming") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiName]]
             frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)];
    
    string = [MyLocal(@"kapai_guanjianzhi") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiKeyword]];
    size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    float lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)];
    label.numberOfLines = lines > 1 ? 0 : 1;
    
    label = [self addLabel:MyLocal(@"kapai_paiwei") frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)];
    
    string = [MyLocal(@"kapai_jieyu") stringByAppendingString:@"工功苛苛村或或相画功杏花暴露在在在大在一工的工有工在一工要一工在一工要在五工在开三工在一工本枯五"];
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
