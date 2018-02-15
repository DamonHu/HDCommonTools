//
//  HDCommonTools+Multimedia.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+Multimedia.h"

AVPlayer *avPlayer;
@implementation HDCommonTools (Multimedia)
#pragma mark -
#pragma mark - 图像视频处理类

///将UIImage内容写入本地保存，重新命名，返回保存过的路径
- (NSString*)savedImagePathWithUIImage:(id)img WithFileName:(NSString*)fileName{
    NSData *imagedata = UIImagePNGRepresentation(img);
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:fileName];
    [imagedata writeToFile:savedImagePath atomically:YES];
    return savedImagePath;
}

///压缩一张图片并返回
- (UIImage*)compressImage:(UIImage*)img WithQuality:(float)quality{
    NSData *data = UIImageJPEGRepresentation(img, quality);
    UIImage*image = [UIImage imageWithData:data];
    return image;
}

///图片压缩数组，返回压缩过的图片数组
- (NSArray*)compressImageArray:(NSArray*)imgArray WithQuality:(float)quality{
    NSMutableArray*array = [NSMutableArray array];
    for (int i=0; i<imgArray.count; i++) {
        UIImage*img = [imgArray objectAtIndex:i];
        UIImage*compressImg = [self compressImage:img WithQuality:quality];
        if (!compressImg) {
            [array addObject:img];
        }
        else{
            [array addObject:compressImg];
        }
    }
    return array;
}


/**
 从视频中截取某一帧
 @param videoPath 视频的本地地址
 @param atTime 截取第几秒的一帧
 @return 返回截图
 */
- (UIImage*)getVideoPreViewImageFromVideoPath:(NSString*)videoPath withAtTime:(float)atTime{
    if (!videoPath) {
        return nil;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count == 0) {
        return nil;
    }
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //    gen.appliesPreferredTrackTransform = YES;
    //    gen.requestedTimeToleranceAfter = kCMTimeZero;
    //    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(atTime, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    //    UIGraphicsBeginImageContext(CGSizeMake(YZScreenSize.width, YZScreenSize.height));
    //    [img drawInRect:CGRectMake(0, 0, YZScreenSize.width, YZScreenSize.height)];
    UIGraphicsBeginImageContext(CGSizeMake([[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].width, [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].height));//asset.naturalSize.width, asset.naturalSize.height)
    [img drawInRect:CGRectMake(0, 0, [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].width, [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(image);
    return scaledImage;
}

///获取本地视频的时长
- (NSUInteger)durationWithVideo:(NSString *)videoPath{
    if (!videoPath || videoPath.length == 0) {
        NSAssert(NO, @"视频地址错误");
        return 0;
    }
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoPath] options:opts];     //初始化视频媒体文件
    NSUInteger second = 0;
    second = ceilf((double)urlAsset.duration.value / (double)urlAsset.duration.timescale); // 获取视频总时长,单位秒
    return second;
}

///获取视频的分辨率
- (CGSize)sizeOfVideo:(AVAsset*)videoAsset{
    if (videoAsset && [videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) {
        AVAssetTrack *track = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        CGSize dimensions = CGSizeMake(fabs(CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform).width), fabs(CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform).height));
        return dimensions;
    }
    else{
        return CGSizeMake(0, 0);
    }
}

///播放音效
- (void)playEffect:(NSString*)effectName andShake:(BOOL)shouldShake{
    // 获取音频文件路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%@",effectName] withExtension:nil];
    
    // 加载音效文件并创建 SoundID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    
    // 设置播放完成回调
    //    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, nil, NULL);
    
    // 播放音效
    if (shouldShake) {
        // 带有震动
        AudioServicesPlayAlertSound(soundID);
    }else{
        // 无振动
        AudioServicesPlaySystemSound(soundID);
    }
    // 销毁 SoundID
    //    AudioServicesDisposeSystemSoundID(_soundID);
}

/**
 播放音乐
 @param musicPath 音乐的地址
 */
-(void)playMusic:(NSString*)musicPath{
    NSURL *musicUrl;
    if ([musicPath hasPrefix:@"http"]||[musicPath hasPrefix:@"https://"]) {
        musicUrl = [NSURL URLWithString:musicPath];
    }else{
        musicUrl = [NSURL fileURLWithPath:musicPath];
    }
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:musicUrl];
    avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
    if (avPlayer) {
        [avPlayer play];
    }
}
//停止音乐播放
-(void)stopMusic{
    if (avPlayer) {
        [avPlayer pause];
    }
}
@end
