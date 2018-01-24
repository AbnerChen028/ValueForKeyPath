//
//  Transaction.h
//  ValueForKeyPathDemo
//
//  Created by Abner Chen on 2018/1/23.
//  Copyright © 2018年 Abner Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (nonatomic, strong) NSString* payee;   // 收款人
@property (nonatomic, strong) NSNumber* amount;  // 金额
@property (nonatomic, strong) NSDate* date;      // 时间
@property (nonatomic, assign) float test;  // 金额

+ (instancetype)modelWith:(NSString *)payee amount:(NSNumber *)amount date:(NSDate *)date;

@end
