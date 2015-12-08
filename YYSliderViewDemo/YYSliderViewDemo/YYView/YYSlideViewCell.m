//
//  YYSlideViewCell.m
//  YYSliderViewDemo
//
//  Created by REiFON-MAC on 15/12/7.
//  Copyright © 2015年 L. All rights reserved.
//

#import "YYSlideViewCell.h"


@interface YYSlideViewCell ()

@property(nonatomic) NSUInteger cellIndex;

@end

@implementation YYSlideViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,IMAGEVIEW_ORIGIN_Y - self.frame.origin.y/568*IMAGEVIEW_MOVE_DISTANCE, CELL_WIDTH, SC_IMAGEVIEW_HEIGHT)];
    _backImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_backImgView];
    
    _maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, 250.f)];
    _maskView.alpha = 0.6;
    _maskView.backgroundColor = [UIColor blackColor];
    [self addSubview:_maskView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CELL_HEIGHT-TITLE_HEIGHT)/2, CELL_WIDTH, TITLE_HEIGHT)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:30.f];
    _titleLabel.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.f);
    self.contentMode = UIViewContentModeCenter;
    _titleLabel.center = self.contentView.center;
    [self addSubview:_titleLabel];
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (CELL_HEIGHT-TITLE_HEIGHT)/2+30.f, 300.f, 0)];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.font = [UIFont systemFontOfSize:14.f];
    _descLabel.alpha = 0.0f;
    [self addSubview:_descLabel];
    
}

-(void)setDescLabelStr:(NSString *)string
{
    if(string == nil || [string isEqualToString:@""]){
        return;
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    _descLabel.attributedText = str;
    _descLabel.frame = CGRectMake(10, _descLabel.frame.origin.y, 300, 30);
}

-(void)setNameLabelStr:(NSString *)string
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    _titleLabel.attributedText = str;
    
}


-(void)revisePositionAtFirstCell
{
    if (1 == self.tag) {
        _titleLabel.layer.transform = CATransform3DMakeScale(1, 1, 1);
        _titleLabel.center = CGPointMake(SCREENWIDTH/2, self.contentView.center.y);
        _descLabel.frame = CGRectMake(10, 85+60, _descLabel.frame.size.width, _descLabel.frame.size.height);
        _descLabel.alpha = 0.85;
    }
}

-(void)setIndex:(NSUInteger)index;
{
    self.cellIndex = index;
    if (0 == self.cellIndex) {
        _maskView.alpha = 0;
        self.backgroundColor = [UIColor lightGrayColor];
    }else if(1 == self.cellIndex){
        _maskView.alpha = 0.2f;
        self.backgroundColor = [UIColor blackColor];
    }else{
        _maskView.alpha = 0.6f;
        self.backgroundColor = [UIColor blackColor];
    }
    [self setImagePosition];
}

- (void)setImagePosition
{
    if (_backImgView) {
    
        _backImgView.frame = CGRectMake(0,IMAGEVIEW_ORIGIN_Y - self.frame.origin.y/568*IMAGEVIEW_MOVE_DISTANCE, CELL_WIDTH, SC_IMAGEVIEW_HEIGHT);
    }
}

//重置属性
-(void)reset
{
    _backImgView.image = nil;
    _titleLabel.text = @"";
    _descLabel.text = @"";
}

@end
