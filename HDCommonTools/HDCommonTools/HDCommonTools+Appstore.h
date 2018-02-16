//
//  HDCommonTools+Appstore.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/16.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"
#import "HDCommonToolsConfig.h"
#import <StoreKit/StoreKit.h>

@interface HDCommonTools (Appstore)<SKStoreProductViewControllerDelegate>

#pragma mark -
#pragma mark - Appstore相关操作类

/**
 打开appstore的预览下载页面
 @param appleID 指定软件的appid，在itunes后台可以看到
 @param jumpStoreType 跳转到appstore样式类型
 */
-(void)jumpStoreWithAppleID:(NSString*)appleID withType:(HDJumpStoreType)jumpStoreType;

/**
 好评弹窗
 @param appleID 评分的appid，在itunes后台可以看到。
 如果选择了kHDScoreTypeInApp，或者kHDScoreTypeAuto在10.3版本情况下，appldid无效，自动弹出就是自己app的评分
 @param scoreType 评分样式类型
 */
-(void)giveScoreWithAppleID:(NSString*)appleID withType:(HDScoreType)scoreType;


@end
