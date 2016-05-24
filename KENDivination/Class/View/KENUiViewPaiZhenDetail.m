//
//  KENUiViewPaiZhenDetail.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-27.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENUiViewPaiZhenDetail.h"
#import "KENModel.h"
#import "KENUtils.h"
#import "KENConfig.h"

@interface KENUiViewPaiZhenDetail ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation KENUiViewPaiZhenDetail

- (id)initWithFrame:(CGRect)frame delegate:(KENViewPaiZhen*)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENUiViewTypePaiZhenDetail;
        self.delegate = delegate;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initTable];
}

#pragma mark - init area
- (void) initTable{
    if (IsPad) {
        float rate = [self.delegate getRateIPad];
        _tableView = [[UITableView alloc] initWithFrame:(CGRect){CGPointZero, self.frame.size.width, self.frame.size.height / rate}
                                                  style:UITableViewStylePlain];
    } else {
        _tableView = [[UITableView alloc] initWithFrame:(CGRect){CGPointZero, self.frame.size}
                                                  style:UITableViewStylePlain];
    }
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.showsVerticalScrollIndicator = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
	[self addSubview:_tableView];
    
    [_tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[KENModel shareModel] getPaiZhenNumber];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[KENModel shareModel] isLanguageEnglish]) {
        return [self getCellHeight:indexPath.row];
    } else {
        return 240.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"cell";
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        [self setKaPaiMessage:indexPath.row cell:cell];
    }
    
    return cell;
}

- (CGFloat)getCellHeight:(NSInteger)zhenWei {
    NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:zhenWei];
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
    
    float offx = 93 + 25 + 10;
    float width = 320 - offx - 20;
    
    UIFont* font = [UIFont fontWithName:KLabelFontArial size:13];
    CGSize size = [KENUtils getFontSize:@"Array" font:font];
    float lineHeight = (size.height + 1);
    int lines = 1;
    
    NSString *string = [MyLocal(@"kapai_daibiao") stringByAppendingString:[[KENModel shareModel] getPaiZhenDaiBiao:zhenWei]];
    size = [KENUtils getFontSize:string font:font];
    lines += size.width > width ? size.width / width + 1 : 1;
    if ([[KENModel shareModel] isLanguageEnglish]) {
        if (abs((int)size.width % (int)width - (int)width) < 70) {
            lines++;
        }
    } else {
        if (abs((int)size.width % (int)width - (int)width) < 20) {
            lines++;
        }
    }
    
    lines++;
    
    string = [MyLocal(@"kapai_guanjianzhi") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiKeyword]];
    size = [KENUtils getFontSize:string font:font];
    lines += size.width > width ? size.width / width + 1 : 1;
    if ([[KENModel shareModel] isLanguageEnglish]) {
        if (abs((int)size.width % (int)width - (int)width) < 70) {
            lines++;
        }
    } else {
        if (abs((int)size.width % (int)width - (int)width) < 20) {
            lines++;
        }
    }
    
    lines++;
    
    string = [MyLocal(@"kapai_jieyu") stringByAppendingString:[[KENModel shareModel] getPaiJieYu:zhenWei]];
    size = [KENUtils getFontSize:string font:font];
    lines += size.width > width ? size.width / width + 1 : 1;
    lines++;
    
    float height = lines * lineHeight + 40;
    return height > 240.f ? height : 240.f;
}

-(void)setKaPaiMessage:(NSInteger)zhenWei cell:(UITableViewCell*)cell{
    NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:zhenWei];
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
    UIImageView* kaPai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"m_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
    kaPai.center = CGPointMake(kaPai.frame.size.width / 2 + 25, kaPai.frame.size.height / 2 + 15);
    if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        kaPai.transform = CGAffineTransformMakeRotation(M_PI);
    }
    [cell addSubview:kaPai];
    
    UIFont* font = [UIFont fontWithName:KLabelFontArial size:13];
    //message
    float offx = CGRectGetMaxX(kaPai.frame) + 10;
    float width = kFullScreenAdaptiveX(320.f) - offx - 20;
    NSString* string = [MyLocal(@"kapai_zhenwei") stringByAppendingString:[KENUtils getStringByInt:zhenWei + 1]];
    CGSize size = [KENUtils getFontSize:string font:font];
    float height = (size.height + 1);
    UILabel* label = [self addLabel:string
                              frame:CGRectMake(offx, 15, width, height)
                               font:font index:MyLocal(@"kapai_zhenwei").length cell:cell];
    
    string = [MyLocal(@"kapai_daibiao") stringByAppendingString:[[KENModel shareModel] getPaiZhenDaiBiao:zhenWei]];
    size = [KENUtils getFontSize:string font:font];
    float lines = size.width > width ? size.width / width + 1 : 1;
    if ([[KENModel shareModel] isLanguageEnglish]) {
        if (abs((int)size.width % (int)width - (int)width) < 70) {
            lines++;
        }
    } else {
        if (abs((int)size.width % (int)width - (int)width) < 20) {
            lines++;
        }
    }
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)
                      font:font index:MyLocal(@"kapai_daibiao").length cell:cell];
    label.numberOfLines = 0;
    
    label = [self addLabel:[MyLocal(@"kapai_paiming") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiName]]
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)
                      font:font index:MyLocal(@"kapai_paiming").length cell:cell];
    
    string = [MyLocal(@"kapai_guanjianzhi") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiKeyword]];
    size = [KENUtils getFontSize:string font:font];
    lines = size.width > width ? size.width / width + 1 : 1;
    if ([[KENModel shareModel] isLanguageEnglish]) {
        if (abs((int)size.width % (int)width - (int)width) < 70) {
            lines++;
        }
    } else {
        if (abs((int)size.width % (int)width - (int)width) < 20) {
            lines++;
        }
    }
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1)
                      font:font index:MyLocal(@"kapai_guanjianzhi").length cell:cell];
    label.numberOfLines = 0;
    
    if ([[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_zheng")];
    } else {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_fan")];
    }
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height)
                      font:font index:MyLocal(@"kapai_paiwei").length cell:cell];
    
    string = [MyLocal(@"kapai_jieyu") stringByAppendingString:[[KENModel shareModel] getPaiJieYu:zhenWei]];
    size = [KENUtils getFontSize:string font:font];
    lines = size.width > width ? size.width / width + 1 : 1;
//    if (abs((int)size.width % (int)width - (int)width) < 20) {
        lines++;
//    }
    label = [self addLabel:string
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines)
                      font:font index:MyLocal(@"kapai_jieyu").length cell:cell];
    label.numberOfLines = 0;
}

-(UILabel*)addLabel:(NSString*)content frame:(CGRect)frame font:(UIFont*)font index:(int)index cell:(UITableViewCell*)cell{
    UILabel* label = [KENUtils labelWithTxt:content
                                      frame:frame
                                       font:font
                                      color:[UIColor whiteColor]];
    label.textAlignment = KTextAlignmentLeft;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    [str addAttribute:NSForegroundColorAttributeName value:KJiePaiKeyColor range:NSMakeRange(0, index)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(index, [content length] - index)];
    //    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
    label.attributedText = str;
    
    [cell addSubview:label];
    
    return label;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - btn clicked
-(void)btnClicked:(UIButton*)button{
    if (self.delegate) {
        [self.delegate jumpToFanPai];
    }
}

@end
