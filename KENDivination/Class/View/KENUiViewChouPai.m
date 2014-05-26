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

@property (assign) NSInteger animationIndex;
@property (assign) NSInteger currentSelectIndex;

@property (nonatomic, strong) UIImageView* currentActivePai;
@property (nonatomic, strong) UIImageView* selectPaiBgView;
@property (nonatomic, strong) NSMutableArray* paiArray;
@property (nonatomic, strong) NSMutableArray* selectPaiArray;

@end

@implementation KENUiViewChouPai

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypeChouPai;
        
        _animationIndex = 1;
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
//        [imgView addSubview:pai];
        [self addSubview:pai];
        
        [_selectPaiArray addObject:pai];
    }
    _currentSelectIndex = 0;
    [self setSelectIndex];
    
    //
    _paiArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 22; i++) {
        UIImageView* pai = [[UIImageView alloc] initWithImage:image];
        pai.center = CGPointMake(160, 80);
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
    CGPoint locationInView = [(UIPanGestureRecognizer*)sender locationInView:self];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        for (int i = 0; i < [_paiArray count]; i++) {
            if (CGRectContainsPoint(((UIImageView*)[_paiArray objectAtIndex:i]).frame, locationInView) && ![[_paiArray objectAtIndex:i] isHidden]) {
                [self showActivePai:i];
                break;
            }
        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//        if (CGRectContainsPoint(((UIImageView*)[_selectPaiArray objectAtIndex:_currentSelectIndex]).frame, locationInView) || 1) {
            [self gestureStateEnd];
//        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        _currentActivePai.center = locationInView;
	}
}

-(void)gestureStateEnd{
    if (_currentActivePai) {
        _currentSelectIndex++;
        [self setSelectIndex];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
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
        [[_paiArray objectAtIndex:index] setHidden:YES];
        _currentActivePai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_pai_bg.png"]];
        _currentActivePai.center = ((UIImageView*)[_paiArray objectAtIndex:index]).center;
        [self addSubview:_currentActivePai];
    }
}

#pragma mark - animation
-(void)startAnimation{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        for (int i = 0; i < 22; i++) {
            UIImageView* view = [_paiArray objectAtIndex:i];
            view.center = CGPointMake(45, 50);
            
            view.transform = CGAffineTransformMakeRotation(45.0 / 180.0 * M_PI);
        }
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self startExpandAnimation];
                         }
                     }];
}

-(void)startExpandAnimation{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        float x = ((UIImageView*)[_paiArray objectAtIndex:_animationIndex - 1]).center.x;
        for (int i = _animationIndex; i < 22; i++) {
            int off = 4;
            if (_animationIndex <= 13 && _animationIndex >= 9) {
                off = 1;
            }
            int offy = _animationIndex > 11 ? -off : off;
            if (_animationIndex == 11) {
                offy = 0;
            }
            UIImageView* view = [_paiArray objectAtIndex:i];
            view.center = CGPointMake(x + 11, view.center.y + offy);
            
            view.transform = CGAffineTransformMakeRotation((45.0 - _animationIndex * 4)  / 180.0 * M_PI);
        }
        
        DebugLog(@"start postion ========>> _animationIndex = %d, center = (%.1f, %.1f)", _animationIndex,
                 ((UIImageView*)[_paiArray objectAtIndex:_animationIndex]).center.x, ((UIImageView*)[_paiArray objectAtIndex:_animationIndex]).center.y);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _animationIndex++;
                             if (_animationIndex < 22) {
                                 [self startExpandAnimation];
                             } else {
                                 [self autoChuoPai];
                             }
                         }
                     }];
}

-(void)autoChuoPai{
    if ([[KENModel shareModel] getPaiZhenAuto]) {
        NSArray* array = [[KENModel shareModel] getPaiZHenAutoIndex];
        if (_currentSelectIndex < [array count]) {
            int index = [[array objectAtIndex:_currentSelectIndex] intValue];
            [self showActivePai:index];
            [self gestureStateEnd];
        }
    }
}

-(void)stopAnimation{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _animationIndex = _animationIndex >= [_paiArray count] ? [_paiArray count] - 1 : _animationIndex;
        float x = ((UIImageView*)[_paiArray objectAtIndex:_animationIndex - 1]).center.x;
//        while ([[_paiArray objectAtIndex:_animationIndex - 1] isHidden]) {
//            
//        }
        for (int i = _animationIndex; i < 22; i++) {
            int off = 4;
            if (_animationIndex <= 13 && _animationIndex >= 9) {
                off = 1;
            }
            int offy = _animationIndex > 11 ? -off : off;
            if (_animationIndex == 10) {
                offy = 0;
            }
            UIImageView* view = [_paiArray objectAtIndex:i];
            view.center = CGPointMake(x, view.center.y - offy);
            
            view.transform = CGAffineTransformMakeRotation((45.0 - _animationIndex * 4)  / 180.0 * M_PI);
        }
        
        DebugLog(@"stop postion ---------->> _animationIndex = %d, center = (%.1f, %.1f)", _animationIndex,
                 ((UIImageView*)[_paiArray objectAtIndex:_animationIndex]).center.x, ((UIImageView*)[_paiArray objectAtIndex:_animationIndex]).center.y);
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _animationIndex--;
                             if (_animationIndex > 0) {
                                 [self stopAnimation];
                             } else {
                                 [self finishAnimation];
                             }
                         }
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
