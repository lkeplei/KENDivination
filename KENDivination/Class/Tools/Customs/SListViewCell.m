//
//  SListViewCell.m
//  SPhoto
//
//  Created by SunJiangting on 12-8-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SListViewCell.h"
#import "KENConfig.h"
#import "KENDataManager.h"

@interface SListViewCell ()

@property (nonatomic, strong) UIImageView *selectedBgImageView;

@end

@implementation SListViewCell
@synthesize separatorView = _separatorView1;
@synthesize reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)thereuseIdentifier {
    self = [super init];
    if (self) {
        // Initialization code
        self.reuseIdentifier = thereuseIdentifier;
//        _separatorView1 = [[UIView alloc] init];
//        [_separatorView1 setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:_separatorView1];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (_selectedBgImageView) {
        [_selectedBgImageView setHidden:!selected];
    }
}

- (void)setSelectedBgImage:(UIImage *)selectedBgImage {
    _selectedBgImageView = [[UIImageView alloc] initWithImage:selectedBgImage];
    [_selectedBgImageView setHidden:YES];
    [self addSubview:_selectedBgImageView];
}

- (void)clearSubView {
    for (UIView *subview in [self subviews]) {
        if (subview != _separatorView1 || subview != self.contentView) {
            [subview removeFromSuperview];
        }
    }
}
@end
