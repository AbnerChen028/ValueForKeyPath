

# KVC中的集合运算符

当使用`KVC`中的`valueForKeyPath`方法时，可以在路径中嵌入一个集合运算。一个集合运算符上一个小的关键词列表之一，前面用`@`符号开头，它指定`getter`在返回之前以某种方式处理数据。其方法由`NSObject`的`valueForKeyPath`默认实现。

# 集合运算符组成

一个完整的集合运算符包含三个部分，如图所示：

![](http://orhh9hlxq.bkt.clouddn.com/15166984161285.jpg)

一个完整的集合运算符号分三个部分：

* Left Key path
* Collection operator
* Right Key path

如果要集合对象使用该方法(例如:`NSArray`)可以直接省略`Left Key path`。`Right Key path`用来制定操作的属性。除了`@count`以外的所有集合运算符都需要指定一个正确的`KeyPath`。

# 集合运算符分类

集合运算符根据功能不同可分为三种：

## 聚合运算符

聚合运算符以某种方式合并一个集合中的对象，并返回一个大概匹配`Right Key path`属性的对象。当不存在`Right Key path`属性时候默认返回`@count`属性。

## 数组运算符

数组运算符返回一个NSArray实例，该实例包含指定集合中的一些对象子集。

## 嵌套运算符

嵌套运算符处理包含其他集合的集合，并根据操作符返回一个以某种方式组合嵌套集合的对象的NSArray或NSSet实例。

# 示例

首先创建一个交易对象:

```Objc
@interface Transaction : NSObject
 
@property (nonatomic) NSString* payee;   // 收款人
@property (nonatomic) NSNumber* amount;  // 金额
@property (nonatomic) NSDate* date;      // 日期
 
@end
```

一个包含多个交易对象的数组，包含以下数据:

| payee | amount | date |
|---|---|---|
|Green Power| $120.00|Dec 1, 2015|
|Green Power|$160.00 |Jan 1, 2016|
|Car Loan|$180.00|Feb 1, 2016|
|Car Loan| $220.00|Jan 15, 2016|
|General Cable|$260.00|Feb 15, 2016|



## 聚合运算

聚合运算符可以在数组或属性集上工作，产生反映集合某些方面的单个值。

### avg 平均数

当指定@avg运算符时，valueForKeyPath：读取由集合中每个元素`Right Key path`指定的属性，将其转换为double（将nil值替换为0），并计算这些元素的算术平均值。 然后它返回存储在NSNumber实例中的结果。

具体代码如下：

```Objc
NSNumber *avg = [transactions valueForKeyPath:@"@avg.amount"];
```

执行结果：`188`。

### count

当您指定@count运算符时，valueForKeyPath：返回NSNumber实例中集合中的对象数。如果存在，`Right Key path`将被忽略。

```Objc
NSNumber *count = [transactions valueForKeyPath:@"@count"];
```

执行结果： `5`。

### max / min / sum

当指定@max运算符时，valueForKeyPath：在由`Right Key path`指定的属性中搜索并返回最大值，具体通过`compare：`方法对指定的属性进行排序。 因此，`Right Key path`指示的属性必须实现了`compare:`方法。

```Objc
NSDate *latestDate = [transactions valueForKeyPath:@"@max.date"];
```

此时将获取到最后一个对象的date。相同的原理还有`min`、`sum`。


## 数组运算符

数组运算符计算后返回一个特定包含原数组中部分对象的数组。

### distinctUnionOfObjects

取出`Right Key path`中的值，并做去重处理，返回处理之后的数组：

```Objc
NSArray *unionOfObjects = [transactions valueForKeyPath:@"@distinctUnionOfObjects.payee"];
```

输出结果:

```Objc
(
    "Green Power",
    "Car Loan",
    "General Cable"
)
```

### unionOfObjects

其作用与`distinctUnionOfObjects`类似，只是不会做去重处理:

```Objc
NSArray *unionOfObjects = [transactions valueForKeyPath:@"@unionOfObjects.payee"];
```

执行结果:

```Objc
(
    "Green Power",
    "Green Power",
    "Car Loan",
    "Car Loan",
    "General Cable"
)
```

## 嵌套操作符

嵌套操作符和数组运算符很相似，只是该操作符用于嵌套层。

创建`transactions2`临时数据：

| payee | amount | date |
|---|---|---|
|Green Power - 2| $220.00|Dec 1, 2015|
|Green Power - 2|$260.00 |Jan 1, 2016|
|Car Loan - 2|$280.00|Feb 1, 2016|
|Car Loan - 2| $320.00|Jan 15, 2016|
|General Cable - 2|$360.00|Feb 15, 2016|

### distinctUnionOfArrays

执行以下代码：

```Objc
NSArray *arrays = @[transactions, transactions2];
NSArray *collectedDistinctPayees = [arrays valueForKeyPath:@"@distinctUnionOfArrays.payee"];
```

执行结果：

```Objc
(
    "General Cable",
    "Green Power - 2",
    "General Cable - 2",
    "Car Loan - 2",
    "Green Power",
    "Car Loan"
)
```

单层的嵌套`valueForKeyPath`可以将所有`payee`取出并做去重处理。但是对于多层嵌套又如何那：

```Objc
NSArray *arrays = @[@[transactions, transactions2], transactions];
NSArray *collectedDistinctPayees = [arrays valueForKeyPath:@"@distinctUnionOfArrays.payee"];
```

执行结果如下:

```Objc
(
    "General Cable",
        (
        "Green Power",
        "Green Power",
        "Car Loan",
        "Car Loan",
        "General Cable"
        ),
        (
        "Green Power - 2",
        "Green Power - 2",
        "Car Loan - 2",
        "Car Loan - 2",
        "General Cable - 2"
        ),
    "Green Power",
    "Car Loan"
)
```

可以看出`valueForKeyPath`将数组最外层中的`payee`参数取出并做了去重处理，但是对于内层数据却没有去重。

### unionOfArrays

执行以下代码：

```Objc
NSArray *arrays = @[transactions, transactions2];
NSArray *unionOfArrays = [arrays valueForKeyPath:@"@unionOfArrays.payee"];
```

执行结果：

```Objc
(
    "Green Power",
    "Green Power",
    "Car Loan",
    "Car Loan",
    "General Cable",
    "Green Power - 2",
    "Green Power - 2",
    "Car Loan - 2",
    "Car Loan - 2",
    "General Cable - 2"
)
```

该方法直接将数组中的`transaction`对象中的`payee`全部取出。


对于多层嵌套:

```Objc
NSArray *arrays = @[@[transactions, transactions2], transactions];
NSArray *unionOfArrays = [arrays valueForKeyPath:@"@unionOfArrays.payee"];
```

执行结果：

```Objc
(
        (
        "Green Power",
        "Green Power",
        "Car Loan",
        "Car Loan",
        "General Cable"
        ),
        (
        "Green Power - 2",
        "Green Power - 2",
        "Car Loan - 2",
        "Car Loan - 2",
        "General Cable - 2"
        ),
    "Green Power",
    "Green Power",
    "Car Loan",
    "Car Loan",
    "General Cable"
)
```

`unionOfArrays.payee`按照文件夹的顺序将`payeee`参数取出。


# 小结

* 聚合运算类可以对数据进行计算，例如平均数、总数、最大、最小计算等。其中最大最小值的获取需要属性实现`compare:`方法。 其他方法需要属性是Number型数据。
* 数组运算符中，`distinctUnionOfObjects`可以获取到数组中的对象属性全部取出并且做去重处理。假如数组两层嵌套用该方法不会将嵌套中的数据做去重处理。`unionOfObjects`只会取出数组中的数据不做去重处理。
* 嵌套操作符`distinctUnionOfArrays`可以是对`distinctUnionOfObjects`方法的一个完善。对于两层嵌套数据可以取出属性并做去重处理，对于多于两层的嵌套，内部数据将不再做去重去里。在这里`unionOfObjects`和`unionOfArrays`处理结果一致。


参考：[Key-Value Coding Programming Guide](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueCoding/CollectionOperators.html#//apple_ref/doc/uid/20002176-SW3)


