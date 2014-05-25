//
//  KENUiViewChouPai.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-22.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewChouPai.h"

@interface KENUiViewChouPai ()

@property (assign) NSInteger animationIndex;
@property (assign) NSInteger currentSelectIndex;
@property (assign) NSInteger touchIndex;
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
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chou_pai_bg.png"]];
    imgView.center = CGPointMake(160, 260);
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
    _selectPaiArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        UIImageView* pai = [[UIImageView alloc] initWithImage:image];
        pai.center = CGPointMake(offset + space / 2 + width * i + imgView.frame.origin.x,
                                 imgView.frame.size.height / 2 + imgView.frame.origin.y);
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
        pai.center = CGPointMake(40, 90);
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
	UIPanGestureRecognizer* panGestureRecongnize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
	[panGestureRecongnize setMinimumNumberOfTouches:1];
	[panGestureRecongnize setMaximumNumberOfTouches:1];
    [self setUserInteractionEnabled:YES];
	[self addGestureRecognizer:panGestureRecongnize];
}

-(void)movePanel:(id)sender {
    CGPoint locationInView = [(UIPanGestureRecognizer*)sender locationInView:self];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        for (int i = 0; i < [_paiArray count]; i++) {
            if (CGRectContainsPoint(((UIImageView*)[_paiArray objectAtIndex:i]).frame, locationInView)) {
                _touchIndex = i;
                break;
            }
        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        if (CGRectContainsPoint(((UIImageView*)[_selectPaiArray objectAtIndex:_currentSelectIndex]).frame, locationInView) || 1) {
            [self gestureStateEnd];
        }
	}
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        ((UIImageView*)[_paiArray objectAtIndex:_touchIndex]).center = locationInView;
	}
}

-(void)gestureStateEnd{
    _currentSelectIndex++;
    [self setSelectIndex];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        ((UIImageView*)[_paiArray objectAtIndex:_touchIndex]).center = ((UIImageView*)[_selectPaiArray objectAtIndex:_currentSelectIndex - 1]).center;
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                     }];
    
    
    
    if (_currentSelectIndex >= [_selectPaiArray count]) {
        [self stopAnimation];
    }
}

#pragma mark - animation
-(void)startAnimation{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        float x = ((UIImageView*)[_paiArray objectAtIndex:_animationIndex - 1]).center.x;
        for (int i = _animationIndex; i < 22; i++) {
            UIImageView* view = [_paiArray objectAtIndex:i];
            view.center = CGPointMake(x + 11, view.center.y);
        }
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _animationIndex++;
                             if (_animationIndex < 22) {
                                 [self startAnimation];
                             }
                         }
                     }];
}

-(void)stopAnimation{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        float x = ((UIImageView*)[_paiArray objectAtIndex:_animationIndex - 1]).center.x;
        for (int i = _animationIndex; i < 22; i++) {
            UIImageView* view = [_paiArray objectAtIndex:i];
            view.center = CGPointMake(x, view.center.y);
        }
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
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
    }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self.delegate showViewWithType:KENUiViewTypeStartFanPai];
                         }
                     }];
}
@end
