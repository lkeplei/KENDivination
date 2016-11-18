//
//  BaiduMobAdDubao.m
//  BaiduMobAdSDK
//
//  Created by baidu on 16/7/24.
//  Copyright © 2016年 Baidu Inc. All rights reserved.
//

#import "BaiduMobAdDubao.h"
#import "BaiduMobAdFrontlinkSlot.h"
#import "BaiduMobAdCommonConfig.h"

@interface BaiduMobAdDubao ()
@property (nonatomic, retain) BaiduMobAdFrontlinkSlot *slot;
@end

@implementation BaiduMobAdDubao

- (id)init {
    if (self = [super init]) {
        _slot = [[BaiduMobAdFrontlinkSlot alloc]init];
        [self buildCallbackBlock];
    }
    return self;
}
- (void)setPosition:(BaiduMobAdDubaoPosition)style marginPercent:(double)percent
{
    _slot.marginPercent = percent;
    switch (style) {
        case BaiduMobAdDubaoPositionLeft:
            _slot.isLeft = YES;
            break;
        case BaiduMobAdDubaoPositionRight:
            _slot.isLeft = NO;
            
        default:
            break;
    }
}
-(void)showAd {
    [self buildSlotInfo:_slot];
    [_slot start];
}

- (void)buildCallbackBlock {
    _slot.finishDisplayAdBlock = ^(NSDictionary *dic) {
        [self destroy];
    };
}

- (BaiduMobAdFrontlinkSlot *)buildSlotInfo: (BaiduMobAdFrontlinkSlot *)slot {
    slot.publisherId = [self publisherId];
    slot.adId = self.AdUnitTag;
    slot.enableLocation = [self enableLocation];
    return slot;
}

- (NSString *)publisherId {
    NSString *publisherId = @"";
    if ([self.delegate respondsToSelector:@selector(publisherId)] &&
        [self.delegate publisherId]) {
        publisherId = [self.delegate publisherId];
    }
    return publisherId;
}

- (BOOL)enableLocation {
    if ([self.delegate respondsToSelector:@selector(enableLocation)] == YES) {
        return [self.delegate enableLocation];
    } else {
        return NO;
    }
}
- (void)destroy
{
    [_slot destroy];
}

@end
