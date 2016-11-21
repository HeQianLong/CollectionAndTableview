//
//  ZSSaveTools.m
//  Businessloans
//
//  Created by 张猛 on 16/4/28.
//  Copyright © 2016年 秦田新. All rights reserved.
//

#import "ZSSaveTools.h"
#define ZSUserDefaults [NSUserDefaults standardUserDefaults]

@implementation ZSSaveTools
+ (id)objectForKey:(NSString *)defaultName
{
    return [ZSUserDefaults objectForKey:defaultName];
}

+ (void)setObject:(id)value forKey:(NSString *)defaultName
{
    [ZSUserDefaults setObject:value forKey:defaultName];
}
+ (void)removeObject:(NSString *)defaultName
{
    [ZSUserDefaults removeObjectForKey:defaultName];
}

+(NSString *)getUserPhoneAndPwdValueForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = ZSUserDefaults;
    return [userDefaults objectForKey:[NSString stringWithFormat:@"%@",key]];
}

+(NSDictionary *)getUserInfoValueForKey:(NSString *)key{
    NSUserDefaults *userDefaults = ZSUserDefaults;
    return [userDefaults objectForKey:key];
}
+(NSDictionary *)getOrderIdValueForKey:(NSString *)key{
    
    NSUserDefaults *userDefaults = ZSUserDefaults;
    return [userDefaults objectForKey:key];

}
+(NSMutableArray *)getAnswerValueForKey:(NSString *)key{

    NSUserDefaults *userDefaults = ZSUserDefaults;
    return [userDefaults objectForKey:key];

}
@end
