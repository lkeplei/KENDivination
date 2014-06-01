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
#import "KENViewDirection.h"

@interface KENViewHome (){
    int rotateView;
    CGPoint prePoint;
}
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
    CGPoint locationInView = [(UIPanGestureRecognizer*)sender locationInView:self.contentView];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        [[KENModel shareModel] playVoiceByType:KENVoiceZhuanPanZhuanDong];
        prePoint = CGPointMake(locationInView.x - 160, 240 - locationInView.y);
        rotateView = 0;
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [[KENModel shareModel] playVoiceByType:KENVoiceZhuanPanTing];
        int rotate = rotateView % 60;
        if (rotate > 30) {
            rotateView += 60 - rotate;
        } else {
            rotateView -= rotate;
        }
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _zhuanPanView.transform = CGAffineTransformMakeRotation(rotateView / 180.0 * M_PI);
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 rotateView = rotateView >= 0 ? rotateView : 360 - abs(rotateView);
                                 int index = rotateView / 60;
                                 if (index == 1) {
                                     [self pushView:[SysDelegate.viewController getView:KENViewTypeMemory] animatedType:KENTypeNull];
                                 } else {
                                     switch (index) {
                                         case 0:
                                             [[KENModel shareModel].memoryData setMemoryDirection:KENTypeDirectionLove];
                                             break;
                                         case 2:
                                             [[KENModel shareModel].memoryData setMemoryDirection:KENTypeDirectionHealth];
                                             break;
                                         case 3:
                                             [[KENModel shareModel].memoryData setMemoryDirection:KENTypeDirectionRelation];
                                             break;
                                         case 4:
                                             [[KENModel shareModel].memoryData setMemoryDirection:KENTypeDirectionMoney];
                                             break;
                                         case 5:
                                             [[KENModel shareModel].memoryData setMemoryDirection:KENTypeDirectionWork];
                                             break;
                                         default:
                                             break;
                                     }
                                     [self pushView:[SysDelegate.viewController getView:KENViewTypeQuestion] animatedType:KENTypeNull];
                                 }
                                 _zhuanPanView.transform = CGAffineTransformMakeRotation(0 / 180.0 * M_PI);
                             }
                         }];

	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if (CGRectContainsPoint(_zhuanPanView.frame, locationInView)) {
            CGPoint point = CGPointMake(locationInView.x - 160, 240 - locationInView.y);
            int offx = abs(point.x - prePoint.x);
            if (offx > 1) {
                if (point.y > 0) {
                    if (prePoint.x < point.x) {
                        rotateView += offx;
                    } else {
                        rotateView -= offx;
                    }
                } else {
                    if (prePoint.x < point.x) {
                        rotateView -= offx;
                    } else {
                        rotateView += offx;
                    }
                }
                
                prePoint = point;
                _zhuanPanView.transform = CGAffineTransformMakeRotation(rotateView / 180.0 * M_PI);
                rotateView = rotateView > 360 ? rotateView - 360 : rotateView;
            }
        }
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
