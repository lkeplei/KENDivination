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

#define IsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)    //是否为pad判断
#define MyLocal(x, ...) NSLocalizedString(x, nil)       //定义国际化使用

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

//字体、字号、颜色
#define KLabelFontArial         @"Arial"
#define KLabelFontStd           @"Std"
#define KLabelFontHelvetica     @"Helvetica"
#define KLabelFontSize12        (12)
#define KLabelFontSize14        (14)
#define KLabelFontSize16        (16)
#define KLabelFontSize18        (18)
#define KLabelFontSize22        (22)
#define KLabelFontSize36        (36)


#endif
