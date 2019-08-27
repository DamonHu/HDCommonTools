//
//  ViewController.m
//  HDCommonTools
//
//  Created by Damon on 2018/2/14.
//  Copyright © 2018年 damon. All rights reserved.
//

#import "ViewController.h"
#import "HDCommonTools.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSArray *titleArray;
@property (strong,nonatomic) NSString *debugFilePath;
@property (strong,nonatomic) UIButton *shareBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ///注册权限回调通知
    //Registration authority callback notice
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(permissionNotifacation:) name:HDPermissionStatusDidChangeNotification object:nil];
    [self initData];
    [self createUI];
    HDDebugLog(@"开始演示");
    HDDebugLog(@"开始演示2");
}

-(void)initData{
    self.titleArray = [NSArray arrayWithObjects:@"系统信息示例 System information",@"权限申请示例 Permission application",@"多媒体操作 Multi-Media",@"常用宏定义示例 common define",@"加密解密 Crypto",@"Appstore",@"日期相关", nil];
    self.dataArray = [NSMutableArray array];
    NSArray *array = [NSArray arrayWithObjects:@"打印软件版本 Print software version",@"打印系统语言 Print system language",@"打印系统iOS版本 Print system iOS version", nil];
    NSArray *array2 = [NSArray arrayWithObjects:@"申请GPS权限 GPS permissions",@"申请相册权限 Photo album permissions",@"申请通知权限 Application of notification authority",@"打开系统设置 Open the system settings", nil];
    NSArray *array3 = [NSArray arrayWithObjects:@"循环播放音乐 Loop Play music ",@"关闭音乐 Stop playing music",@"循环播放音效 Play effect repeat",@"关闭音效 stop playing effect", nil];
    NSArray *array4 = [NSArray arrayWithObjects:@"测试输出 Log output",@"16进制颜色 16 Decimal color #f44336",@"rgb color 3，169，244，translucent",@"Interface parameters",@"将log输出到文件 Output log to a file", nil];
    NSArray *array5 = [NSArray arrayWithObjects:@"md5加密 String MD5 encryption",@"aes256加密 String aes256 encryption",@"aes256解密 String aes256 Decrypted", nil];
    NSArray *array6 = [NSArray arrayWithObjects:@"应用内Appstore评分 Force the score pop-up window in app",@"跳转Appstore评分 Forced jump to appsStore to give score",@"应用内弹出appstore介绍 Force the score pop-up window in app",@"跳转到appstore看介绍 Jump to the appstore to see the introduction", nil];
    NSArray *array7 = [NSArray arrayWithObjects:@"获取时间戳 getTimestamp",@"比较日期先后 compare date",@"获取农历日期 getTimeStrWithChineseLunarCalendar",@"获取农历生肖 ChineseZodiac",@"获取星座 getConstellation", nil];
    [self.dataArray addObject:array];
    [self.dataArray addObject:array2];
    [self.dataArray addObject:array3];
    [self.dataArray addObject:array4];
    [self.dataArray addObject:array5];
    [self.dataArray addObject:array6];
    [self.dataArray addObject:array7];
}
-(void)createUI{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HDScreenWidth, HDScreenHeight) style:UITableViewStyleGrouped];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HDcommonToolcell"];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
}

-(void)permissionNotifacation:(NSNotification*)notification{
    NSDictionary * userInfo = [notification userInfo];
    if ([[userInfo objectForKey:HDPermissionNameItem] integerValue] == kHDPermissionNameGPS) {
        if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorized) {
            NSLog(@"用户允许访问gps Users are allowed access to GPS");
        } else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorRestricted){
            NSLog(@"用户被限制访问gps Users are restricted to access to GPS");
        } else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDNotDetermined){
            NSLog(@"用户尚未选择是否允许访问gps User has not chosen to allow access to the GPS");
        } else {
            NSLog(@"用户不允许访问gps Users do not allow access to GPS");
        }
    }else if ([[userInfo objectForKey:HDPermissionNameItem] integerValue] == kHDPermissionNamePhotoLib){
        if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorized) {
            NSLog(@"用户允许访问相册 Users are allowed access to Album");
        } else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorRestricted){
            NSLog(@"用户被限制访问相册 Users are restricted to access to Album");
        } else if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDNotDetermined){
            NSLog(@"用户尚未选择是否允许访问相册 User has not chosen to allow access to the Album");
        } else {
            NSLog(@"用户不允许访问相册 Users do not allow access to Album");
        }
    }else if ([[userInfo objectForKey:HDPermissionNameItem] integerValue] == kHDPermissionNameNotification){
        ///ios10.0以上，通知权限的变化才可以被检测到
        ///Above ios10.0, the change of notification permissions can be detected
        if ([[userInfo objectForKey:HDPermissionStatusItem] integerValue] == kHDAuthorized) {
            NSLog(@"用户允许接收通知 Users are allowed access to Receiving notification");
        } else {
            NSLog(@"用户不允许访问接收通知 Users do not allow access to Receiving notification");
        }
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getAppVersionStr]);
                    break;
                case 1:
                    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getIOSLanguageStr]);
                    break;
                case 2:
                    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getIOSVersionStr]);
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:
                    ///申请gps权限 Apply for GPS permissions
                    [[HDCommonTools sharedHDCommonTools] requestGPSLibraryPermissionWithType:kHDGPSPermissionWhenInUse];
                    break;
                case 1:
                    ///申请相册权限 Apply for Album permissions
                    [[HDCommonTools sharedHDCommonTools] requestPhotoLibraryPermission];
                    break;
                case 2:
                    ///申请通知权限 Application of notification authority
                    [[HDCommonTools sharedHDCommonTools] requestNotificationPermission];
                    break;
                case 3:
                    ///打开系统设置 Open the system settings
                    [[HDCommonTools sharedHDCommonTools] openSystemSetting];
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    NSString * musicFilePath = [[NSBundle mainBundle] pathForResource:@"空谷" ofType:@"wav"];
                    [[HDCommonTools sharedHDCommonTools] playMusicWithMusicFilePath:musicFilePath withRepeat:true];
                }
                    break;
                case 1:{
                    [[HDCommonTools sharedHDCommonTools] stopMusic];
                }
                    break;
                case 2:{
//                    NSString * effectFilePath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"caf"];
                    [[HDCommonTools sharedHDCommonTools] playEffectRepeatWithLocalFilePath:nil withShake:YES];
                }
                    break;
                case 3:{
                    [[HDCommonTools sharedHDCommonTools] stopPlayEffectRepeat];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    HDDebugLog(@"测试log输出，将HDCommonDefine中的HDDEBUG_MODE设置为false将不会打印");
                    HDDebugLog(@"Test log output, and set the HDDEBUG_MODE in HDCommonDefine to false will not be printed");
                }
                    break;
                case 1:{
                    //颜色为#f44336 The color is #f44336
                    UIColor *color = HDColorFromRGB(0xf44336);
                    [tableView setBackgroundColor:color];
                }
                    break;
                case 2:{
                    //颜色为3，169，244，透明度为50% The color is 3,169,244 and the transparency is 50%
                    UIColor *color = HDColorWithRGBA(3, 169, 244, 0.5);
                    [tableView setBackgroundColor:color];
                }
                    break;
                case 3:{
                    NSLog(@"ScreenWidth:%f,ScreenHeight:%f",HDScreenWidth,HDScreenHeight);
                    NSLog(@"状态栏当前高度 Status bar current height:%f",HD_Status_Height);//打电话时或者定位会发生变化
                    NSLog(@"导航栏高度  height of the navigation bar:%f",HD_NavigationBar_Height);
                    NSLog(@"tabbar高度 height of the tabBar:%f",HD_TabBar_Height);
                }
                    break;
                case 4:{
                    ///After calling this function, the console will not output the print information
                    _debugFilePath = [[HDCommonTools sharedHDCommonTools] setHdDebugLogToFile];
                    ///The following print has been printed to the file
                    NSLog(@"ScreenWidth:%f,ScreenHeight:%f",HDScreenWidth,HDScreenHeight);
                    NSLog(@"状态栏当前高度 Status bar current height:%f",HD_Status_Height);//打电话时或者定位会发生变化
                    NSLog(@"导航栏高度  height of the navigation bar:%f",HD_NavigationBar_Height);
                    NSLog(@"tabbar高度 height of the tabBar:%f",HD_TabBar_Height);
                    
                    ///可以操作该文件,比如系统分享调试，可以分享到备忘录、imessage、微博等
                    //The file can be manipulate, such as system sharing debugging, and can be shared with memos, IMessage, micro-blog, and so on
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(HDScreenWidth/2 - 60, 20, 120, 40)];
                    button.layer.masksToBounds = YES;
                    button.layer.cornerRadius = 10;
                    button.layer.borderColor = [UIColor whiteColor].CGColor;
                    button.layer.borderWidth = 1.0f;
                    [button setTitle:@"Share LogFile" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor clearColor]];
                    [button addTarget:self action:@selector(shareTest) forControlEvents:UIControlEventTouchUpInside];
                    [[[UIApplication sharedApplication] keyWindow] addSubview:button];
                    self.shareBtn = button;
                }
                    break;
                default:
                    break;
            }
        }
        case 4:{
            switch (indexPath.row) {
                case 0:{
                    NSLog(@"md5加密的大写字符串 MD5 encrypted uppercase string：%@",[[HDCommonTools sharedHDCommonTools] MD5EncryptWithString:@"my name is HDCommonTools" withLowercase:YES]);
                    NSLog(@"md5加密的小写字符串 MD5 encrypted lowercase string：%@",[[HDCommonTools sharedHDCommonTools] MD5EncryptWithString:@"我my name is HDCommonTools" withLowercase:NO]);
                }
                    break;
                case 1:
                    NSLog(@"aes加密后的字符串 AES encrypted string：%@",[[HDCommonTools sharedHDCommonTools] AES256EncryptWithPlainText:@"my name is HDCommonTools" andKey:@"密码只有我知道"]);
                    break;
                case 2:{
                    ///aes加密后的字符串 AES encrypted string
                    NSString* str = [[HDCommonTools sharedHDCommonTools] AES256EncryptWithPlainText:@"my name is HDCommonTools" andKey:@"Password"];
                    NSLog(@"aes加密后的字符串 AES encrypted string：%@",str);
                    NSLog(@"aes解密后的字符串 AES decrypted string：%@",[[HDCommonTools sharedHDCommonTools] AES256DecryptWithCiphertext:str andKey:@"Password"]);
                    ///使用错误的key解密是空值 The use of the wrong key decryption is an empty value
                    NSLog(@"aes使用错误的key解密后的字符串 AES decrypted string with wrong Password：%@",[[HDCommonTools sharedHDCommonTools] AES256DecryptWithCiphertext:str andKey:@"WrongPassword"]);
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 5:{
            switch (indexPath.row) {
                case 0:{
                    //应用内Appstore评分 Force the score pop-up window in app"
                    [[HDCommonTools sharedHDCommonTools] giveScoreWithAppleID:@"1193575039" withType:kHDScoreTypeInApp];
                }
                    break;
                case 1:{
                    //跳转Appstore评分 Forced jump to appsStore to give score
                    [[HDCommonTools sharedHDCommonTools] giveScoreWithAppleID:@"1193575039" withType:kHDScoreTypeInAppStore];
                }
                    break;
                case 2:{
                    //应用内弹出appstore介绍 Force the score pop-up window in app
                    [[HDCommonTools sharedHDCommonTools] openAppStoreWithAppleID:@"1193575039" withType:kHDJumpStoreTypeInApp];
                }
                    break;
                case 3:{
                    //跳转到appstore看介绍 Jump to the appstore to see the introduction
                    [[HDCommonTools sharedHDCommonTools] openAppStoreWithAppleID:@"1193575039" withType:kHDJumpStoreTypeInAppStore];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 6:{
            switch (indexPath.row) {
                case 0:{
                    //获取时间戳 getTimestamp
                    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getTimestampWithDate:[NSDate date]]);
                }
                    break;
                case 1:{
                    //比较日期先后 compare date
                    NSDateFormatter *temp_formatter = [[NSDateFormatter alloc] init];
                    [temp_formatter setDateFormat:@"yyyy-MM-dd"];
                    NSDate *date = [temp_formatter dateFromString:@"2018-10-20"];
                    
                    NSDateFormatter *temp_formatter2 = [[NSDateFormatter alloc] init];
                    [temp_formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *date2 = [temp_formatter2 dateFromString:@"2018-10-18 18:40:40"];
                    
                    if ([[HDCommonTools sharedHDCommonTools] compareFirstDay:date withSecondDay:date2 withIgnoreTime:YES] == NSOrderedAscending) {
                        NSLog(@"第一个时间早 The first date is earlier");
                    } else if ([[HDCommonTools sharedHDCommonTools] compareFirstDay:date withSecondDay:date2 withIgnoreTime:YES] == NSOrderedDescending) {
                        NSLog(@"第一个日期更晚 The first date is later");
                    } else if ([[HDCommonTools sharedHDCommonTools] compareFirstDay:date withSecondDay:date2 withIgnoreTime:YES] == NSOrderedSame) {
                        NSLog(@"两个日期一样 Two dates are the same");
                    }
                }
                    break;
                case 2:{
                    //获取农历日期 getTimeStrWithChineseLunarCalendar
                    ChineseLunarCalendar *chineseLunarCalendar = [[HDCommonTools sharedHDCommonTools] getChineseLunarCalendarWithDate:[NSDate date]];
                    NSLog(@"%@",[[HDCommonTools sharedHDCommonTools] getChineseLunarCalendarStrWithChineseLunarCalendar:chineseLunarCalendar withFormatType:kHDChineseLunarCalendarFormatTypeYMD]);
                }
                    break;
                case 3:{
                    //获取农历生肖 ChineseZodiac
                    NSLog(@"%lu",(unsigned long)[[HDCommonTools sharedHDCommonTools] getChineseZodiacWithYear:2018]);
                }
                    break;
                case 4:{
                    //获取星座 getConstellation
                    NSLog(@"%lu",(unsigned long)[[HDCommonTools sharedHDCommonTools] getConstellationWithDate:[NSDate date]]);
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

-(void)shareTest{
    NSDateFormatter *temp_formatter = [[NSDateFormatter alloc] init];
    [temp_formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString* dateString = [temp_formatter stringFromDate:[NSDate date]];
    
    NSString *titleText = [NSString stringWithFormat:@"测试输出信息Test output information%@.txt",dateString];
    NSString *shareText = [NSString stringWithFormat:@"测试输出信息Test output information%@.txt",dateString];
    NSURL *URL = [NSURL fileURLWithPath:_debugFilePath];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:titleText,shareText,URL, nil] applicationActivities:nil];
    if ([[HDCommonTools sharedHDCommonTools] isPad]) {
//        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
//        [popup presentPopoverFromRect:CGRectMake(HDScreenWidth/2, HDScreenHeight/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        activityVC.modalPresentationStyle = UIModalPresentationPopover;
        activityVC.popoverPresentationController.sourceView = self.shareBtn;
        [self presentViewController:activityVC animated:YES completion:nil];
    }else {
        [self presentViewController:activityVC animated:true completion:nil];
    }
}

#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [_dataArray objectAtIndex:section];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = [_dataArray objectAtIndex:indexPath.section];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HDcommonToolcell"];
    [cell.textLabel setText:[array objectAtIndex:indexPath.row]];
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_titleArray objectAtIndex:section];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
