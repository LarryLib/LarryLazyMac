//
//  ViewController.m
//  LarryLazyMac
//
//  Created by 公司 on 2017/8/17.
//  Copyright © 2017年 LarryTwoFly. All rights reserved.
//

#import "RootVC.h"

#define H1 30
#define H2 350

@interface RootVC ()<NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate>

@property (nonatomic,strong) NSArray * fileNameArr;
@property (nonatomic,strong) NSTableView * tableView;
@property (nonatomic,strong) NSMutableArray * mArr;

@property (nonatomic,strong) NSView * selectView;
@property (nonatomic,strong) NSArray * selectArr;

@property (nonatomic,assign) BOOL isShowList;       //选择按钮状态
@property (nonatomic,assign) BOOL isModelType;      //工作状态（yes-获取模型，no-其他）

@property (nonatomic,copy) NSString * keyStr;
@property (nonatomic,copy) NSString * valueStr;
@property (nonatomic,strong) NSTextField * keyTF;

@end

@implementation RootVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.wantsLayer = YES;
    self.view.layer.backgroundColor = CGColorCreateGenericRGB(1.00f, 0.00f, 0.00f, 1.0f);
    
    //设置默认
    self.isShowList = NO;
    self.isModelType = YES;
    
    //选择按钮
    NSButton * selectBtn = [NSButton buttonWithTitle:@"LarryLazyBtn" target:self action:@selector(clickSelectBtn:)];
    selectBtn.frame = CGRectMake(10, 10, 150, 50);
    [self.view addSubview:selectBtn];
    
    //获取模型
    NSButton * getModelBtn = [NSButton buttonWithTitle:@"GetModel" target:self action:@selector(getModelBtnClick)];
    getModelBtn.frame = CGRectMake(170, 10, 150, 50);
    [self.view addSubview:getModelBtn];

//    //
//    NSButton * netTestBtn = [NSButton buttonWithTitle:@"接口测试" target:self action:@selector(netTestBtn)];
//    netTestBtn.frame = CGRectMake(330, 10, 150, 50);
//    [self.view addSubview:netTestBtn];

    // 1.0.创建卷轴视图
    NSScrollView * scrollView = [[NSScrollView alloc] init];
    // 1.1.有(显示)垂直滚动条
    scrollView.hasVerticalScroller = YES;
    // 1.2.设置frame并自动布局
    scrollView.frame = CGRectMake(0, 120, 500, self.view.bounds.size.height-120);
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    // 1.3.添加到self.view
    [self.view addSubview:scrollView];
    
    // 2.0.创建表视图
    NSTableView * tableView = [[NSTableView alloc] init];
    tableView.frame = scrollView.bounds;
    // 2.1.设置代理和数据源
    tableView.delegate = self;
    tableView.dataSource = self;
    // 2.2.设置为ScrollView的documentView
    scrollView.contentView.documentView = tableView;
    
    // 3.0.创建表列
    NSTableColumn * columen = [[NSTableColumn alloc] initWithIdentifier:@"columen"];
    // 3.1.设置最小的宽度
    columen.minWidth = tableView.frame.size.width;
    // 3.2.允许用户调整宽度
    /*
    NSTableColumnNoResizing        不能改变宽度
    NSTableColumnAutoresizingMask  拉大拉小窗口时会自动布局
    NSTableColumnUserResizingMask  允许用户调整宽度
    */
    columen.resizingMask = NSTableColumnUserResizingMask;
    // 3.3.添加到表视图
    [tableView addTableColumn:columen];
    self.tableView = tableView;
    
}
#pragma mark NSTableViewDelegate 代理方法
// 设置Cell
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSRect rect;
    if (self.isShowList||(self.isModelType&&row==1)) {
       rect = NSMakeRect(0, 0, tableView.frame.size.width, H1);
    }else{
       rect = NSMakeRect(0, 0, tableView.frame.size.width, H2);
    }
    
    // 1.0.创建一个Cell
    NSTextField * view = [[NSTextField alloc] initWithFrame:rect];
    view.bordered = YES;
    view.editable = YES;
    
    // 1.1.判断是哪一列
    if ([tableColumn.identifier isEqualToString:@"columen"]) {
        if (self.isShowList) {
            view.stringValue = self.mArr[row];
        }else {
            view.editable = YES;
            if (self.valueStr.length>0)
                view.stringValue = self.valueStr;
            if (self.isModelType&&row==0){
                self.keyTF = view;
                view.placeholderString = @"请输入模型key:value\n格式为：\n{\n\t""key1"":""value1"",\n\t""key2"":""value2"",\n\t""key3""=""value3""\n}\n\n\n说明：\n①{}可不带；\n②每行结尾为换行\\n或者回车\\r；其中\\n兼容APIVIEW,\\r兼容勇哥接口文档；\n③不“完全”支持嵌套模型转换，在嵌套的数据下，仍按一级返回，需手动区分;\n④key与value之间为冒号或等号，前者为属性key，后者为value值或者属性说明。";
                if (self.keyStr.length>0)
                    view.stringValue = self.keyStr;
                view.editable = YES;
            }
        }
    }
    return view;
}
// 设置行数
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if (self.isShowList) {
        return self.mArr.count;
    }
    if (self.isModelType) {
        return 2;
    }
    return 1;
}
// 设置行高
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    if (self.isShowList) {
        return H1;
    }
    if (self.isModelType&&row==0) {
        return H2-100;
    }
    if (self.isModelType&&row==1) {
        return H2-100;
    }
    return H2+100;
}
//cell的点击事件
-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    NSLog(@"%ld",row);
    
    if (row==1||(!self.isShowList&&self.isModelType)) {
        self.isModelType = YES;
        self.keyStr = @"";
        self.valueStr = @"";
    }else{
        self.isModelType = NO;
        if (self.selectArr.count>row) {
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.selectArr[row] ofType:@"txt"];
            self.valueStr = [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil];

        }
    }
    
    if (self.isShowList) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    self.isShowList = NO;
    return YES;
}
//选择功能
-(void)clickSelectBtn:(NSButton *)btn {
    [self.mArr removeAllObjects];
    self.isShowList = !self.isShowList;
    if (self.isShowList) {
        [self.mArr addObjectsFromArray:self.selectArr];
    }
    if (self.mArr.count>0)
        [self.tableView reloadData];
}
#pragma mark 懒加载
-(NSMutableArray *)mArr {
    if (!_mArr) {
        _mArr = [NSMutableArray array];
    }
    return _mArr;
}
-(NSArray *)selectArr {
    if (!_selectArr) {
         NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LarryLazy" ofType:@"plist"];
        _selectArr = [NSArray arrayWithContentsOfFile:plistPath];
    }
    return _selectArr;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}
#pragma mark 展示网络接口测试界面

#pragma mark 获取模型
-(void)getModelBtnClick{
    self.valueStr = @"error";
    self.keyStr = self.keyTF.stringValue;
    
    NSString * nomalStr = @"@property (nonatomic,copy) NSString * ";
    
    NSMutableArray * mArr = [NSMutableArray array];
    NSString * keyS = self.keyTF.stringValue;
    //去除 杂质
    keyS = [keyS stringByReplacingOccurrencesOfString:@"{" withString:@""];
    keyS = [keyS stringByReplacingOccurrencesOfString:@"}" withString:@""];
    keyS = [keyS stringByReplacingOccurrencesOfString:@" " withString:@""];
    keyS = [keyS stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    keyS = [keyS stringByReplacingOccurrencesOfString:@"<null>" withString:@" "];
    keyS = [keyS stringByReplacingOccurrencesOfString:@"<NULL>" withString:@" "];
    keyS = [keyS stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    keyS = [keyS stringByReplacingOccurrencesOfString:@"=" withString:@"= "];

    //属性分割
    NSArray * keyArr = [keyS componentsSeparatedByString:@"\r"];//兼容勇哥文档
    if (keyArr.count==1) {
        keyArr = [keyS componentsSeparatedByString:@"\n"];//兼容APIVIEW文档
    }
    for (NSString * str0 in keyArr) {
        if (str0&&str0.length>0) {
            //若，str最后一个字符为“，则删除“，”
            NSString * str = [str0 copy];
            if ([str containsString:@"\n"]) {
                NSArray * strArr = [str componentsSeparatedByString:@"\n"];
                str = @"";
                for (NSString * s in strArr) {
                    if (s.length>str.length) {
                        str = s;
                    }
                }
            }
            if ([[str substringFromIndex:str.length-1] isEqualToString:@","]||[[str substringFromIndex:str.length-1] isEqualToString:@"，"]) {
                str = [str substringWithRange:NSMakeRange(0, str.length-1)];
            }
            [mArr addObject:str];
        }
    }
    
    //属性 规范化
    NSMutableString * retStr = [NSMutableString string];
    for (int i=0; i<mArr.count; i++) {
        NSString * str = mArr[i];
        
        //获取分割字符
        NSString * separationStr = @"";
        if ([str containsString:@"="]) {
            separationStr = @"=";
        }else if ([str containsString:@":"]){
            separationStr = @":";
        }else if ([str containsString:@"："]){
            separationStr = @"：";
        }else{
            return;
        }
        
        //获取分割字符的range
        NSRange range = [str rangeOfString:separationStr options:NSLiteralSearch];
        NSString * keyStr = [str substringToIndex:range.location];
        NSString * valueStr = [str substringFromIndex:range.location+range.length];
        keyStr = [NSString stringWithFormat:@"%@%@;",nomalStr,keyStr];
        if (valueStr.length>0) {
            if (keyStr.length<56) {
                NSLog(@"%ld",keyStr.length);
                for (int i=0; i<(56-keyStr.length)/4; i++)
                    keyStr = [NSString stringWithFormat:@"%@%@",keyStr,@"\t"];
            }
            keyStr = [NSString stringWithFormat:@"%@//%@",keyStr,valueStr];
        }
        
        //构造完成，拼接到字符串后面
        [retStr appendString:keyStr];
        [retStr appendString:@"\n"];
    }
    
    self.valueStr = [retStr copy];
    [self.tableView reloadData];
}
@end
