//
//  ViewController.m
//  ValueForKeyPathDemo
//
//  Created by Abner Chen on 2018/1/23.
//  Copyright © 2018年 Abner Chen. All rights reserved.
//

#import "ViewController.h"
#import "Transaction.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *transactions = [NSMutableArray arrayWithCapacity:5];
    
    [transactions addObject:[Transaction modelWith:@"Green Power" amount:@(120.00) date:[NSDate date]]];
    [transactions addObject:[Transaction modelWith:@"Green Power" amount:@(160.00) date:[NSDate date]]];
    [transactions addObject:[Transaction modelWith:@"Car Loan" amount:@(180.00) date:[NSDate date]]];
    [transactions addObject:[Transaction modelWith:@"Car Loan" amount:@(220.00) date:[NSDate date]]];
    [transactions addObject:[Transaction modelWith:@"General Cable" amount:@(260.00) date:[NSDate date]]];
    
    
#pragma mark - 聚合运算
    NSNumber *avg = [transactions valueForKeyPath:@"@avg.amount"];
    
    // crash
    // NSNumber *avg = [transactions valueForKeyPath:@"@avg.date"];
    
    NSLog(@"avg - %@",avg);

    NSNumber *count = [transactions valueForKeyPath:@"@count"];
    NSLog(@"count - %@",count);

    NSDate *latestDate = [transactions valueForKeyPath:@"@max.date"];
    NSLog(@"latestDate - %@", latestDate);

#pragma mark - 数组运算
    NSArray *distinctPayees = [transactions valueForKeyPath:@"@distinctUnionOfObjects.payee"];
    NSLog(@"distinctPayees - %@", distinctPayees);

    NSArray *unionOfObjects = [transactions valueForKeyPath:@"@unionOfObjects.payee"];
    NSLog(@"unionOfObjects - %@", unionOfObjects);

#pragma mark - 嵌套运算
    
    NSMutableArray *transactions2 = [NSMutableArray arrayWithCapacity:5];

    [transactions2 addObject:[Transaction modelWith:@"Green Power - 2" amount:@(220.00) date:[NSDate date]]];
    [transactions2 addObject:[Transaction modelWith:@"Green Power - 2" amount:@(260.00) date:[NSDate date]]];
    [transactions2 addObject:[Transaction modelWith:@"Car Loan - 2" amount:@(280.00) date:[NSDate date]]];
    [transactions2 addObject:[Transaction modelWith:@"Car Loan - 2" amount:@(320.00) date:[NSDate date]]];
    [transactions2 addObject:[Transaction modelWith:@"General Cable - 2" amount:@(360.00) date:[NSDate date]]];

    NSArray *arrays = @[@[transactions, transactions2], transactions];
//    NSArray *arrays = @[transactions, transactions2];

    NSArray *collectedDistinctPayees = [arrays valueForKeyPath:@"@distinctUnionOfArrays.payee"];

    NSLog(@"collectedDistinctPayees - %@",collectedDistinctPayees);


    NSArray *unionOfArrays = [arrays valueForKeyPath:@"@unionOfArrays.payee"];
    NSLog(@"unionOfArrays - %@",unionOfArrays);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
