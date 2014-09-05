//
//  PushHandler.m
//  WhereWeAre
//
//  Created by 倪 李俊 on 14-9-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import "PushHandler.h"
static NSString * pushToken;
@implementation PushHandler
+(void)setPushToken:(NSString*)token{
    pushToken=token;
}
+(void)handlePush:(NSDictionary *)userInfo{
    NSLog(@"WhereWeAre RECEIVED PUSH: %@",userInfo);
}
@end
