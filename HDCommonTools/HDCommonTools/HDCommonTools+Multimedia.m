//
//  HDCommonTools+Multimedia.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/15.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "HDCommonTools+Multimedia.h"
#import "HDCommonTools+Encrypt.h"
#import "HDCommonTools+FileHandle.h"

AVAudioPlayer *avPlayer = nil;
BOOL vibrateRepeat = false;  //标记是否循环震动

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
    
    // 播放音效
    if (shake) {
        // 带有震动
        AudioServicesPlayAlertSoundWithCompletion(soundID, ^{});
    }else{
        // 无振动
        AudioServicesPlaySystemSoundWithCompletion(soundID, ^{});
    }
}

- (void)playMusicWithMusicFilePath:(NSString *)musicPath withRepeat:(BOOL)repeat {
    [self playMusicWithMusicFilePath:musicPath withRepeat:repeat withCategory:AVAudioSessionCategoryPlayback];
}

- (void)playMusicWithMusicFilePath:(NSString *)musicPath withRepeat:(BOOL)repeat withCategory:(AVAudioSessionCategory)audioSessionCategory {
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放
    [audioSession setCategory:audioSessionCategory error:nil];
    [audioSession setActive:YES error:nil];
    
    [avPlayer stop];
    
    if (![[HDCommonTools sharedHDCommonTools] isLocalURLLink:musicPath]) {
        NSString *name = [[HDCommonTools sharedHDCommonTools] MD5EncryptWithString:musicPath withLowercase:true];
         NSURL *path = [[[HDCommonTools sharedHDCommonTools] createFileDirectoryWithType:kHDFileDirectoryTypeCaches andDirectoryName:@"music"] URLByAppendingPathComponent:name isDirectory:false];
        NSData * audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:musicPath]];
        [audioData writeToURL:path atomically:true];
        musicPath = path.path;
    }
    
    NSURL *musicUrl = [[HDCommonTools sharedHDCommonTools] urlCreatedByString:musicPath];
    avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
    if (repeat) {
        avPlayer.numberOfLoops = -1;
    } else {
        avPlayer.numberOfLoops = 0;
    }
    [avPlayer play];
}

//停止音乐播放 Stop playing music
- (void)stopMusic {
    [avPlayer stop];
}

//开始震动
- (void)startVibrateWithRepeat:(BOOL)repeat; {
    vibrateRepeat = repeat;
    if (repeat) {
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
            [self startVibrateWithRepeat: vibrateRepeat];
        });
    } else {
        AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, ^{
            
        });
    }
}

//结束震动
- (void)stopVibrate {
    vibrateRepeat = false;
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
}
@end
