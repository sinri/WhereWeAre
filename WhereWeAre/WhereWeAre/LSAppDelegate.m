//
//  LSAppDelegate.m
//  WhereWeAre
//
//  Created by 倪 李俊 on 14-9-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "LSAppDelegate.h"

@implementation LSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 通知设备需要接收推送通知 Let the device know we want to receive push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeNewsstandContentAvailability)
     ];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    //点击了通知中心的离线推送消息条。
    NSDictionary* offline = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    [self application:application didReceiveOfflineRemoteNotification:offline];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/**
 { "aps": { "content-available": 1, "alert": "content test", "badge": 0, "sound": "default" } }
 **/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    NSLog(@"设备收到推送(后台向)：\n%@",userInfo);
    [PushHandler handlePush:userInfo];
    handler(UIBackgroundFetchResultNewData);
}
-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"我的设备ID(NSData): %@", deviceToken);
    //对deviceToken进行格式化
    NSString *strDev = [[[[deviceToken description]
                          stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"我的设备ID(NSString): %@", strDev);
    //可以在此获得设备的device token，以及其他信息，发送给服务器
    //const void  *devTokenBytes = [deviceToken bytes];
    //[self sendProviderDeviceToken:devTokenBytes];
    
    [PushHandler setPushToken:strDev];
}

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"注册失败，无法获取设备ID, 具体错误: %@", error);
    [PushHandler setPushToken:nil];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"设备收到推送(正常向)：\n%@",userInfo);
    [self handleRemotePush:userInfo[@"aps"]];
}

-(void)application:(UIApplication *)application didReceiveOfflineRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"点击了通知中心的离线推送消息项：\n%@",userInfo);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if( [apsInfo objectForKey:@"alert"] != NULL)
    {
        [self handleRemotePush:userInfo[@"aps"]];
    }
}

-(void)handleRemotePush:(NSDictionary *)userInfo{
    /*
     UIAlertView * av=[[UIAlertView alloc]initWithTitle:userInfo[@"alert"] message:userInfo[@"addition"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [av show];
     */
    [PushHandler handlePush:userInfo];
}


@end
