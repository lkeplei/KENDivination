//
//  KENViewSubjectSetting.m
//  KENDivination
//
//  Created by 刘坤 on 15/1/16.
//  Copyright (c) 2015年 ken. All rights reserved.
//

#import "KENViewSubjectSetting.h"
#import "KENUtils.h"
#import "KENConfig.h"
#import "KENModel.h"
#import "KENDataManager.h"

@implementation KENViewSubjectSetting

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypeSubjectSetting;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [UIImage imageNamed:@"subject_setting_title.png"];
}

-(void)showView{
    //初始页面背景
    [self initAppBgSelect];
    
    //初始卡牌背景
    [self initPaiBgSelect];
    
    //分隔线
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subject_separator.png"]];
    line.center = CGPointMake(160, 222);
    [self.contentView addSubview:line];
    
    //确认修改按钮
    UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                             image:[UIImage imageNamed:@"subject_confirm.png"]
                          imagesec:[UIImage imageNamed:@"subject_confirm_sec.png"]
                            target:self
                            action:@selector(btnConfirmClicked:)];
    button.center = CGPointMake(160, 382);
    [self.contentView addSubview:button];
}

- (void)initAppBgSelect {
    
}

- (void)initPaiBgSelect {
    
}

#pragma mark - setting btn
- (void)btnConfirmClicked:(UIButton *)button {
    
}

@end