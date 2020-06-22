//
//  HDCommonDefine.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/23.
//  Copyright © 2018年 damon. All rights reserved.
//

/**
 *常用的宏定义CommonDefine
 *快捷实现常用功能
*/
#ifndef HDCommonDefine_h
#define HDCommonDefine_h

#pragma mark -
#pragma mark - 对象引用 Object reference
///弱引用 Weak reference
#define HDWEAKSELF __weak typeof(self) weakSelf = self
///强引用 Strong reference
#define HDSTRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf

#pragma mark -
#pragma mark - 界面 Interface
/*
 *  UIColor
 */
///16进制颜色转为UIColor
///16 Decimal color turn to UIColor
#define HDColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
///16进制颜色转为UIColor，设置透明度
///16 Decimal color turn to UIColor with alpha
#define HDColorFromRGBA(rgbValue, _A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:_A]
///通过数值转为UIColor
///Turn to UIColor by numerical value
#define HDColorWithRGB(_R,_G,_B)        ((UIColor *)[UIColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:1.0])
///通过数值转为UIColor，设置透明度
///Turn to UIColor by numerical value with alpha
#define HDColorWithRGBA(_R,_G,_B,_A)    ((UIColor *)[UIColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:_A])
/*
 *  Screen size
 */
//屏幕宽度
//ScreenWidth
#define HDScreenWidth   [UIScreen mainScreen].bounds.size.width
//屏幕高度
//ScreenHeight
#define HDScreenHeight  [UIScreen mainScreen].bounds.size.height

// 根据动态获取VC计算状态栏和tab的默认高度，如果不存在navigationbar或者tabbar的话，当前返回高度为0，可以使用下面默认高度
// 状态栏当前高度
// current status bar current height
#define HD_StatusBar_Height [UIApplication sharedApplication].statusBarFrame.size.height //状态栏高度
// 当前导航栏高度
// current height of the navigation bar
#define HD_NavigationBar_Height self.navigationController.navigationBar.frame.size.height
// tabBar当前高度
//current height of the tabBar
#define HD_TabBar_Height self.tabBarController.tabBar.frame.size.height

// 根据系统组件计算状态栏和tab的默认高度
// 导航栏默认高度
//Default height of the navigation bar
#define HD_Default_NavigationBar_Height [[UINavigationController alloc] init].navigationBar.frame.size.height
// tabBar默认高度
//Default height of the tabBar
#define HD_Default_Tabbar_Height [[UITabBarController alloc] init].tabBar.frame.size.height
//状态栏和导航栏默认总高度
//Status bar and navigation bar default total height
#define HD_Default_Nav_And_Status_Height (HD_Default_NavigationBar_Height + HD_StatusBar_Height)
#endif /* HDCommonDefine_h */
