//
//  KENViewSetting.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-13.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewSetting.h"
#import "KENUtils.h"
#import "KENConfig.h"
#import "KENModel.h"
#import "KENDataManager.h"

@implementation KENViewSetting

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeSetting;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"setting_title.png"];
}

-(void)showView{
    UIImageView* voiceView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_voice.png"]];
    voiceView.center = CGPointMake(kFullScreenAdaptiveX(160.f), 169);
    [self.contentView addSubview:voiceView];

    //switch
    UISwitch* switchVoice = [[UISwitch alloc] initWithFrame:(CGRect){CGPointZero, 0, 0}];
//    switchVoice.onTintColor = [UIColor redColor]; // 在oneSwitch开启的状态显示的颜色 默认是blueColor
//    switchVoice.tintColor = [UIColor purpleColor]; // 设置关闭状态的颜色
//    switchVoice.thumbTintColor = [UIColor blueColor]; // 设置开关上左右滑动的小圆点的颜色
//    switchVoice.onImage = [UIImage imageNamed:@"min.png"]; // 打开状态显示的图片
//    switchVoice.offImage = [UIImage imageNamed:@"max.png"]; // 关闭状态下的图片
    switchVoice.center = CGPointMake(kFullScreenAdaptiveX(259.f), 169);
    [switchVoice setOn:[[KENDataManager getDataByKey:KUserDefaultSetOpenVoice] boolValue]];
    [switchVoice addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchVoice];

    //btn
    UIButton* pingBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"setting_ping_jia.png"]
                                      imagesec:[UIImage imageNamed:@"setting_ping_jia_sec.png"]
                                        target:self
                                        action:@selector(pingBtnClicked:)];
    pingBtn.center = CGPointMake(kFullScreenAdaptiveX(160.f), 212);
    [self.contentView addSubview:pingBtn];
    
    UIButton* aboutBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                          image:[UIImage imageNamed:@"setting_about_us.png"]
                                       imagesec:[UIImage imageNamed:@"setting_about_us_sec.png"]
                                         target:self
                                         action:@selector(aboutBtnClicked:)];
    aboutBtn.center = CGPointMake(kFullScreenAdaptiveX(160.f), 255);
    [self.contentView addSubview:aboutBtn];
    
    //添加广告
    [SysDelegate.viewController resetAd];
}

#pragma mark - switch
- (void)switchAction:(id)sender{
    UISwitch* switcher = (UISwitch*)sender;
    [KENDataManager setDataByKey:[NSNumber numberWithBool:[switcher isOn]] forkey:KUserDefaultSetOpenVoice];
}

#pragma mark - setting btn
-(void)pingBtnClicked:(UIButton*)button{
    NSString* res = [KENUtils getPreferredLanguage];
    if ([res compare:@"zh-Hans"] == NSOrderedSame) {
        [KENUtils openUrl:KIosZhHansItunesIP];
    } else {
        [KENUtils openUrl:KIosENItunesIP];   
    }
}

-(void)aboutBtnClicked:(UIButton*)button{
    [self pushView:[SysDelegate.viewController getView:KENViewTypeAboutUs] animatedType:KENTypeNull];
}
@end
