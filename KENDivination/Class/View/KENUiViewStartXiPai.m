//
//  KENUiViewStartXiPai.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-18.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewStartXiPai.h"
#import "KENUtils.h"
#import "KENConfig.h"

@implementation KENUiViewStartXiPai

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeStartXiPai;
    }
    return self;
}


-(void)initViewWithType:(KENViewType)type{
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
    imgView.center = CGPointMake(160, 132);
    if (type == KENUiViewTypeStartXiPai || type == KENUiViewTypeStartQiePai) {
        imgView.transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
    }
    [self addSubview:imgView];
    
    NSString* content = nil;
    UIImage* img = nil;
    UIImage* imgSec = nil;
    switch (type) {
        case KENUiViewTypeStartXiPai:{
            content = MyLocal(@"xipai_content");
            img = [UIImage imageNamed:@"button_start_xipai.png"];
            imgSec = [UIImage imageNamed:@"button_start_xipai_sec.png"];
        }
            break;
        case KENUiViewTypeStartQiePai:{
            content = MyLocal(@"qipai_content");
            img = [UIImage imageNamed:@"button_start_qiepai.png"];
            imgSec = [UIImage imageNamed:@"button_start_qiepai_sec.png"];
        }
            break;
        case KENUiViewTypeStartChouPai:{
            content = MyLocal(@"choupai_content");
            img = [UIImage imageNamed:@"button_start_choupai.png"];
            imgSec = [UIImage imageNamed:@"button_start_choupai_sec.png"];
        }
            break;
        default:
            break;
    }
    UILabel* label = [KENUtils labelWithTxt:content
                                      frame:CGRectMake(60, 165, 210, 150)
                                       font:[UIFont fontWithName:KLabelFontArial size:17]
                                      color:[UIColor whiteColor]];
    label.textAlignment = KTextAlignmentLeft;
    label.numberOfLines = 0;
    [self addSubview:label];
    
    UIButton* button = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:img
                                      imagesec:imgSec
                                        target:self
                                        action:@selector(btnClicked:)];
    button.center = CGPointMake(160, 390);
    [self addSubview:button];
}

#pragma mark - button
-(void)btnClicked:(UIButton*)button{
    if (self.delegate) {
        [self.delegate showVIewWithType:KENUiViewTypeEndXiPai];
    }
}
@end
