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

@interface KENViewAboutUs ()

@property (nonatomic, strong) UIImageView* qiqiView;

@end

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
    bgView.center = CGPointMake(160, 240);
    [self.contentView addSubview:bgView];
    
    _qiqiView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_us_qiqi.png"]];
    _qiqiView.center = CGPointMake(160, 316);
    [_qiqiView setHidden:YES];
    [self.contentView addSubview:_qiqiView];
    
    UIButton* aboutBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                          image:nil
                                       imagesec:nil
                                         target:self
                                         action:@selector(aboutBtnClicked:)];
    aboutBtn.frame = CGRectMake(0, KNotificationHeight, self.contentView.frame.size.width,
                                self.contentView.frame.size.height - KNotificationHeight);
    [self.contentView addSubview:aboutBtn];
}

#pragma mark - setting btn
-(void)aboutBtnClicked:(UIButton*)button{
    [_qiqiView setHidden:NO];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UIImage imageNamed:@"button_close.png"] forKey:KDicKeyImg];
    [dic setObject:[UIImage imageNamed:@"button_close_sec.png"] forKey:KDicKeyImgSec];
    
    KENUiViewAlert* alert = [[KENUiViewAlert alloc] initWithMessage:[UIImage imageNamed:@"about_us_alert.png"]
                                                       btnArray:[[NSArray alloc] initWithObjects:dic, nil]];
    [alert show];
    
    alert.alertBlock = ^(int index){
        [_qiqiView setHidden:YES];
    };
}
@end
