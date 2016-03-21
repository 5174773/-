//
//  CartViewCell.h
//  购物车
//
//  Created by itJG on 16/3/15.
//  Copyright © 2016年 itJG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CartModel.h"
#import "Masonry.h"

//16进制RGB的颜色转换
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//R G B 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//红色
#define BASECOLOR_RED [UIColor \
colorWithRed:((float)((0xED5565 & 0xFF0000) >> 16))/255.0 \
green:((float)((0xED5565 & 0xFF00) >> 8))/255.0 \
blue:((float)(0xED5565 & 0xFF))/255.0 alpha:1.0]


/**
 *  cell是否被选中的回调
 */
typedef void(^LQQCartBlock)(BOOL select);

/**
 *  数量改变的回调
 */
typedef void(^LQQNumChange)();

@class CartViewCell;
@protocol CartViewCellDelegate <NSObject>

@optional
- (void)cartViewCell:(CartViewCell *)cartViewCell indexPath:(NSIndexPath *)indexPath;

@end


@interface CartViewCell : UITableViewCell


@property (nonatomic, assign) NSUInteger countNum;

@property (nonatomic, strong) NSIndexPath *indexPath;

//数量
@property (nonatomic,retain)UILabel *numberLabel;

@property (nonatomic,assign)BOOL isSelected;
@property (nonatomic,copy)LQQCartBlock cartBlock;
@property (nonatomic,copy)LQQNumChange numAddBlock;
@property (nonatomic,copy)LQQNumChange numCutBlock;


@property (nonatomic, weak) id <CartViewCellDelegate> delegate;

/**
 *  @author LQQ, 16-02-18 11:02:39
 *
 *  刷新cell
 *
 *  @param model cell数据模型
 */
-(void)reloadDataWith:(CartModel*)model;

@end
