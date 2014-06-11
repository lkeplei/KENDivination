//
//  KENUiViewChouPai.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-22.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewChouPai.h"
#import "KENConfig.h"

@interface KENUiViewChouPai ()

@property (assign) BOOL animationing;
@property (assign) NSInteger animationIndex;
@property (assign) NSInteger activeIndex;
@property (assign) NSInteger currentSelectIndex;

@property (nonatomic, strong) UIImageView* currentActivePai;
@property (nonatomic, strong) UIImageView* selectPaiBgView;
@property (nonatomic, strong) NSMutableArray* paiArray;
@property (nonatomic, strong) NSMutableArray* selectPaiArray;
@property (nonatomic, strong) NSMutableArray* pathArray;

@end

@implementation KENUiViewChouPai

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeChouPai;
        
        _animationing = NO;
        _animationIndex = 1;
        _activeIndex = 0;
        _currentActivePai = nil;
        [self initView];
    }
    return self;
}

-(void)initView{
    _selectPaiBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chou_pai_bg.png"]];
    _selectPaiBgView.center = CGPointMake(160, 260);
    [self addSubview:_selectPaiBgView];
    
    UIImage* image = [UIImage imageNamed:@"app_pai_bg.png"];
    NSInteger count = [[KENModel shareModel] getPaiZhenNumber];
    float width = 240 / count;
    float space = width;
    if (width < image.size.width) {
        width = (240 - image.size.width) / (count - 1);
        space = image.size.width;
    }
    float offset = (_selectPaiBgView.frame.size.width - 240) / 2;
    _selectPaiArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        UIImageView* pai = [[UIImageView alloc] initWithImage:image];
        pai.center = CGPointMake(offset + space / 2 + width * i + _selectPaiBgView.frame.origin.x,
                                 _selectPaiBgView.frame.size.height / 2 + _selectPaiBgView.frame.origin.y);
        pai.alpha = 0;
        [self addSubview:pai];
        
        [_selectPaiArray addObject:pai];
    }
    _currentSelectIndex = 0;
    [self setSelectIndex];
    
    //
    _paiArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 22; i++) {
        UIImageView* pai = [[UIImageView alloc] initWithImage:image];
        pai.center = CGPointMake(160, -82);
        [self addSubview:pai];
        
        [_paiArray addObject:pai];
    }
    
    [self setupGestures];
    [self startAnimation];
}

-(void)setSelectIndex{
    if (_currentSelectIndex < [_selectPaiArray count]) {
        ((UIImageView*)[_selectPaiArray objectAtIndex:_currentSelectIndex]).alpha = 0.2;
    }
}

#pragma mark Swipe Gesture Setup/Actions
-(void)setupGestures {
    if (![[KENModel shareModel] getPaiZhenAuto]) {
        UIPanGestureRecognizer* panGestureRecongnize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
        [panGestureRecongnize setMinimumNumberOfTouches:1];
        [panGestureRecongnize setMaximumNumberOfTouches:1];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:panGestureRecongnize];
    }
}

-(void)movePanel:(id)sender {
    if (_currentSelectIndex >= [_selectPaiArray count]) {
        return;
    }
    
    CGPoint locationInView = [(UIPanGestureRecognizer*)sender locationInView:self];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if (_currentActivePai == nil) {
            for (int i = [_paiArray count] - 1; i >= 0; i--) {
                BOOL contains = NO;
                if (i <= 5 || i >= 16) {
                    contains = [[_pathArray objectAtIndex:i] containsPoint:locationInView];
                } else {
                    contains = CGRectContainsPoint(((UIImageView*)[_paiArray objectAtIndex:i]).frame, locationInView);
                }

                if (contains && ![[_paiArray objectAtIndex:i] isHidden]) {
                    [self showActivePai:i];
                    break;
                }
            }
        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (_currentActivePai && !_animationing) {
            _animationing = YES;
            if (CGRectContainsPoint(_selectPaiBgView.frame, locationInView)) {
                [self gestureStateEnd];
            } else {
                [self rollback];
            }
        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if (_currentActivePai && !_animationing) {
            _currentActivePai.center = locationInView;
        }
	}
}

-(void)rollback{
    if (_currentActivePai) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            CGRect frame = ((UIImageView*)[_paiArray objectAtIndex:_activeIndex]).frame;
            _currentActivePai.center = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [[_paiArray objectAtIndex:_activeIndex] setHidden:NO];
                                 
                                 [_currentActivePai removeFromSuperview];
                                 _currentActivePai = nil;
                                 
                                 _animationing = NO;
                             }
                         }];
    }
}

-(void)gestureStateEnd{
    if (_currentActivePai) {
        _currentSelectIndex++;
        [self setSelectIndex];
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            _currentActivePai.center = ((UIImageView*)[_selectPaiArray objectAtIndex:_currentSelectIndex - 1]).center;
        }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
                                 imgView.center = CGPointMake(_currentActivePai.center.x - _selectPaiBgView.frame.origin.x,
                                                              _currentActivePai.center.y - _selectPaiBgView.frame.origin.y);
                                 [_selectPaiBgView addSubview:imgView];
                                 
                                 [_currentActivePai removeFromSuperview];
                                 _currentActivePai = nil;
                                 
                                 _animationing = NO;
                                 
                                 if ([[KENModel shareModel] getPaiZhenAuto]) {
                                     [self autoChuoPai];
                                 }
                             }
                         }];
        
        if (_currentSelectIndex >= [_selectPaiArray count]) {
            [self stopAnimation];
        }
    }
}

-(void)showActivePai:(NSInteger)index{
    if (index < [_paiArray count]) {
        _activeIndex = index;
        [[_paiArray objectAtIndex:_activeIndex] setHidden:YES];
        _currentActivePai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];

        CGRect frame = ((UIImageView*)[_paiArray objectAtIndex:_activeIndex]).frame;
        _currentActivePai.center = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
        
        [self addSubview:_currentActivePai];
        
        //抽牌声音
        [[KENModel shareModel] playVoiceByType:KENVoiceChouPai];
    }
}

#pragma mark - animation
-(void)startAnimation{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        for (int i = 0; i < [_paiArray count]; i++) {
            UIImageView* view = [_paiArray objectAtIndex:i];
            view.layer.anchorPoint = CGPointMake(0.5f,-1.45f);//围绕点
            view.transform = CGAffineTransformMakeRotation(40 * (M_PI / 180.0f));
        }
    } completion:^(BOOL finished) {
        [self startExpandAnimation];
    }];
}

-(void)startExpandAnimation{
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        for (int i = 0; i < [_paiArray count]; i++) {
            UIImageView* view = [_paiArray objectAtIndex:i];
            view.layer.anchorPoint = CGPointMake(0.5f,-1.45f);//围绕点
            view.transform = CGAffineTransformMakeRotation((40 - 3.9 * i) * (M_PI / 180.0f));
        }
    } completion:^(BOOL finished) {
        [self autoChuoPai];
        
        float c = [UIImage imageNamed:@"app_pai_bg.png"].size.height;
        _pathArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [_paiArray count]; i++) {
            float angle = (40 - 3.9 * i) > 0 ? (40 - 3.9 * i) : 90 + (40 - 3.9 * i);
            float du = M_PI / (180 / angle);
            float a = cosf(du) * c;
            float b = sinf(du) * c;

            CGRect rect = ((UIImageView*)[_paiArray objectAtIndex:i]).frame;
            UIBezierPath * path = [UIBezierPath bezierPath];
            if (i <= 10) {
                [path moveToPoint:CGPointMake(CGRectGetMinX(rect) + b, CGRectGetMinY(rect))];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + a)];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) - a, CGRectGetMaxY(rect))];
                [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + CGRectGetHeight(rect) - b)];
            } else {
                [path moveToPoint:CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) - b, CGRectGetMinY(rect))];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect) + CGRectGetHeight(rect) - b)];
                [path addLineToPoint:CGPointMake(CGRectGetMinX(rect) + a, CGRectGetMaxY(rect))];
                [path addLineToPoint:CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect) + a)];
            }
            [path closePath];
            
            [_pathArray addObject:path];
            
//            DebugLog(@"a=%.1f rect=(%.1f,%.1f,%.1f,%.1f) bounds=(%.1f,%.1f,%.1f,%.1f)", angle, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height,
//                     path.bounds.origin.x, path.bounds.origin.y, path.bounds.size.width, path.bounds.size.height);
//            
//            
//            if (i == 0) {
//                UIView* view = [[UIView alloc] initWithFrame:path.bounds];
//                view.alpha = 0.7;
//                //            [view setBackgroundColor:RGBCOLOR(255 * i / 21, 255 * i / 21, 255 * i / 21)];
//                [view setBackgroundColor:[UIColor yellowColor]];
//                [self addSubview:view];
//                
//                UIView* view1 = [[UIView alloc] initWithFrame:((UIImageView*)[_paiArray objectAtIndex:i]).frame];
//                view1.alpha = 0.7;
//                //            [view setBackgroundColor:RGBCOLOR(255 * i / 21, 255 * i / 21, 255 * i / 21)];
//                [view1 setBackgroundColor:[UIColor redColor]];
//                [self addSubview:view1];
//            }
        }
    }];
}

-(void)autoChuoPai{
    if ([[KENModel shareModel] getPaiZhenAuto]) {
        NSArray* array = [[KENModel shareModel] getPaiZHenAutoIndex];
        if (_currentSelectIndex < [array count]) {
            int index = [[array objectAtIndex:_currentSelectIndex] intValue];
            [self showActivePai:21 - index];
            [self gestureStateEnd];
        }
    }
}

-(void)stopAnimation{
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        for (int i = 0; i < [_paiArray count]; i++) {
            UIImageView* view = [_paiArray objectAtIndex:i];
            view.layer.anchorPoint = CGPointMake(0.5f,-1.45f);//围绕点
            view.transform = CGAffineTransformMakeRotation(40 * (M_PI / 180.0f));
        }
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
}

-(void)finishAnimation{
    for (int i = 0; i < [_paiArray count]; i++) {
        [[_paiArray objectAtIndex:i] removeFromSuperview];
    }
    for (int i = 0; i < [_selectPaiArray count]; i++) {
        [[_selectPaiArray objectAtIndex:i] removeFromSuperview];
    }
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _selectPaiBgView.center = CGPointMake(160, 80);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self.delegate showViewWithType:KENUiViewTypeStartFanPai];
                         }
                     }];
}
@end
