//
//  CartModel.h
//  购物车
//
//  Created by itJG on 16/3/15.
//  Copyright © 2016年 itJG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CartModel : NSObject

//尺寸
@property(nonatomic,copy) NSString *sizeStr;

//名字
@property(nonatomic,copy) NSString *nameStr;

//个数
@property(nonatomic,assign) NSInteger number;

//价格
@property(nonatomic,copy) NSString *price;

//图片
@property(nonatomic,retain)UIImage *image;


//是否全选
@property(nonatomic,assign) BOOL isSelest;




@end
