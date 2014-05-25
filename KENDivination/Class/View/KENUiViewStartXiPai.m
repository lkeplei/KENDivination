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


@interface KENUiViewStartXiPai ()

@property (assign) KENViewType currentViewType;

@end

@implementation KENUiViewStartXiPai

- (id)initWithFrame:(CGRect)frame type:(KENViewType)type{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeStartXiPai;
        [self initViewWithType:type];
    }
    return self;
}

-(void)initViewWithType:(KENViewType)type{
    _currentViewType = type;
    
    if (type == KENUiViewTypeStartFanPai) {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chou_pai_bg.png"]];
        imgView.center = CGPointMake(160, 80);
        [self addSubview:imgView];
        
        UIImage* image = [UIImage imageNamed:@"app_pai_bg.png"];
        int count = [[KENModel shareModel] getPaiZhenNumber];
        float width = 240 / count;
        float space = width;
        if (width < image.size.width) {
            width = (240 - image.size.width) / (count - 1);
            space = image.size.width;
        }
        float offset = (imgView.frame.size.width - 240) / 2;
        for (int i = 0; i < count; i++) {
            UIImageView* pai = [[UIImageView alloc] initWithImage:image];
            pai.center = CGPointMake(offset + space / 2 + width * i, imgView.frame.size.height / 2);
            [imgView addSubview:pai];
        }
    } else {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
        imgView.center = CGPointMake(160, 80);
        if (_currentViewType == KENUiViewTypeStartXiPai || _currentViewType == KENUiViewTypeStartQiePai) {
            imgView.transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
        }
        [self addSubview:imgView];
    }
    
    NSString* content = nil;
    UIImage* img = nil;
    UIImage* imgSec = nil;
    switch (_currentViewType) {
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
        case KENUiViewTypeStartFanPai:{
            content = MyLocal(@"fanpai_content");
            img = [UIImage imageNamed:@"button_start_fanpai.png"];
            imgSec = [UIImage imageNamed:@"button_start_fanpai_sec.png"];
        }
            break;
        default:
            break;
    }
    UILabel* label = [KENUtils labelWithTxt:content
                                      frame:CGRectMake(60, 140, 210, 170)
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
    button.center = CGPointMake(160, 340);
    [self addSubview:button];
}

#pragma mark - button
-(void)btnClicked:(UIButton*)button{
    if (self.delegate) {
        switch (_currentViewType) {
            case KENUiViewTypeStartXiPai:{
//                [self.delegate showViewWithType:KENUiViewTypeEndXiPai];
                [self.delegate showViewWithType:KENUiViewTypeChouPai];
            }
                break;
            case KENUiViewTypeStartQiePai:{
                [self.delegate showViewWithType:KENUiViewTypeQiePai];
            }
                break;
            case KENUiViewTypeStartChouPai:{
                [self.delegate showViewWithType:KENUiViewTypeChouPai];
            }
                break;
            case KENUiViewTypeStartFanPai:{
                [self.delegate showViewWithType:KENUiViewTypeFanPai];
            }
                break;
            default:
                break;
        }
    }
}
@end
