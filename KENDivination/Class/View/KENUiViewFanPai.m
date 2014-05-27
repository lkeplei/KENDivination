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

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeFanPai;
        _currentPaiIndex = 0;
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
                     }];
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

    if (index != -1 && _currentPaiIndex < [_imgViewArray count]) {
        if (index == _currentPaiIndex) {
            [self animateShowPai:index];
            _currentPaiIndex++;
        } else if (index < _currentPaiIndex) {
            [self showPaiDetail:index];
        } else if (index > _currentPaiIndex) {
            DebugLog(@"please tap pai in sequence");
        }
    }
}

-(void)showPaiDetail:(NSInteger)index{
    DebugLog(@"show pai --------- > index = %d", index);
    KENUiViewPaiDetailAlert* alert = [[KENUiViewPaiDetailAlert alloc] initWithFrame:(CGRect){CGPointZero, self.frame.size}];
    alert.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [alert setKaPaiMessage:[[KENModel shareModel] getKaPaiMessage:1]];
    [self addSubview:alert];
}

-(void)animateShowPai:(NSInteger)index{
    DebugLog(@"animate , show pai message ===== > index = %d", index);
}
@end
