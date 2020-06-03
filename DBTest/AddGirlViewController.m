//
//  AddGirlViewController.m
//  DBTest
//
//  Created by 10.12 on 2020/6/1.
//  Copyright © 2020 10.12. All rights reserved.
//

#import "AddGirlViewController.h"
#import <Masonry.h>
#import "GirlsDBTool.h"
#import "GirlsTypeCell.h"

@interface AddGirlViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSCopying>
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSMutableDictionary *keyValues;
@property (nonatomic,assign)BOOL isGetData;
@end

@implementation AddGirlViewController

- (id)copyWithZone:(NSZone *)zone{
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"姓名:",@"身高:",@"体重:",@"年龄:",@"兴趣爱好:",@"出生地址:",@"照片:"];
    
    [self.tableView registerClass:[GirlsTypeCell class] forCellReuseIdentifier:@"girsType"];
    //数据库查找
    GirlsDBTool *girsDB = [GirlsDBTool shareInstance];
    
    if (![girsDB.db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
     
    if (self.name && self.age && self.birthPlace) {//修改进来的
#pragma mark 查询貌似只能带一个参数,如果我有两个同名的人,怎么筛选出我想要的那个???
        FMResultSet *result = [girsDB.db executeQueryWithFormat:@"select * from girls_table where name = %@", self.name];
        self.isGetData = NO;
        while (result.next) {
            
            NSString *name = [result stringForColumn:@"name"];
            NSString *height = [NSString stringWithFormat:@"%f",[result doubleForColumn:@"height"]];
            NSString *weight = [NSString stringWithFormat:@"%f",[result doubleForColumn:@"weight"]];
            NSString *age = [NSString stringWithFormat:@"%d",[result intForColumn:@"age"]];
            NSString *hobits = [result stringForColumn:@"hobits"];
            NSString *birthPlace = [result stringForColumn:@"birthPlace"];
            NSData *photo = [result objectForColumn:@"photo"];

            if(![name isEqualToString:self.name])continue;//在里面筛选排除
            if(![birthPlace isEqualToString:self.birthPlace])continue;//在里面筛选排除
            if(![age isEqualToString:[NSString stringWithFormat:@"%zd",self.age]])continue;//在里面筛选排除

                
            [self.keyValues setValue:name?:@"" forKey:self.dataArray[0]];
            [self.keyValues setValue:height?:@"" forKey:self.dataArray[1]];
            [self.keyValues setValue:weight?:@"" forKey:self.dataArray[2]];
            [self.keyValues setValue:age?:@"" forKey:self.dataArray[3]];
            [self.keyValues setValue:hobits?:@"" forKey:self.dataArray[4]];
            [self.keyValues setValue:birthPlace?:@"" forKey:self.dataArray[5]];
            [self.keyValues setValue:photo?:@"" forKey:self.dataArray[6]];
            self.isGetData = YES;
            
        }
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (textField.text.length>0 && textField.tag < self.dataArray.count) {

        [self.keyValues setValue:textField.text?:@"" forKey:self.dataArray[textField.tag]];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    
    NSLog(@"allKeys: %@-allValues: %@",self.keyValues.allKeys,self.keyValues.allValues);

    GirlsDBTool *girsDB = [GirlsDBTool shareInstance];
        
     BOOL isOpen = [girsDB.db open];
    if (isOpen) {
        
        
        NSString *sql = @"create table if not exists girls_table(id INTEGER primary key autoincrement,name TEXT not null unique,height REAL not null ,weight REAL not null ,age INTEGER not null default 0,hobits TEXT not null,birthPlace TEXT not null,photo BLOB)";
        BOOL isSuccess = [girsDB.db executeUpdate:sql];
        if (isSuccess) {

            NSString *name = self.keyValues[self.dataArray[0]];
            NSString *height = self.keyValues[self.dataArray[1]];
            NSString *weight = self.keyValues[self.dataArray[2]];
            NSString *age = self.keyValues[self.dataArray[3]];
            NSString *hobits = self.keyValues[self.dataArray[4]];
            NSString *birthPlace = self.keyValues[self.dataArray[5]];
            NSData *photo = self.keyValues[self.dataArray[6]];
            
            BOOL isSaved = NO;
            if (self.isGetData) {//证明是修改进来的
#pragma mark 这种更新方式-照片会有问题???
//                NSString *update = [NSString stringWithFormat:@"update girls_table set height = '%f', weight = '%f',age = '%d',hobits = '%@' ,birthPlace = '%@', photo = '%@' where name = '%@'", height.floatValue,weight.floatValue,age.intValue,hobits,birthPlace,photo,self.name];
//
//                isSaved = [girsDB.db executeUpdate:update];
                
                
                isSaved = [girsDB.db executeUpdate:@"update girls_table set height = ?, weight = ?,age = ?,hobits = ? ,birthPlace = ?,photo = ? where name = ?" withArgumentsInArray:@[@(height.floatValue),@(weight.floatValue),@(age.intValue),hobits,birthPlace,photo,self.name]];
            }else{//证明是新增进来的
                isSaved = [girsDB.db executeUpdateWithFormat:@"insert into girls_table(name,height,weight, age,hobits, birthPlace, photo) values(%@,%f,%f,%d,%@,%@,%@)", name,height.floatValue,weight.floatValue,age.intValue,hobits,birthPlace,photo];

            }
            if (isSaved) {
                NSLog(@"---数据保存成功");
            }else{
                NSLog(@"---数据保存失败");
            }
        }
    }
    
    //关闭数据库
    if ([girsDB.db close]) {
        NSLog(@"关闭数据库");
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"girsType" forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArray[indexPath.row];

    if (indexPath.row != self.dataArray.count - 1) {
        UITextField *tf = [[UITextField alloc]init];
        tf.tag = indexPath.row;
        tf.delegate = self;
        if(self.isGetData) {
          tf.text = self.keyValues[self.dataArray[indexPath.row]];
        }else{
            tf.placeholder = [NSString stringWithFormat:@"请输入"];
        }
        
        [cell.contentView addSubview:tf];
    
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.mas_equalTo(cell.contentView).offset(5);
           make.bottom.mas_equalTo(cell.contentView).offset(-5);
           make.width.mas_equalTo(150);
           make.right.mas_equalTo(cell.contentView).offset(-10);
       }];
        
        if (indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
             tf.keyboardType = UIKeyboardTypeNumberPad;
        }else{
             tf.keyboardType = UIKeyboardTypeDefault;
        }
    }else{//图片cell
        if (self.keyValues[self.dataArray.lastObject]) {
            NSData *imgData = self.keyValues[self.dataArray.lastObject];
             UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageWithData:imgData]];
            [cell.contentView addSubview:imageV];
            
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(80, 120));
                make.centerY.mas_equalTo(cell.contentView);
                make.centerX.mas_equalTo(cell.contentView);
            }];
        }
    }
    
   
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row ==  self.dataArray.count - 1) {
         if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
               UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
               imagePicker.allowsEditing = YES;
               imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
               imagePicker.delegate = self;
               [self presentViewController:imagePicker animated:YES completion:^{
                   NSLog(@"打开相册");
               }];
           }else{
               NSLog(@"不能打开相册");
           }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      if (indexPath.row != self.dataArray.count - 1) {
          return 50.0;
      }else{
          return 120;
      }
}



#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image,1.0f);//第二个参数为压缩倍数
    if (imageData) {
        [self.keyValues setValue:imageData forKey:self.dataArray.lastObject];
    }
    
//    [picker popViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker popViewControllerAnimated:YES];
}


#pragma mark - property
- (NSMutableDictionary *)keyValues{
    if (!_keyValues) {
        _keyValues = [NSMutableDictionary dictionary];
    }
    return _keyValues;
}
@end
