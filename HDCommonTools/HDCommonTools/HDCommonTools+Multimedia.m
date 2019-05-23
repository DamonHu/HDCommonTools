//
//  HDCommonTools+Multimedia.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+Multimedia.h"

AVPlayer *avPlayer = nil;
AVPlayer *avRepeatPlayer = nil;
NSObject *avPlayerObserver = nil;
NSObject *avRepeatPlayerObserver = nil;
BOOL repeatEffectShark = false;
SystemSoundID m_soundID;

@implementation HDCommonTools (Multimedia)
#pragma mark -
#pragma mark - 图像视频处理类

///将UIImage内容写入本地保存，重新命名，返回保存过的路径
//Write the UIImage content to local save, rename, and return the saved path
- (NSString *)saveImage:(id)img withFileName:(NSString *)fileName {
    NSData *imagedata = UIImagePNGRepresentation(img);
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:fileName];
    [imagedata writeToFile:savedImagePath atomically:YES];
    return savedImagePath;
}

///压缩一张图片并返回
//Compress a picture and return
- (UIImage *)compressImage:(UIImage *)img withQuality:(float)quality {
    NSData *data = UIImageJPEGRepresentation(img, quality);
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

///图片压缩数组，返回压缩过的图片数组
//The picture compresses the array, returns the compressed array of pictures
- (NSArray *)compressImageArray:(NSArray *)imgArray withQuality:(float)quality {
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<imgArray.count; i++) {
        UIImage *img = [imgArray objectAtIndex:i];
        UIImage *compressImg = [self compressImage:img withQuality:quality];
        if (!compressImg) {
            [array addObject:img];
        } else {
            [array addObject:compressImg];
        }
    }
    return array;
}

/**
 从视频中截取某一帧  Intercept a frame from the video
 @param videoLocalPath 视频的本地地址 The local address of the video
 @param frametime 截取第几秒的一帧  Intercepting a frame of a second
 @return 返回截图 Return screenshot
 */
- (UIImage *)getVideoPreViewImageWithVideoLocalPath:(NSString *)videoLocalPath withFrametime:(float)frametime {
    if (!videoLocalPath) {
        return nil;
    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoLocalPath] options:nil];
    if ([asset tracksWithMediaType:AVMediaTypeVideo].count == 0) {
        return nil;
    }
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //    gen.appliesPreferredTrackTransform = YES;
    //    gen.requestedTimeToleranceAfter = kCMTimeZero;
    //    gen.requestedTimeToleranceBefore = kCMTimeZero;
    CMTime time = CMTimeMakeWithSeconds(frametime, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    UIGraphicsBeginImageContext(CGSizeMake([[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].width, [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].height));//asset.naturalSize.width, asset.naturalSize.height)
    [img drawInRect:CGRectMake(0, 0, [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].width, [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] naturalSize].height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(image);
    return scaledImage;
}

///获取本地视频的时长
//Get the length of the local video
- (NSUInteger)getDurationWithVideoLocalPath:(NSString *)videoLocalPath {
    if (!videoLocalPath || videoLocalPath.length == 0) {
        NSAssert(NO, @"videoPath is error");
        return 0;
    }
    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videoLocalPath] options:opts];     //初始化视频媒体文件
    NSUInteger second = 0;
    second = ceilf((double)urlAsset.duration.value / (double)urlAsset.duration.timescale); // 获取视频总时长,单位秒
    return second;
}

///获取视频的分辨率
//Obtaining the resolution of video
- (CGSize)getSizeOfVideoAsset:(AVAsset*)videoAsset {
    if (videoAsset && [videoAsset tracksWithMediaType:AVMediaTypeVideo].count>0) {
        AVAssetTrack *track = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        CGSize dimensions = CGSizeMake(fabs(CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform).width), fabs(CGSizeApplyAffineTransform(track.naturalSize, track.preferredTransform).height));
        return dimensions;
    } else {
        return CGSizeMake(0, 0);
    }
}

///播放音效，是否震动
//Play sound effects, set up vibration
- (void)playEffectWithLocalFilePath:(NSString *)effectLocalFilePath withShake:(BOOL)shake {
    // 加载音效文件并创建 SoundID
    SystemSoundID soundID = 0;
    // 获取音频文件路径
    if (effectLocalFilePath.length) {
        NSURL *url = [NSURL fileURLWithPath:effectLocalFilePath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    } else if (shake) {
        soundID = kSystemSoundID_Vibrate;
    }
    
    // 设置播放完成回调
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    // 播放音效
    if (shake) {
        // 带有震动
        AudioServicesPlayAlertSound(soundID);
    }else{
        // 无振动
        AudioServicesPlaySystemSound(soundID);
    }
}

/**
 *  播放完成回调函数
 *
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    // 销毁 SoundID
    AudioServicesDisposeSystemSoundID(soundID);
}

///循环播放音效，是否震动
//Play sound effects repeat, set up vibration
- (void)playEffectRepeatWithLocalFilePath:(NSString *)effectLocalFilePath withShake:(BOOL)shake {
    // 加载音效文件并创建 SoundID
    SystemSoundID soundID = 0;
    // 获取音频文件路径
    if (effectLocalFilePath.length) {
        NSURL *url = [NSURL fileURLWithPath:effectLocalFilePath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    } else if (shake) {
        soundID = kSystemSoundID_Vibrate;
    }
    // 设置播放完成回调
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, repeatSoundCompleteCallback, NULL);
    repeatEffectShark = shake;
    m_soundID = soundID;
    // 播放音效
    if (shake) {
        // 带有震动
        AudioServicesPlayAlertSound(soundID);
    }else{
        // 无振动
        AudioServicesPlaySystemSound(soundID);
    }
}

void repeatSoundCompleteCallback(SystemSoundID soundID,void * clientData){
    // 播放音效
    if (repeatEffectShark) {
        // 带有震动
        AudioServicesPlayAlertSound(soundID);
    }else{
        // 无振动
        AudioServicesPlaySystemSound(soundID);
    }
}

//关闭循环播放音效
// stop the playing repeat effect
- (void)stopPlayEffectRepeat {
    if (m_soundID || m_soundID == kSystemSoundID_Vibrate) {
        AudioServicesDisposeSystemSoundID(m_soundID);
        AudioServicesRemoveSystemSoundCompletion(m_soundID);
        repeatEffectShark = false;
        m_soundID = 0;
    }
}

/**
 播放音乐 Play music
 @param musicPath 音乐的地址,可以是本地地址，也可以是网络地址 The address of the music，available with localFilePath and network address
 @param repeat 是否循环播放 should play music repeat
 */
- (void)playMusicWithMusicFilePath:(NSString *)musicPath withRepeat:(BOOL)repeat {
    NSURL *musicUrl = [[HDCommonTools sharedHDCommonTools] urlCreatedByString:musicPath];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:musicUrl];
    if (!avPlayer) {
        avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
    } else {
        [avPlayer replaceCurrentItemWithPlayerItem:item];
    }
    if (avRepeatPlayer) {
        if (avRepeatPlayerObserver) {
            [avRepeatPlayer removeTimeObserver:avRepeatPlayerObserver];
            avRepeatPlayerObserver = nil;
        }
        [avRepeatPlayer pause];
        avRepeatPlayer = nil;
    }
    if (avPlayerObserver) {
        [avPlayer removeTimeObserver:avPlayerObserver];
        avPlayerObserver = nil;
    }
    if (repeat) {
        //第一个
        avPlayerObserver = [avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1000.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            CGFloat duration =  CMTimeGetSeconds(avPlayer.currentItem.duration); //视频总时间
            CGFloat currentTime = CMTimeGetSeconds(time);//视频当前运行时间
                        NSLog(@"第一个准备好播放了，总时间：%f,%f",duration,currentTime);
            if (duration > 0 && currentTime > 0) {
                if (currentTime >= duration - 0.25) {
                    if (avRepeatPlayer) {
                        [avRepeatPlayer play];
                    }
                }
                if (currentTime >= duration - 0.1) {
                    [item seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                        if (finished) {
                            [avPlayer seekToTime:kCMTimeZero];
                            [avPlayer pause];
                        }
                    }];
                }
            }
            
        }];
        //新建一个重复的去提前播放
        AVPlayerItem *item2 = [AVPlayerItem playerItemWithURL:musicUrl];
        if (!avRepeatPlayer) {
            avRepeatPlayer = [[AVPlayer alloc] initWithPlayerItem:item2];
        } else {
            [avRepeatPlayer replaceCurrentItemWithPlayerItem:item2];
        }
        avRepeatPlayerObserver = [avRepeatPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1000.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            CGFloat duration =  CMTimeGetSeconds(avRepeatPlayer.currentItem.duration); //视频总时间
            CGFloat currentTime = CMTimeGetSeconds(time);//视频当前运行时间
                        NSLog(@"第二个准备好播放了，总时间：%f,%f",duration,currentTime);
            if (duration > 0 && currentTime > 0) {
                if (currentTime >= duration - 0.25) {
                    if (avPlayer) {
                        [avPlayer play];
                    }
                }
                if (currentTime >= duration - 0.1) {
                    [item2 seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                        if (finished) {
                            [avRepeatPlayer seekToTime:kCMTimeZero];
                            [avRepeatPlayer pause];
                        }
                    }];
                    
                }
            }
        }];
    } else {
        if (avPlayerObserver) {
            [avPlayer removeTimeObserver:avPlayerObserver];
            avPlayerObserver = nil;
        }
        if (avRepeatPlayerObserver) {
            [avRepeatPlayer removeTimeObserver:avRepeatPlayerObserver];
            avRepeatPlayerObserver = nil;
        }
    }
    if (avPlayer) {
        [avPlayer seekToTime:kCMTimeZero];
        [avPlayer play];
    }
}

//停止音乐播放 Stop playing music
- (void)stopMusic {
    if (avPlayer) {
        [avPlayer pause];
    }
    if (avRepeatPlayer) {
        [avRepeatPlayer pause];
    }
}
@end
