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

@interface KENUiViewFanPai ()

@property (nonatomic, strong) NSMutableArray* imgViewArray;

@end

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
    
    //pai
    NSDictionary* resDic = [[KENModel shareModel] getPaiZhenPostions];
    NSString* bgPath = [resDic objectForKey:KDicKeyZhenBgPath];
    if (bgPath) {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
        imgView.center = CGPointMake(self.center.x, self.center.y - 45);
        [self addSubview:imgView];
    }
    
    //
    _imgViewArray = [[NSMutableArray alloc] init];
    UIImage* image = [UIImage imageNamed:@"app_pai_bg.png"];
    int count = [[KENModel shareModel] getPaiZhenNumber];
    for (int i = 0; i < count; i++) {
        UIImageView* pai = [[UIImageView alloc] initWithImage:image];
        pai.center = CGPointMake(self.center.x, self.center.y - 45);
        [self addSubview:pai];
        
        [_imgViewArray addObject:pai];
    }
    
    //animate
    [UIView animateWithDuration:1.5 animations:^{
        NSArray* pathArray = [resDic objectForKey:KDicKeyZhenPaiPath];
        for (int i = 0; i < [pathArray count]; i++) {
            NSDictionary* dic = [pathArray objectAtIndex:i];
            UIImageView* view = [_imgViewArray objectAtIndex:i];
            view.center = CGPointMake([[dic objectForKey:KDicKeyZhenX] intValue], [[dic objectForKey:KDicKeyZhenY] intValue]);
            if ([dic objectForKey:KDicKeyZhenAngle]) {
                view.transform = CGAffineTransformMakeRotation([[dic objectForKey:KDicKeyZhenAngle] intValue] / 180 * M_PI);
            }
        }
    }];
}
@end
