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
#import "KENUiViewPaiDetailAlert.h"

@interface KENUiViewFanPai ()

@property (assign) NSInteger currentPaiIndex;
@property (nonatomic, strong) NSMutableArray* imgViewArray;

@end

@implementation KENUiViewFanPai

- (id)initWithFrame:(CGRect)frame finish:(BOOL)finish delegate:(KENViewPaiZhen *)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeFanPai;
        self.delegate = delegate;
        _currentPaiIndex = 0;
        
        if ([[[KENModel shareModel] memoryData] memoryPaiZhen] == 15) {
            UILabel* label = [KENUtils labelWithTxt:MyLocal(@"myselft")
                                              frame:CGRectMake(10, 145, 70, 20)
                                               font:[UIFont fontWithName:KLabelFontArial size:16]
                                              color:[UIColor whiteColor]];
            [self addSubview:label];
            
            UILabel*label1 = [KENUtils labelWithTxt:MyLocal(@"opposite")
                                              frame:CGRectMake(10, 268, 70, 20)
                                               font:[UIFont fontWithName:KLabelFontArial size:16]
                                              color:[UIColor whiteColor]];
            [self addSubview:label1];
        }
        
        if (finish) {
            [self finishView];
        } else {
            [self initView];
        }
    }
    return self;
}

-(void)finishView{
    _imgViewArray = [[NSMutableArray alloc] init];
    int count = [[KENModel shareModel] getPaiZhenNumber];
    NSDictionary* resDic = [[KENModel shareModel] getPaiZhenPostions];
    NSArray* pathArray = [resDic objectForKey:KDicKeyZhenPaiPath];
    
    //pai
    NSString* bgPath = [resDic objectForKey:KDicKeyZhenBgPath];
    if (bgPath) {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
        float rate = [self.delegate getRateIPad];
        if (IsPad) {
            imgView.center = CGPointMake(self.center.x / rate, self.center.y / rate - 30);
        } else {
            if (isIPhone4) {
                imgView.center = CGPointMake(self.center.x, self.center.y - 45);
            } else {
                imgView.center = CGPointMake(self.center.x, self.center.y - 45 - 30);
            }
        }
        
        [self addSubview:imgView];
    }
    
    for (int i = 0; i < count; i++) {
        NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:i];
        NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
        UIImage* img = [UIImage imageNamed:[@"s_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]];
        
        UIImageView* pai = [[UIImageView alloc] initWithImage:img];
        NSDictionary* dic = [pathArray objectAtIndex:i];
        pai.center = CGPointMake([[dic objectForKey:KDicKeyZhenX] intValue], ([[dic objectForKey:KDicKeyZhenY] floatValue] / 480.f) * self.height);
        if ([dic objectForKey:KDicKeyZhenAngle]) {
            pai.transform = CGAffineTransformMakeRotation([[dic objectForKey:KDicKeyZhenAngle] intValue] / 180.0 * M_PI);
        }
        
        if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
            if ([dic objectForKey:KDicKeyZhenAngle]) {
                pai.transform = CGAffineTransformMakeRotation(M_PI + [[dic objectForKey:KDicKeyZhenAngle] intValue] / 180.0 * M_PI);
            } else {
                pai.transform = CGAffineTransformMakeRotation(M_PI);
            }
        }
        
        [self addSubview:pai];
        
        [_imgViewArray addObject:pai];
    }

    [self addLabel];
    
    _currentPaiIndex = count;
}

-(void)initView{
    UILabel* label = [KENUtils labelWithTxt:MyLocal(@"fanpai_remind")
                                      frame:CGRectMake(10, 10, self.frame.size.width, 20)
                                       font:[UIFont fontWithName:KLabelFontArial size:17]
                                      color:[UIColor whiteColor]];
    label.textAlignment = KTextAlignmentLeft;
    label.tag = 1001;
    [self addSubview:label];
    
    //pai
    NSDictionary* resDic = [[KENModel shareModel] getPaiZhenPostions];
    NSString* bgPath = [resDic objectForKey:KDicKeyZhenBgPath];
    if (bgPath) {
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:bgPath]];
        float rate = [self.delegate getRateIPad];
        if (IsPad) {
            imgView.center = CGPointMake(self.center.x / rate, self.center.y / rate - 30);
        } else {
            imgView.center = CGPointMake(self.center.x, self.center.y - 45);
        }
        
        [self addSubview:imgView];
    }
    
    //
    _imgViewArray = [[NSMutableArray alloc] init];
    UIImage* image = [[KENModel shareModel] getKapaiBgImg];
    int count = [[KENModel shareModel] getPaiZhenNumber];
    
    UIImageView* tempView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chou_pai_bg.png"]];
    tempView.center = CGPointMake(160, 80);
    float width = 240 / count;
    float space = width;
    if (width < image.size.width) {
        width = (240 - image.size.width) / (count - 1);
        space = image.size.width;
    }
    float offset = (tempView.frame.size.width - 240) / 2;
    for (int i = 0; i < count; i++) {
        UIImageView* pai = [[UIImageView alloc] initWithImage:image];
        pai.center = CGPointMake(offset + space / 2 + width * i + tempView.frame.origin.x,
                                 tempView.frame.size.height / 2 + tempView.frame.origin.y);
        [self addSubview:pai];
        
        [_imgViewArray addObject:pai];
    }
    
    //animate
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                NSArray* pathArray = [resDic objectForKey:KDicKeyZhenPaiPath];
                if (pathArray) {
                    for (int i = 0; i < [pathArray count]; i++) {
                        NSDictionary* dic = [pathArray objectAtIndex:i];
                        UIImageView* view = [_imgViewArray objectAtIndex:i];
                        view.center = CGPointMake([[dic objectForKey:KDicKeyZhenX] intValue], [[dic objectForKey:KDicKeyZhenY] intValue]);
                        if ([dic objectForKey:KDicKeyZhenAngle]) {
                            view.transform = CGAffineTransformMakeRotation([[dic objectForKey:KDicKeyZhenAngle] intValue] / 180.0 * M_PI);
                        }
                    }
                }
            }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self addLabel];
                         }
                     }];
}

-(void)addLabel{
    for (int i = 0; i < [_imgViewArray count]; i++) {
        CGRect frame = ((UIImageView*)[_imgViewArray objectAtIndex:i]).frame;
        UILabel* label = [KENUtils labelWithTxt:[KENUtils getStringByInt:i + 1]
                                          frame:CGRectMake(frame.origin.x, CGRectGetMaxY(frame),
                                                           frame.size.width, 20)
                                           font:[UIFont fontWithName:KLabelFontArial size:14]
                                          color:[UIColor whiteColor]];
        
        if ([KENModel shareModel].memoryData.memoryPaiZhen == 6 && i == 1) {
            label.textAlignment = KTextAlignmentLeft;
            label.frame = CGRectOffset(label.frame, frame.size.width + 4, -frame.size.height / 2 - 10);
        } else if ([KENModel shareModel].memoryData.memoryPaiZhen == 16) {
            if (i == 0) {
                label.frame = CGRectOffset(label.frame, 20, 0);
            } else if (i == 1){
                label.frame = CGRectOffset(label.frame, -20, 0);
            }
        }
        
        [self addSubview:label];
    }
}

#pragma mark - touch
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([touches count] != 1)
        return;
    
    int index = -1;
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:self];
    for (int i = 0; i < [_imgViewArray count]; i++) {
        if (CGRectContainsPoint(((UIImageView*)[_imgViewArray objectAtIndex:i]).frame, pos)) {
            index = i;
            break;
        }
    }

    if (index != -1) {
        if (index == _currentPaiIndex) {
            KENUiViewPaiDetailAlert* alert = (KENUiViewPaiDetailAlert*)[self viewWithTag:2001];
            if (alert) {
                return;
            }
            _currentPaiIndex++;
            if (_currentPaiIndex == [_imgViewArray count]) {
                if (self.delegate) {
                    [self.delegate setFinishStatus:YES];
                }
                UIView* label = [self viewWithTag:1001];
                if (label) {
                    [label removeFromSuperview];
                    label = nil;
                }
            }
            
            [self animateShowPai:index];
        } else if (index < _currentPaiIndex && _currentPaiIndex >= [_imgViewArray count]) {
            [self showPaiDetail:index];
        } else if (index > _currentPaiIndex) {
            DebugLog(@"please tap pai in sequence");
        }
    }
}

-(void)showPaiDetail:(NSInteger)index{
    KENUiViewPaiDetailAlert* alert = (KENUiViewPaiDetailAlert*)[self viewWithTag:1001];
    if (alert == nil) {
        float rate = [self.delegate getRateIPad];
        CGSize size = CGSizeMake(self.frame.size.width / rate, self.frame.size.height / rate);
        alert = [[KENUiViewPaiDetailAlert alloc] initWithFrame:(CGRect){CGPointZero, size} animate:NO];
        alert.center = CGPointMake(self.frame.size.width / 2 / rate, self.frame.size.height / 2 / rate);
        [alert setKaPaiMessage:index];
        alert.tag = 1001;
        [self addSubview:alert];
    }
}

-(void)animateShowPai:(NSInteger)index{
    NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:index];
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
    
    __block UIImageView* imgView = ((UIImageView*)[_imgViewArray objectAtIndex:index]);
    [imgView setImage:[UIImage imageNamed:[@"s_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
    
    NSDictionary* resDic = [[KENModel shareModel] getPaiZhenPostions];
    NSArray* pathArray = [resDic objectForKey:KDicKeyZhenPaiPath];
    NSDictionary* dic = [pathArray objectAtIndex:index];
    if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        if ([dic objectForKey:KDicKeyZhenAngle]) {
            imgView.transform = CGAffineTransformMakeRotation(M_PI + [[dic objectForKey:KDicKeyZhenAngle] intValue] / 180.0 * M_PI);
        } else {
            imgView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }
    
    [imgView setHidden:YES];
    
    //放声音
    [[KENModel shareModel] playVoiceByType:KENVoiceFanPai];
    
    //show pai
    float rate = [self.delegate getRateIPad];
    CGSize size = CGSizeMake(self.frame.size.width / rate, self.frame.size.height / rate);
    KENUiViewPaiDetailAlert* alert = [[KENUiViewPaiDetailAlert alloc] initWithFrame:(CGRect){CGPointZero, size} animate:YES];
    alert.center = CGPointMake(self.frame.size.width / 2 / rate, self.frame.size.height / 2 / rate);
    [alert animateKaPai:index center:((UIImageView*)[_imgViewArray objectAtIndex:index]).center rate:[self.delegate getRateIPad]];
    alert.tag = 2001;
    [self addSubview:alert];
    
    alert.alertBlock = ^(){
        [imgView setHidden:NO];
        
        if (_currentPaiIndex >= [_imgViewArray count]) {
            //牌全翻开时展示全屏广告
            [SysDelegate.viewController showFullAd];
        }
    };
}

@end
