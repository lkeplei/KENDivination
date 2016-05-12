//
//  KENViewAboutUs.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-15.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewAboutUs.h"
#import "KENUtils.h"
#import "KENUiViewAlert.h"
#import "KENConfig.h"

@implementation KENViewAboutUs

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeAboutUs;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return nil;
}

-(void)showView{
    UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_us_bg.png"]];
    bgView.center = CGPointMake(kFullScreenAdaptiveX(160.f), 240);
    [self.contentView addSubview:bgView];
    
    UIButton* aboutBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                          image:[UIImage imageNamed:@"about_us_qiqi.png"]
                                       imagesec:[UIImage imageNamed:@"about_us_qiqi.png"]
                                         target:self
                                         action:@selector(aboutBtnClicked:)];
    aboutBtn.center = CGPointMake(kFullScreenAdaptiveX(160.f), 317);
    [self.contentView addSubview:aboutBtn];
}

#pragma mark - setting btn
-(void)aboutBtnClicked:(UIButton*)button{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UIImage imageNamed:@"button_close.png"] forKey:KDicKeyImg];
    [dic setObject:[UIImage imageNamed:@"button_close_sec.png"] forKey:KDicKeyImgSec];
    
    KENUiViewAlert* alert = [[KENUiViewAlert alloc] initWithMessage:[UIImage imageNamed:@"about_us_alert.png"]
                                                       btnArray:[[NSArray alloc] initWithObjects:dic, nil]];
    [alert show];
    
    alert.alertBlock = ^(int index){

    };
}
@end
