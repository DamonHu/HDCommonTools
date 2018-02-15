//
//  HDCommonTools+Multimedia.h
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HDCommonTools (Multimedia)

#pragma mark -
#pragma mark - 图像视频处理类

///将UIImage内容写入本地保存，重新命名，返回保存过的路径
- (NSString*)savedImagePathWithUIImage:(id)img WithFileName:(NSString*)fileName;

///压缩一张图片并返回
- (UIImage*)compressImage:(UIImage*)img WithQuality:(float)quality;

///图片压缩数组，返回压缩过的图片数组
- (NSArray*)compressImageArray:(NSArray*)imgArray WithQuality:(float)quality;


/**
 从视频中截取某一帧
 @param videoPath 视频的本地地址
 @param atTime 截取第几秒的一帧
 @return 返回截图
 */
- (UIImage*)getVideoPreViewImageFromVideoPath:(NSString*)videoPath withAtTime:(float)atTime;

///获取本地视频的时长
- (NSUInteger)durationWithVideo:(NSString *)videoPath;

///获取视频的分辨率
- (CGSize)sizeOfVideo:(AVAsset*)videoAsset;

///播放音效，是否震动
- (void)playEffect:(NSString*)effectName andShake:(BOOL)shouldShake;

/**
 播放音乐
 @param musicPath 音乐的地址
 */
-(void)playMusic:(NSString*)musicPath;
//停止音乐播放
-(void)stopMusic;

@end
