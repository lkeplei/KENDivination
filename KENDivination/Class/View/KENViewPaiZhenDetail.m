//
//  KENViewPaiZhenDetail.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-27.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewPaiZhenDetail.h"
#import "KENModel.h"
#import "KENUtils.h"
#import "KENConfig.h"

@implementation KENViewPaiZhenDetail

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypePaiZhenDetail;
    }
    return self;
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [[KENModel shareModel] getPaiZhenTitle];
}

-(void)showView{
    UIButton* setBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"app_btn_paizhen.png"]
                                      imagesec:[UIImage imageNamed:@"app_btn_paizhen_sec.png"]
                                        target:self
                                        action:@selector(btnClicked:)];
    setBtn.center = CGPointMake(288, KNotificationHeight / 2);
    [self.contentView addSubview:setBtn];
}

#pragma mark - btn clicked
-(void)btnClicked:(UIButton*)button{
    [self popView:KENTypeNull];
}

@end
