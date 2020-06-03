//
//  ViewController.m
//  DBTest
//
//  Created by 10.12 on 2020/5/29.
//  Copyright © 2020 10.12. All rights reserved.
//
/**
 FMDB有三个主要类:

 FMDatabase——表示单个SQLite数据库。用于执行SQL语句。
 FMResultSet——表示在FMDatabase上执行查询的结果。
 FMDatabaseQueue——如果希望在多个线程上执行查询和更新，则需要使用这个类。它在下面的“线程安全”一节中进行了描述。
 */
#import "ViewController.h"
#import "MJPerson.h"
#import <FMDB.h>
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *logView;
@property (nonatomic,strong)FMDatabase *db;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    MJPerson *person = [MJPerson new];
    person.name = @"Michael Jackson";
    person.height = 178.0;
    person.weight = 70;
    person.hobits = @[@"reading",@"writting",@"danccing"];
    person.loverStranger = @{
        @"name":@"ALEX",
        @"sex":@"girl",
        @"character":@"kind"
    };
    
    
    //创建数据库
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"person.db"];
    NSLog(@"path: %@",path);
    self.db = [FMDatabase databaseWithPath:path];
    
    if (![self.db open]) {
        //1.在与数据库交互之前，必须先打开它。如果没有足够的资源或权限来打开和/或创建数据库，则打开失败。
        NSLog(@"数据库打开失败");
        self.db = nil;
        return;
    }
    
    
    // 数据库前提是open状态
    /**
     * PRIMARY KEY 主键
     * AUTOINCREMENT 自动增量
     * UNIQUE 唯一
     * DEFAULT 默认值
     *   INTEGER 整型
     *   TEXT    文本
     *   REAL    浮点型
     *   BLOB    二进制
     */
    //value(?,?,?,?) id ,name ,age ,score , data
    NSString *sql1 = @"CREATE TABLE IF NOT EXISTS 't_table' (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL UNIQUE, age INTEGER  NOT NULL UNIQUE DEFAULT 0, score REAL NOT NULL unique, data BLOB);";
    NSString *sql2 = @"create table if not exists yp_table (id integer primary key autoincrement,name TEXT not null unique, data BLOB)";
    
    NSString *sqlStr = @"create table if not exists yp_table_1 (id integer primary key autoincrement,name not null unique,age integer not null unique default 0,weight real not null unique,data blob)";
//    NSString *sql0 = @"delete from yp_table";
    BOOL isSuccess = [self.db executeUpdate:sqlStr];
    
    if (isSuccess) {
        
//       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:person requiringSecureCoding:YES error:nil];
//
//        NSString *insertSql1 = @"insert into t_table(name, age, score, data) values(%@, %d , %f, %@)";
//        NSString *insertSql2 = @"insert into yp_table(name,data) values(%@,%@)";
//
//
//        BOOL isDelete = [self.db executeUpdate:@"delete from yp_table where name = ? ",@"d4"];
//
//        BOOL isSaved  = NO;
//        if (isDelete) {
//             isSaved = [self.db executeUpdateWithFormat:insertSql2, @"d4", data];
//        }
//
//        if(!isSaved) return;
//
//        NSLog(@"保存成功----------");

//        FMResultSet *result = [self.db executeQuery:@"select data from yp_table"];

        FMResultSet *result = [self.db executeQueryWithFormat:@"select * from yp_table"];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];//打印 "name" 列
            
            NSData *tmpData = [result objectForColumn:@"data"];//打印 "data"列
            
            MJPerson *tmpPerson2 = [NSKeyedUnarchiver unarchivedObjectOfClass:[MJPerson class] fromData:tmpData error:nil];
            
            NSLog(@"%@-%@",name,tmpPerson2);
            
            NSLog(@"--------------------");

        }
        
        
    }

//    while ([s next]) {
//        //2.对于FMDB，最简单的方法是这样的: 为了遍历查询的结果，可以使用while()循环。您还需要从一个记录“步进”到另一个记录。
//
//    }
//
//
//    //3.在数据库上执行完查询和更新之后，应该关闭FMDatabase连接，以便SQLite放弃在操作过程中获得的所有资源。
//
//    //FMDatabase可以通过调用适当的方法或执行开始/结束事务语句来开始和提交事务。
//    NSString *sql = @"create table bulktest1 (id integer primary key autoincrement, x text);"
//                     "create table bulktest2 (id integer primary key autoincrement, y text);"
//                     "create table bulktest3 (id integer primary key autoincrement, z text);"
//                     "insert into bulktest1 (x) values ('XXX');"
//                     "insert into bulktest2 (y) values ('YYY');"
//                     "insert into bulktest3 (z) values ('ZZZ');";
//
//    BOOL success = [self.db executeStatements:sql];
//
//    sql = @"select count(*) as count from bulktest1;"
//           "select count(*) as count from bulktest2;"
//           "select count(*) as count from bulktest3;";
//
//    success = [self.db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
//        NSInteger count = [dictionary[@"count"] integerValue];
//        NSLog(@"%@ - %zd", dictionary,count);
//        return 0;
//    }];
}




- (IBAction)insert:(UIButton *)sender {
    
    /**
    -注意
     当我们存储表中BLOB 对应的字段如果为字典的时候,这个时候我们不应该把字典往里存,
     使用[NSKeyedArchiver archivedDataWithRootObject: requiringSecureCoding: error:] 将对象转换成NSData类型, 这样当我们取出数据的时候取出的是NSData类型,再将NSData类型数据通过
     [NSKeyedUnarchiver unarchivedObjectOfClass: fromData: error:];解档得到就是对象

    */

    
    /**此种方式后面拼接的参数必须为对象 不可以为int double等基本数据类型*/
    [self.db executeUpdate:@"insert into t_table(name, age, score, data) values(?, ? , ?, ?)", @"jake", @12, @91.0, [NSData data]];
    /**此种方式后面拼接的参数可以为int double等基本数据类型 因为是使用的占位符*/
    [self.db executeUpdateWithFormat:@"insert into t_table(name, age, score, data) values(%@, %d , %f, %@)", @"jake", 12, 91.0, [NSData data]];
    /**此种方式后面拼接的参数必须为对象 不可以为int double等基本数据类型 将对象依次放进数组*/
    [self.db executeUpdate:@"insert into t_table(name, age, score, data) values(?, ? , ?, ?)" withArgumentsInArray:@[@12, @91.0, [NSData data]]];

       
       
    BOOL result = [self.db executeUpdate:@"insert into 'yp_table'(ID,name,phone,score) values(?,?,?,?)" withArgumentsInArray:@[@113,@"x3",@"13",@53]];
    
    if (result) {
       NSLog(@"insert into 't_studet' success");
    } else {
       NSLog(@"insert into 't_studet' fail");
    }
    
    [self.db close];
}
- (IBAction)change:(UIButton *)sender {
    
    [self.db open];
    //0.直接sql语句
    //    BOOL result = [db executeUpdate:@"update 'yp_table' set ID = 110 where name = 'x1'"];
    //1.
    //    BOOL result = [db executeUpdate:@"update 'yp_table' set ID = ? where name = ?",@111,@"x2" ];
    //2.
    //    BOOL result = [db executeUpdateWithFormat:@"update 'yp_table' set ID = %d where name = %@",113,@"x3" ];
    //3.
    BOOL result = [self.db executeUpdate:@"update 'yp_table' set ID = ? where name = ?" withArgumentsInArray:@[@113,@"x3"]];
    if (result) {
        NSLog(@"update 'yp_table' success");
    } else {
        NSLog(@"insert into 't_studet' fail");
    }
    [self.db close];
}
- (IBAction)delete:(UIButton *)sender {
    [self.db open];
    ///0.直接sql语句
    //    BOOL result = [db executeUpdate:@"delete from 'yp_table' where ID = 110"];
    //1.
    //    BOOL result = [db executeUpdate:@"delete from 'yp_table' where ID = ?",@(111)];
    //2.
    //    BOOL result = [db executeUpdateWithFormat:@"delete from 'yp_table' where ID = %d",112];
    //3.
    BOOL result = [self.db executeUpdate:@"delete from 'yp_table' where ID = ?" withArgumentsInArray:@[@113]];
    if (result) {
        NSLog(@"delete from 'yp_table' success");
    } else {
        NSLog(@"insert into 't_studet' fail");
    }
    [self.db close];

}
- (IBAction)query:(UIButton *)sender {
    /**
    FMResultSet根据column name获取对应数据的方法
    intForColumn：
    longForColumn：
    longLongIntForColumn：
    boolForColumn：
    doubleForColumn：
    stringForColumn：
    dataForColumn：
    dataNoCopyForColumn：
    UTF8StringForColumnIndex：
    objectForColumn：
    */
    [self.db open];
    
    /**此种方式后面拼接的参数必须为对象 不可以为int double等基本数据类型*/
    [self.db executeQuery:@"select * from t_table"];
    
    /**此种方式后面拼接的参数可以为int double等基本数据类型 因为是使用的占位符*/
    [self.db executeQueryWithFormat:@"SELECT name, age, score from t_table where name = %@", @"jake"];
    
    /**此种方式后面拼接的参数必须为对象 不可以为int double等基本数据类型 将对象依次防近视数组*/
    FMResultSet *result = [self.db executeQuery:@"select *from t_table where age > ?" withArgumentsInArray:@[@12]];
    while (result.next) {
        
        
        NSLog(@"从数据库查询成功");
    }
}





/* 获取下一个记录 */
//- (BOOL)next;
///* 获取记录有多少列 */
//- (int)columnCount;
///* 通过列名得到列序号，通过列序号得到列名 */
//- (int)columnIndexForName:(NSString *)columnName;
//- (NSString *)columnNameForIndex:(int)columnIdx;
///* 获取存储的整形值 */
//- (int)intForColumn:(NSString *)columnName;
//- (int)intForColumnIndex:(int)columnIdx;
///* 获取存储的长整形值 */
//- (long)longForColumn:(NSString *)columnName;
//- (long)longForColumnIndex:(int)columnIdx;
///* 获取存储的布尔值 */
//- (BOOL)boolForColumn:(NSString *)columnName;
//- (BOOL)boolForColumnIndex:(int)columnIdx;
///* 获取存储的浮点值 */
//- (double)doubleForColumn:(NSString *)columnName;
//- (double)doubleForColumnIndex:(int)columnIdx;
///* 获取存储的字符串 */
//- (NSString *)stringForColumn:(NSString *)columnName;
//- (NSString *)stringForColumnIndex:(int)columnIdx;
///* 获取存储的日期数据 */
//- (NSDate *)dateForColumn:(NSString *)columnName;
//- (NSDate *)dateForColumnIndex:(int)columnIdx;
///* 获取存储的二进制数据 */
//- (NSData *)dataForColumn:(NSString *)columnName;
//- (NSData *)dataForColumnIndex:(int)columnIdx;
///* 获取存储的UTF8格式的C语言字符串 */
//- (const unsigned char *)UTF8StringForColumnName:(NSString *)columnName;
//- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx;
///* 获取存储的对象，只能是NSNumber、NSString、NSData、NSNull */
//- (id)objectForColumnName:(NSString *)columnName;
//- (id)objectForColumnIndex:(int)columnIdx;



@end
