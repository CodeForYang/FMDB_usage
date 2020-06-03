//
//  GirsViewController.m
//  DBTest
//
//  Created by 10.12 on 2020/6/1.
//  Copyright © 2020 10.12. All rights reserved.
//

#import "GirsViewController.h"
#import "AddGirlViewController.h"
#import "GirlsDBTool.h"
#import "GirlsViewCell.h"
#import "GirlModel.h"
#import <Masonry.h>
@interface GirsViewController ()
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation GirsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"朋友类型";
    self.dataArray = [NSMutableArray array];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPage)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(deleteAll)];

    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.tableView registerClass:[GirlsViewCell class] forCellReuseIdentifier:@"girsView"];

//   drop (删除表)：删除内容和定义，释放空间
    
}

- (void)deleteAll{
    GirlsDBTool *girlsDB = [GirlsDBTool shareInstance];
    if (![girlsDB.db open]) {
       //1.在与数据库交互之前，必须先打开它。如果没有足够的资源或权限来打开和/或创建数据库，则打开失败。
       NSLog(@"数据库打开失败");
       return;
    }
    NSString *delete = @"drop table girls_table";//删除某张表(girls_table)
    BOOL isDelete = [girlsDB.db executeUpdate:delete];
    if(isDelete) {
        NSLog(@"drop table success");
        [self doSQLWithString:nil];
    }

}


- (void)doSQLWithString:(NSString *)sqlStr{//删除的sql语句
    GirlsDBTool *girlsDB = [GirlsDBTool shareInstance];
    if (![girlsDB.db open]) {
         //1.在与数据库交互之前，必须先打开它。如果没有足够的资源或权限来打开和/或创建数据库，则打开失败。
         NSLog(@"数据库打开失败");
         return;
     }
    
    if (sqlStr) {
        BOOL isOk = [girlsDB.db executeUpdate:@"delete from girls_table where name=?" withArgumentsInArray:@[sqlStr]];
        if(isOk)NSLog(@"删除成功");
    }
    
    NSString *sql = @"select * from girls_table";
    FMResultSet *result = [girlsDB.db executeQuery:sql];

    [self.dataArray removeAllObjects];
    while (result.next) {
        NSString *name = [result stringForColumn:@"name"];//打印 "name" 列
        CGFloat height = [result doubleForColumn:@"height"];//打印 "name" 列
        CGFloat weight = [result doubleForColumn:@"weight"];//打印 "name" 列
        NSUInteger age = [result intForColumn:@"age"];//打印 "name" 列
        NSString *hobits = [result stringForColumn:@"hobits"];//打印 "name" 列
        NSString *birthPlace = [result stringForColumn:@"birthPlace"];//打印 "name" 列
        NSData *photo = [result dataForColumn:@"photo"];//打印 "name" 列

        GirlModel *girl = [GirlModel new];
        girl.name = name;
        girl.height = height;
        girl.weight = weight;
        girl.age = age;
        girl.hobits = hobits;
        girl.birthPlace = birthPlace;
        girl.photo = [UIImage imageWithData:photo];
        
        NSLog(@"%@,%f,%f,%zd,%@,%@",name,height,weight,age,hobits,birthPlace);
        [self.dataArray addObject:girl];
    }
     
    
    [self.tableView reloadData];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self doSQLWithString:nil];
}


- (void)addPage{
    AddGirlViewController *vc = [AddGirlViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GirlModel *model = self.dataArray[indexPath.row];

    AddGirlViewController *vc = [AddGirlViewController new];
    vc.name = model.name;
    vc.age = model.age;
    vc.birthPlace = model.birthPlace;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GirlsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"girsView" forIndexPath:indexPath];
   //删除重用cell的子控件,
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    GirlModel *model = self.dataArray[indexPath.row];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:model.photo];
    [cell.contentView addSubview:imageV];
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.numberOfLines = 0;
    NSMutableString *detailStr = [NSMutableString string];
    [detailStr appendFormat:@"姓名:%@ \n身高:%f \n体重%f \n年龄:%zd \n爱好:%@  \n出生地:%@",model.name,model.height,model.weight,model.age,model.hobits,model.birthPlace];
    detailLabel.text = detailStr;
    [cell.contentView addSubview:detailLabel];

    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(cell.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 120));
        make.centerY.mas_equalTo(cell.contentView);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageV.mas_right).offset(10);
        make.right.mas_equalTo(cell.contentView).offset(-10);
        make.bottom.mas_equalTo(cell.contentView).offset(-10);
        make.top.mas_equalTo(cell.contentView).offset(10);
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    GirlModel *model = self.dataArray[indexPath.row];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
                [self doSQLWithString:model.name];
        

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



@end
