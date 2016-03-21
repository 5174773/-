//
//  CarTableViewController.m
//  购物车
//
//  Created by itJG on 16/3/15.
//  Copyright © 2016年 itJG. All rights reserved.
//

#import "CarTableViewController.h"
#import "CartViewCell.h"


#define  TAG_BACKGROUNDVIEW 100

#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width


@interface CarTableViewController ()<UITableViewDataSource,UITableViewDelegate, CartViewCellDelegate>
{
    UITableView *myTableView;
    //全选按钮
    UIButton *selectAll;
    //展示数据源数组
    NSMutableArray *dataArray;
    //是否全选
    BOOL isSelect;
    
    //已选的商品集合
    NSMutableArray *selectGoods;
    
    UILabel *priceLabel;
}

@end

@implementation CarTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    //每次进入购物车的时候把选择的置空
    [selectGoods removeAllObjects];
    isSelect = NO;
    //    [self networkRequest];
    selectAll.selected = NO;
    
    priceLabel.text = [NSString stringWithFormat:@"￥0.00"];
}

/**
 *  @author LQQ, 16-02-18 11:02:16
 *
 *  计算已选中商品金额
 */
-(void)countPrice
{
    double totlePrice = 0.0;
    
    for (CartModel *model in selectGoods) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price*model.number;
    }
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",totlePrice];
}

/**
 *  @author LQQ, 16-02-18 11:02:32
 *
 *  创建测试数据源
 */
-(void)creatData
{
    for (int i = 0; i < 10; i++) {
        CartModel *model = [[CartModel alloc]init];
        
        model.nameStr = @"ZDANXL";
        model.price = @"100.00";
        model.number = 1;
        model.image = [UIImage imageNamed:@"1.jpg"];

        model.sizeStr =@"选择分类: 清纯气质";
        
        [dataArray addObject:model];
    }
    
    if (myTableView) {
        [myTableView reloadData];
    }
    else
    {
        [self setupMainView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   //导航栏  颜色
    self.navigationController.navigationBar.barTintColor = RGBCOLOR(102, 204, 153);

    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *buttonimg = [[UIButton alloc]init];
    [buttonimg setBackgroundImage:[UIImage imageNamed:@"cart_left"] forState:UIControlStateNormal];
    [buttonimg sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonimg];
    
    
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    myTableView.rowHeight = 300;
    
    dataArray = [[NSMutableArray alloc]init];
    selectGoods = [[NSMutableArray alloc]init];
    [self setupMainView];
    [self creatData];
    self.title = @"购物车";
    
    NSDictionary *dict = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                           NSFontAttributeName: [UIFont systemFontOfSize:18]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    

   
}

-(void)selectAllBtnClick:(UIButton*)button
{
    //点击全选时,把之前已选择的全部删除
    [selectGoods removeAllObjects];
    
    button.selected = !button.selected;
    isSelect = button.selected;
    if (isSelect) {
        
        for (CartModel *model in dataArray) {
            [selectGoods addObject:model];
        }
    }
    else
    {
        [selectGoods removeAllObjects];
    }
    
    [myTableView reloadData];
    [self countPrice];
}

//提交订单
-(void)goPayBtnClick
{
    NSLog(@"结算");
}

#pragma mark - 设置底部视图
-(void)setupBottomView
{
    //底部视图的 背景
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
//    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame) - 50 , SCREEN_WIDTH, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.view addSubview:bgView];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = kUIColorFromRGB(0xD5D5D5);
    [bgView addSubview:line];
    
    //全选按钮
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    [selectAll setTitle:@"  全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_normal"] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_selected"] forState:UIControlStateSelected];
    [selectAll setTitleColor:RGBCOLOR(102, 204, 153) forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectAll];
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.text = @"合计: ";
    label.textColor = RGBCOLOR(102, 204, 153);
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:label];
    
    //价格
    priceLabel = [[UILabel alloc]init];
    priceLabel.text = @"￥0.00";
    priceLabel.font = [UIFont boldSystemFontOfSize:16];
    priceLabel.textColor = BASECOLOR_RED;
    [bgView addSubview:priceLabel];
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = RGBCOLOR(102, 204, 153) ;
    [btn setTitle:@"结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
#pragma mark -- 底部视图添加约束
    //全选按钮
    [selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(20);
        make.top.equalTo(@10);
        make.bottom.equalTo(bgView).offset(-10);
        make.width.equalTo(@60);
        
    }];
    
    //结算按钮
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView);
        make.right.equalTo(bgView);
        make.bottom.equalTo(bgView);
        make.width.equalTo(@100);
        
    }];
    
    //价格显示
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn.mas_left).offset(-10);
        make.top.equalTo(bgView).offset(10);
        make.bottom.equalTo(bgView).offset(-10);
        make.left.equalTo(label.mas_right);
    }];
    
    //合计
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(10);
        make.bottom.equalTo(bgView).offset(-10);
        make.right.equalTo(priceLabel.mas_left);
        make.width.equalTo(@60);
    }];
}

#pragma mark - 设置主视图
-(void)setupMainView
{
    //当购物车为空时,显示默认视图
    if (dataArray.count == 0) {
        [self cartEmptyShow];
    }
    //当购物车不为空时,tableView展示
    else
    {
        UIView *vi = [self.view viewWithTag:TAG_BACKGROUNDVIEW];
        [vi removeFromSuperview];
        
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;

        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.backgroundColor = RGBCOLOR(245, 246, 248);
        
        myTableView.rowHeight = 105;
        
        [self.view addSubview:myTableView];
        
        [self setupBottomView];
    }
    
}
//购物车为空时的默认视图
-(void)cartEmptyShow
{
    
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    backgroundView.tag = TAG_BACKGROUNDVIEW;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_default_bg"]];
    img.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 - 10);
    warnLabel.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车好空,买点什么呗!";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = kUIColorFromRGB(0x706F6F);
    [backgroundView addSubview:warnLabel];
    
    //默认视图按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = CGPointMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0 + 40);
    btn.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_background_red"] forState:UIControlStateNormal];
    [btn setTitle:@"去定制" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToMainmenuView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
}
-(void)goToMainmenuView
{
    NSLog(@"去首页");
}

#pragma mark - tableView 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[CartViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.isSelected = isSelect;
    
    cell.indexPath = indexPath;
    
    cell.delegate = self;
    
    //是否被选中
    if ([selectGoods containsObject:[dataArray objectAtIndex:indexPath.row]]) {
        cell.isSelected = YES;
    }
    
    //选择回调
    cell.cartBlock = ^(BOOL isSelec){
        
        if (isSelec) {
            [selectGoods addObject:[dataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [selectGoods removeObject:[dataArray objectAtIndex:indexPath.row]];
        }
        
        if (selectGoods.count == dataArray.count) {
            selectAll.selected = YES;
        }
        else
        {
            selectAll.selected = NO;
        }
        
        [self countPrice];
    };
    __block CartViewCell *weakCell = cell;
    cell.numAddBlock =^(){
        
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count++;
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        CartModel *model = [dataArray objectAtIndex:indexPath.row];
        
        weakCell.countNum = count;
        
        weakCell.numberLabel.text = numStr;
        model.number = count;
        
        [dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        if ([selectGoods containsObject:model]) {
            [selectGoods removeObject:model];
            [selectGoods addObject:model];
            [self countPrice];
        }
    };
    
    cell.numCutBlock =^(){
        
        NSInteger count = [weakCell.numberLabel.text integerValue];
        count--;
        if(count <= 0){
            return ;
        }
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        
        CartModel *model = [dataArray objectAtIndex:indexPath.row];
        
        weakCell.countNum = count;
        
        weakCell.numberLabel.text = numStr;
        
        model.number = count;
        [dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([selectGoods containsObject:model]) {
            [selectGoods removeObject:model];
            [selectGoods addObject:model];
            [self countPrice];
        }
    };
    
    [cell reloadDataWith:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)reloadTable
{
    [myTableView reloadData];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";

}
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        [self deleteDate:indexPath];
//            }
//}


- (void)deleteDate:(NSIndexPath *)indexPath {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        CartModel *model = [dataArray objectAtIndex:indexPath.row];
        if ([selectGoods containsObject:model]) {
            [selectGoods removeObject:model];
            [self countPrice];
        }
        
        
        [dataArray removeObjectAtIndex:indexPath.row];
        //    删除
        [myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
      
        
        
        //延迟0.5s刷新一下,否则数据会乱
        [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
        
      
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)cartViewCell:(CartViewCell *)cartViewCell indexPath:(NSIndexPath *)indexPath {
    [self deleteDate:indexPath];
 
}

@end
