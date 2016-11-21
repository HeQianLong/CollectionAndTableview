//
//  ZSSaveTools.h
//  Businessloans
//
//  Created by 张猛 on 16/4/28.
//  Copyright © 2016年 秦田新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSSaveTools : NSObject
+ (id)objectForKey:(NSString *)defaultName;

+ (void)setObject:(id)value forKey:(NSString *)defaultName;

+ (void)removeObject:(NSString *)defaultName;
/**
 *  获取用户的密码账号
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)getUserPhoneAndPwdValueForKey:(NSString *)key;
/**
 *  获取用户登录时的基本信息
 *
 *  @param key <#key description#>
 *
 *  @return <#return value description#>
 */

+(NSDictionary *)getUserInfoValueForKey:(NSString *)key;

/**
 *  获取订单的Id
 *
 *  @param key
 *
 *  @return
 */

+(NSDictionary *)getOrderIdValueForKey:(NSString *)key;


+(NSMutableArray *)getAnswerValueForKey:(NSString *)key;


@end
