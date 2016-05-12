//
//  KNEConfig.h
//  KENDivination
//
//  Created by 刘坤 on 14-5-12.
//  Copyright (c) 2014年 ken. All rights reserved.
//

#ifndef KENDivination_KNEConfig_h
#define KENDivination_KNEConfig_h

//#define KAppTest

#define kFullScreenAdaptiveY(a)          (IsPad ? (a) : ((a) / 480.f) * self.contentView.height)
#define kFullScreenAdaptiveX(a)          (IsPad ? ((a) / 320.f) * 360.f : (a))

#define IsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    //是否为pad判断
#define MyLocal(x, ...) NSLocalizedString(x, nil)       //定义国际化使用

//设备
#define isIPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size): NO)
#define isIPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone6               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334),[[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone6Plus           ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208),[[UIScreen mainScreen] currentMode].size) : NO)
#define isIPhone6PlusZoomIn     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001),[[UIScreen mainScreen] currentMode].size) : NO)

//日志输出定义
#ifdef DEBUG
#   define DebugLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DebugLog(...)
#endif

#define KSafeRelease(a)     if(a){delete a;a = nil;}

//颜色取值宏
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//取图片宏
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//取字典宏
#define LOADDIC(file,ext) [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//系统版本判断
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define KCellTag(a,b)           ((a) * 100 + (b) + 1000)

#define KPersonDesc(a)          [@"pare_daakana_" stringByAppendingFormat:@"%d", a]

//字体、字号、颜色
#define KLabelFontArial         @"Arial"
#define KLabelFontStd           @"Std"
#define KLabelFontHelvetica     @"Helvetica"

#define KNotificationHeight     (54)

#define KJiePaiKeyColor         RGBCOLOR(250,249,142)

#define KPaiCenter              CGPointMake(kFullScreenAdaptiveX(160.f), 110)


#define KUserDefaultSetOpenVoice                @"default_open_voice"
#define KUserDefaultJieMi                       @"default_jie_mi"
#define KUserDefaultAppBg                       @"default_app_bg"
#define KUserDefaultPaiBg                       @"default_pai_bg"

#define KUniqueTimeFormat                       @"yyyy-MM-dd HH:mm:ss"
#define KUniqueYMDFormat                        @"yyyy-MM-dd"
#define KUniqueHMSFormat                        @"HH:mm:ss"


//key
#define KDicKeyImg              @"key_img"
#define KDicKeyImgSec           @"key_img_sec"
#define KDicKeyJiaMi            @"key_jia_mi"
#define KDicKeyPaiZhen          @"key_pai_zhen"
#define KDicKeyZhenName         @"key_zhen_name"
#define KDicKeyZhenQuestion     @"key_question"
#define KDicKeyZhenNumber       @"key_zhen_number"
#define KDicKeyZhenPosSense     @"key_zhen_positon_sense"
#define KDicKeyZhenPosition     @"key_position"
#define KDicKeyZhenBgPath       @"key_bg_path"
#define KDicKeyZhenPaiPath      @"key_pai_path"
#define KDicKeyZhenAngle        @"key_angle"
#define KDicKeyZhenX            @"key_x"
#define KDicKeyZhenY            @"key_y"
#define KDicKeyZhenAuto         @"key_zhen_auto"
#define KDicKeyZhenAutoIndex    @"key_zhen_auto_index"
#define KDicKeyPaiMeaning       @"key_pai_meaning"
#define KDicKeyPaiWeiForword    @"key_forword"
#define KDicKeyPaiWeiReverse    @"key_ reverse"
#define KDicKeyPaiImg           @"key_pai_img"
#define KDicKeyPaiName          @"key_pai_name"
#define KDicKeyPaiKeyword       @"key_pai_keyword"
#define KDicKeyPaiPerson        @"key_person_name"

#define KDicPaiWei              @"pai_wei"
#define KDicPaiIndex            @"pai_index"

//define for server
#define KADIphoneId             @"225d09bd2ba644af9b39d1730b5bdcd0"     //90b5af94a09841cb92c9d7eef432f7c9,(ken) 225d09bd2ba644af9b39d1730b5bdcd0
#define KADIpadId               @"f01ac9ea7c1543e2b457a5d8b9f0dd18"

#define KIosZhHansItunesIP      @"https://itunes.apple.com/cn/app/jing-dian-ta-luo-zhan-bo/id880102242?l=zh&ls=1&mt=8"        //简体中文
#define KIosENItunesIP          @"https://itunes.apple.com/us/app/jing-dian-ta-luo-zhan-bo/id880102242?l=zh&ls=1&mt=8"        //英文、其他

#define SUB_PRODUCT_ID          @"teamqi.zhanbu.jiesuo"                 //内购id

#endif
