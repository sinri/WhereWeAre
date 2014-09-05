//
//  PushHandler.h
//  WhereWeAre
//
//  Created by 倪 李俊 on 14-9-4.
//  Copyright (c) 2014年 com.sinri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushHandler : NSObject
+(void)setPushToken:(NSString*)token;
+(void)handlePush:(NSDictionary *)userInfo;
@end
