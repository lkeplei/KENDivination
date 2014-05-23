//
//  KENUiViewFanPai.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-23.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewFanPai.h"
#import "KENUtils.h"
#import "KENModel.h"
#import "KENConfig.h"

@implementation KENUiViewFanPai

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeFanPai;
        [self initView];
    }
    return self;
}

-(void)initView{
    UILabel* label = [KENUtils labelWithTxt:MyLocal(@"fanpai_remind")
                                      frame:CGRectMake(10, 10, self.frame.size.width, 20)
                                       font:[UIFont fontWithName:KLabelFontArial size:17]
                                      color:[UIColor whiteColor]];
    label.textAlignment = KTextAlignmentLeft;
    [self addSubview:label];
    
}
@end
