//
//  KENViewPaiZhenDetail.m
//  KENDivination
//
//  Created by 刘坤 on 14-5-27.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#import "KENViewPaiZhenDetail.h"
#import "KENModel.h"
#import "KENUtils.h"
#import "KENConfig.h"

@interface KENViewPaiZhenDetail ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation KENViewPaiZhenDetail

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = KENViewTypePaiZhenDetail;
    }
    return self;
}

#pragma mark - init area
- (void) initTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNotificationHeight,
                                                               self.contentView.frame.size.width,
                                                               self.contentView.frame.size.height - KNotificationHeight)
                                              style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.showsVerticalScrollIndicator = YES;
    _tableView.rowHeight = 240;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableView setBackgroundView:nil];
    [_tableView setBackgroundColor:[UIColor clearColor]];
	[self.contentView addSubview:_tableView];
    
    [_tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[KENModel shareModel] getPaiZhenNumber];
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

-(void)setKaPaiMessage:(NSInteger)zhenWei cell:(UITableViewCell*)cell{
    NSDictionary* paiMessage = [[KENModel shareModel].memoryData getPaiAndPaiWei:zhenWei];
    NSDictionary* messageDic = [[KENModel shareModel] getKaPaiMessage:[[paiMessage objectForKey:KDicPaiIndex] intValue]];
    UIImageView* kaPai = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[@"m_" stringByAppendingString:[messageDic objectForKey:KDicKeyPaiImg]]]];
    kaPai.center = CGPointMake(kaPai.frame.size.width / 2 + 25, kaPai.frame.size.height / 2 + 15);
    if (![[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        kaPai.transform = CGAffineTransformMakeRotation(M_PI);
    }
    [cell addSubview:kaPai];
    
    //message
    float offx = CGRectGetMaxX(kaPai.frame) + 10;
    float width = cell.frame.size.width - offx - 20;
    NSString* string = [MyLocal(@"kapai_zhenwei") stringByAppendingString:[KENUtils getStringByInt:zhenWei + 1]];
    CGSize size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    float height = (size.height + 1);
    UILabel* label = [self addLabel:string frame:CGRectMake(offx, 15, width, height) cell:cell];
    
    string = [MyLocal(@"kapai_daibiao") stringByAppendingString:[[KENModel shareModel] getPaiZhenDaiBiao:zhenWei]];
    size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    float lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1) cell:cell];
    label.numberOfLines = lines > 1 ? 0 : 1;
    
    label = [self addLabel:[MyLocal(@"kapai_paiming") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiName]]
                     frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height) cell:cell];
    
    string = [MyLocal(@"kapai_guanjianzhi") stringByAppendingString:[messageDic objectForKey:KDicKeyPaiKeyword]];
    size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1) cell:cell];
    label.numberOfLines = lines > 1 ? 0 : 1;
    
    if ([[paiMessage objectForKey:KDicPaiWei] boolValue]) {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_zheng")];
    } else {
        string = [MyLocal(@"kapai_paiwei") stringByAppendingString:MyLocal(@"kapai_paiwei_fan")];
    }
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height) cell:cell];
    
    string = [MyLocal(@"kapai_jieyu") stringByAppendingString:[[KENModel shareModel] getPaiJieYu:zhenWei]];
    size = [KENUtils getFontSize:string font:[UIFont fontWithName:KLabelFontArial size:12]];
    lines = size.width > width ? size.width / width + 1 : 1;
    label = [self addLabel:string frame:CGRectMake(offx, CGRectGetMaxY(label.frame), width, height * lines - lines + 1) cell:cell];
    label.numberOfLines = 0;
}

-(UILabel*)addLabel:(NSString*)content frame:(CGRect)frame cell:(UITableViewCell*)cell{
    UILabel* label = [KENUtils labelWithTxt:content
                                      frame:frame
                                       font:[UIFont fontWithName:KLabelFontArial size:12]
                                      color:[UIColor whiteColor]];
    label.textAlignment = KTextAlignmentLeft;
    [cell addSubview:label];
    
    return label;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - others
-(UIImage*)setViewTitleImage{
    return [[KENModel shareModel] getPaiZhenTitle];
}

-(void)showView{
    UIButton* setBtn = [KENUtils buttonWithImg:nil off:0 zoomIn:NO
                                         image:[UIImage imageNamed:@"app_btn_paizhen.png"]
                                      imagesec:[UIImage imageNamed:@"app_btn_paizhen_sec.png"]
                                        target:self
                                        action:@selector(btnClicked:)];
    setBtn.center = CGPointMake(288, KNotificationHeight / 2);
    [self.contentView addSubview:setBtn];
    
    [self initTable];
}

#pragma mark - btn clicked
-(void)btnClicked:(UIButton*)button{
    [self popView:KENTypeNull];
}

@end
