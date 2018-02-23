![](./HDCommonTool.png)

# HDCommonTools

一句代码即可实现多种常用功能，根据数据处理、文件管理、多媒体管理、权限管理、系统信息、Appstore操作等几种不同的类型封装不同的Category，同时可以通过调用不同的函数去使用。

## 一、导入项目

该工具可以使用cocoapods导入，也可以通过下载源文件导入。

### 通过cocoapods导入

```
pod 'HDCommonTools'
```
### 通过文件导入

下载项目，将项目文件下的HDCommonTools文件夹里面的内容导入项目即可

## 二、函数使用

两步即可调用所有函数功能

### 1、导入头文件

```
#import "HDCommonHeader.h"
```
### 2、通过单例调用即可
```
///获取手机的语言设置
[[HDCommonTools sharedHDCommonTools] getIOSLanguage];
///申请gps权限
[[HDCommonTools sharedHDCommonTools] getGPSLibraryWithType:kHDGPSPermissionWhenInUse];
...
```
### 3、权限通知说明
在申请权限的过程，在返回结果的时候会触发通知

```
///系统权限授权变化通知
FOUNDATION_EXPORT NSString * const HDPermissionStatusDidChangeNotification;
///系统变化通知中的userinfo的key，标记名字
FOUNDATION_EXPORT NSString * const HDPermissionNameItem;
///系统变化通知中的userinfo的key，标记状态
FOUNDATION_EXPORT NSString * const HDPermissionStatusItem;
```

以申请gps权限为例

```
- (void)viewDidLoad {
    [super viewDidLoad];
    ///注册权限回调通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionNotifacation:) name:HDPermissionStatusDidChangeNotification object:nil];
    ///申请gps权限
    [[HDCommonTools sharedHDCommonTools] getGPSLibraryWithType:kHDGPSPermissionWhenInUse];
}

-(void)permissionNotifacation:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    if ([[userInfo objectForKey:HDPermissionNameItem] integerValue] == kHDPermissionNameGPS) {
        if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorized) {
            NSLog(@"用户允许访问gps");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorRestricted){
            NSLog(@"用户被限制访问gps");
        }else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDNotDetermined){
            NSLog(@"用户尚未选择是否允许访问gps");
        }else{
            NSLog(@"用户不允许访问gps");
        }
    }
}
```

为了更加清晰的使用，完善了demo，demo中每一类用法都加了使用方法。

![](./demo.png)

## 三、文件结构
|文件名|文件作用|
|----|----|
|HDCommonHeader.h|包含所有头文件|
|HDCommonDefine.h|快捷处理的宏定义|
|HDCommonToolsConfig|项目定义的枚举类型|
|HDCommonTools|数据处理函数|
|HDCommonTools+FileHandle|文件处理函数|
|HDCommonTools+Multimedia|多媒体文件处理函数|
|HDCommonTools+Permission|权限管理和申请函数|
|HDCommonTools+SystemInfo|手机系统信息及项目信息函数|
|HDCommonTools+Appstore|appstore相关操作函数|

## 四、所有功能

```
#pragma mark -
#pragma mark - 数据处理类
/// 将字典或者数组转化为Data数据
- (NSData *)toJSONData:(id)theData;

/// 将字典或者数组转化为json字符串数据
- (NSString *)toJSONStr:(id)theData;

/// 将JSON Data串转化为字典或者数组
- (id)DataToArrayOrNSDictionary:(NSData *)jsonData;

/// 将JSON串转化为字典或者数组
- (id)StrToArrayOrNSDictionary:(NSString *)jsonStr;

///NSArray转为NSString
- (NSString*)ArrayToString:(NSArray*)array;

///NSString通过指定的分割符转为NSArray，如果symbol为空，则默认为","
- (NSArray*)StringToArray:(NSString*)str bySymbol:(NSString*)symbol;

///unicode转换为中文
- (NSString*)convertUnicodeString:(NSString*)unicodeStr;

///从指定文件名文件获取json内容
- (id)getJsonDataFromFileName:(NSString*)jsonName;

///字符串MD5加密
- (NSString*)getMD5withStr:(NSString*)str;

///获取当前时间的时间戳
- (NSString*)getCurrentTimeStamp;

///获取指定时间的时间戳
- (NSString*)getTimeStampByDate:(NSDate*)date;

/**
 时间戳获取时间
 
 @param timeStamp 时间戳
 @param quickType 快速格式化时间，如果传None则自己定义foramatter
 @param formatter 自己定义foramatter
 @return 格式化过的时间
 */
- (NSString*)getTimeFromTimeStamp:(NSString*)timeStamp andQuickFormatType:(HDQuickFormatType)quickType orCustomFormatter:(NSDateFormatter*)formatter;

#pragma mark -
#pragma mark - 文件处理管理类

///将Data内容写入本地保存，重新命名，返回保存过的路径
- (NSString*)savedPathWithData:(NSData*)data WithFileName:(NSString*)fileName;

///在Document创建子文件夹
-(NSString*)createFolder:(NSString*)folderName;

///检查文件夹下是否有指定文件名文件
-(BOOL)isExistFileWithName:(NSString*)fileName InFolder:(NSString*)folderName;

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

#pragma mark -
#pragma mark - 权限类
///是否有麦克风权限
- (HDPrivatePermissionStatus)hasAVMediaTypeAudio;

///是否有拍照权限
- (HDPrivatePermissionStatus)hasAVMediaTypeVideo;

///是否有相册权限
- (HDPrivatePermissionStatus)hasPhotoLibrary;

///是否有定位权限
- (HDPrivatePermissionStatus)hasGPSLibrary;

///申请定位权限
-(void)getGPSLibraryWithType:(HDGPSPermissionType)GPSPermissionType;

///申请麦克风权限
- (void)getAVMediaTypeAudio;

///申请拍照权限
-(void)getAVMediaTypeVideo;

///申请相册权限
- (void)getPhotoLibrary;

///打开系统设置
- (void)openSetting;

#pragma mark -
#pragma mark - 系统信息类
///软件版本
- (NSString*)getAppVersion;

///工程的build版本
- (NSString*)getAppBuildVersion;

///系统的ios版本
- (NSString*)getIOSVersion;

///获取系统语言
- (NSString*)getIOSLanguage;

///是否是英文语言环境
- (BOOL)isEnglishLanguage;

///返回系统使用语言
- (HDSystemLanguage)getLanguage;

///软件Bundle Identifier
- (NSString*)getBundleIdentifier;

///模拟软件唯一标示，如果idfa可用使用idfa，否则则使用模拟的idfa
- (NSString*)getIphoneIdfa;

///获取具体的手机型号字符串
- (NSString*)getDetailModel;

///是否是平板
- (BOOL)isPad;

///是否是iphoneX
-(BOOL)isPhoneX;

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

```
## 五、其他

欢迎大家提bug，多交流，互相学习

项目gitHub地址：[https://github.com/DamonHu/HDCommonTools](https://github.com/DamonHu/HDCommonTools)

个人博客：[http://www.hudongdong.com/ios/796.html](http://www.hudongdong.com/ios/796.html)

## 六、重要修改记录
### v1.1.2
1. 增加常用宏定义
2. 完善demo示例

### v1.1.1
1. 增加了appstore的预览页面和评分