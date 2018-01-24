//
//  Transaction.m
//  ValueForKeyPathDemo
//
//  Created by Abner Chen on 2018/1/23.
//  Copyright © 2018年 Abner Chen. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

+ (instancetype)modelWith:(NSString *)payee amount:(NSNumber *)amount date:(NSDate *)date{
    
    Transaction *model = [[self alloc] init];
    model.payee = payee;
    model.amount = amount;
    model.date = date;
    
    model.test = (rand() % 100) / 10.0;
    
    return model;
}

@end
