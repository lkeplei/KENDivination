//
//  KENViewHome.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewHome.h"
#import "KENUtils.h"
#import "KENConfig.h"
#import "KENModel.h"
#import "KENViewController.h"

@interface KENViewHome ()
@property (nonatomic, strong) UIImageView* zhuanPanView;
@end

@implementation KENViewHome

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeHome;
    }
    return self;
}

#pragma mark Swipe Gesture Setup/Actions
-(void)setupGestures {
	UIPanGestureRecognizer* panGestureRecongnize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
	[panGestureRecongnize setMinimumNumberOfTouches:1];
	[panGestureRecongnize setMaximumNumberOfTouches:1];
    [self setUserInteractionEnabled:YES];
	[self addGestureRecognizer:panGestureRecongnize];
}

-(void)movePanel:(id)sender {
//	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        [[KENModel shareModel] playVoiceByType:KENVoiceZhuanPanZhuanDong];
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [[KENModel shareModel] playVoiceByType:KENVoiceZhuanPanTing];
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        
	}
}

#pragma mark - others
-(UIImage*)setBackGroundImage{
    return [UIImage imageNamed:@"home_background_image.png"];
}

-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"home_title.png"];
}

-(void)setTopLeftBtn{

}

-(void)showView{
    //setting btn
    UIButton* setBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                 image:[UIImage imageNamed:@"home_setting.png"]
                              imagesec:[UIImage imageNamed:@"home_setting.png"]
                                target:self
                                action:@selector(settingBtnClicked:)];
    setBtn.center = CGPointMake(288, KNotificationHeight / 2);
    [self.contentView addSubview:setBtn];
    
    //zhuan pai
    _zhuanPanView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_zhuanpan.png"]];
    _zhuanPanView.center = CGPointMake(160, 240);
    [self.contentView addSubview:_zhuanPanView];
    
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_point.png"]];
    imgView.center = _zhuanPanView.center;
    [self.contentView addSubview:imgView];
    
    //add pan
    [self setupGestures];
}

#pragma mark - setting btn
-(void)settingBtnClicked:(UIButton*)button{
    [self pushView:[SysDelegate.viewController getView:KENViewTypeSetting] animatedType:KENTypeNull];
}
@end
