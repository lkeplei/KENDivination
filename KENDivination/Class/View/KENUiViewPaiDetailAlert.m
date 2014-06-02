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
            button.frame = self.frame;
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

-(void)animateKaPai:(NSInteger)zhenWei center:(CGPoint)center{
    NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:zhenWei];
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
    UIImageView* largeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"s_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
    largeImg.center = center;
    if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        largeImg.transform = CGAffineTransformMakeRotation(M_PI);
    }
//    [self addSubview:largeImg];
    
//    CATransform3D currentTransform = largeImg.layer.transform;
//    CATransform3D scaled = CATransform3DScale(self.layer.transform, 0.2, 0.2, 0.2);
//    largeImg.layer.transform = scaled;
//    [UIView animateWithDuration:0.8 animations:^{
//        largeImg.layer.transform = currentTransform;
//    }];
    
    
    UIImage* image = [UIImage imageNamed:@"app_pai_bg.png"];
    
    UIView* view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, image.size}];
    view.center = self.center;
    [self addSubview:view];
    
    UIImageView* imgView = [[UIImageView alloc] initWithImage:image];
    imgView.center = CGPointMake(image.size.width * 1.5, image.size.height / 2);
    [view addSubview:imgView];
    
    
    CATransform3D original = view.layer.transform;
    
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CATransform3D rotation = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
                         CATransform3D scale = CATransform3DScale(original, 2, 2, 2);
                         CATransform3D translation = CATransform3DMakeTranslation(100, 0, 0);
                         CATransform3D group = CATransform3DConcat(CATransform3DConcat(rotation, scale), translation);
                         view.layer.transform = group;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [imgView setImage:[UIImage imageNamed:[@"s_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
                             if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
                                 imgView.transform = CGAffineTransformMakeRotation(M_PI);
                             }
                             imgView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
                             
                             [UIView animateWithDuration:1.5 animations:^{
                                 CATransform3D rotation = CATransform3DMakeRotation(-M_PI, 0, 1, 0);
                                 CATransform3D scale = CATransform3DScale(original, 3, 3, 3);
                                 CATransform3D translation = CATransform3DMakeTranslation(100, 0, 0);
                                 CATransform3D group = CATransform3DConcat(CATransform3DConcat(rotation, scale), translation);
                                 view.layer.transform = group;
                             }];
                         }
                     }];
    
    return;
    
    
    CALayer* layer = [CALayer layer];
	layer.frame = self.frame;
//	layer.zPosition = -300000;
    
    CALayer *leftLayer = [CALayer layer];
	leftLayer.frame = CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height);
	leftLayer.masksToBounds = YES;
	leftLayer.contentsGravity = kCAGravityLeft;
    
    leftLayer.contents = (id) [[UIImage imageNamed:@"app_pai_bg.png"] CGImage];
	
	[layer addSublayer:leftLayer];
	
    [self.layer addSublayer:layer];
    
    [UIView animateWithDuration:1.5 animations:^{
        layer.transform = CATransform3DMakeRotation(0.8, 0, 1, 0);
    }];
    
    return;
    
    
//    [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    imageView.center = center;
    [self addSubview:imageView];
    
    [UIView animateWithDuration:1.5 animations:^{
//        CATransform3D transloate = CATransform3DMakeTranslation(0, 0, -200);
//        CATransform3D rotate = CATransform3DMakeRotation(0.8, 0, 1, 0);
//        CATransform3D mat = CATransform3DConcat(rotate, transloate);
//        largeImg.layer.transform = CATransform3DPerspect(mat, CGPointMake(0, 0), 500);
        
        
//        largeImg.layer.transform = CATransform3DMakeTranslation(0, 0, -200);
//        largeImg.layer.transform = CATransform3DMakeRotation(-0.8, 0, 1, 0);
        
        CATransform3D rotation = CATransform3DMakeRotation(-0.8, 0, 1, 0);
        rotation.m34 = -1.0 / 200;
        imageView.layer.transform = rotation;
    }];
}
CATransform3D CATransform3DMakePerspective(CGPoint center, float disZ)
{
    CATransform3D transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
    CATransform3D transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
    CATransform3D scale = CATransform3DIdentity;
    scale.m34 = -1.0f/disZ;
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
}

CATransform3D CATransform3DPerspect(CATransform3D t, CGPoint center, float disZ)
{
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ));
}
- (void)update
{
    static float angle = 0;
    angle += 0.05f;
    
//    CATransform3D transloate = CATransform3DMakeTranslation(0, 0, -200);
//    CATransform3D rotate = CATransform3DMakeRotation(angle, 0, 1, 0);
//    CATransform3D mat = CATransform3DConcat(rotate, transloate);
//    image.layer.transform = CATransform3DPerspect(mat, CGPointMake(0, 0), 500);
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
-(void)stopBtnClicked:(UIButton*)button{
    //放声音
    [[KENModel shareModel] playVoiceByType:KENVoiceFanPaiHou];
    
    [self removeFromSuperview];
}

-(void)closeBtnClicked:(UIButton*)button{
    [self removeFromSuperview];
}
@end
