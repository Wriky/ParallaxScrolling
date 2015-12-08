//
//  YYSlideViewCell.h
//  YYSliderViewDemo
//
//  Created by REiFON-MAC on 15/12/7.
//  Copyright © 2015年 L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

//@protocol YYSlideViewCellDelegate <NSObject>
//@optional
//
//- (void)switchNavigator:(NSUInteger)tag;
//
//@end

@interface YYSlideViewCell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *backImgView;
@property(nonatomic, strong) UIImageView *maskView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *descLabel;

-(void)setNameLabelStr:(NSString *)string;
-(void)setDescLabelStr:(NSString *)string;
-(void)setIndex:(NSUInteger)index;
-(void)revisePositionAtFirstCell;
-(void)reset;

//@property (nonatomic, weak) id<YYSlideViewCellDelegate>delegate;

@end
