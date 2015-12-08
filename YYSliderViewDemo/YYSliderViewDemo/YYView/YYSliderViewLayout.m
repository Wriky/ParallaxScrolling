//
//  YYSliderViewLayout.m
//  YYSliderViewDemo
//
//  Created by REiFON-MAC on 15/12/7.
//  Copyright © 2015年 L. All rights reserved.
//

#import "YYSliderViewLayout.h"



@interface YYSliderViewLayout ()

@property(nonatomic, assign) NSUInteger count;

@end

@implementation YYSliderViewLayout

- (id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(320.f, CELL_HEIGHT);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        
    }
    return self;
}

- (void)setContentSize:(NSUInteger)count
{
    _count = count;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    return attr;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(CELL_WIDTH, HEADER_HEIGHT+DRAG_INTERVAL*_count+(SCREENHEIGHT-DRAG_INTERVAL));
}

- (void)prepareLayout
{
    [super prepareLayout];
}


#pragma mark - selfDefine
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    float screen_y = self.collectionView.contentOffset.y;
    float current_floor = floorf((screen_y-HEADER_HEIGHT)/DRAG_INTERVAL)+1;
    float current_mod = fmodf(screen_y-HEADER_HEIGHT, DRAG_INTERVAL);
    float percent = current_mod/DRAG_INTERVAL;
    
    CGRect correctRect;
    if (current_floor == 0 || current_floor == 1) {
        correctRect = CGRectMake(0, 0, 320.f, RECT_RANGE);
    }else{
        correctRect = CGRectMake(0, HEADER_HEIGHT*2+CELL_HEIGHT*(current_floor-2), CELL_WIDTH, RECT_RANGE);
    }
    
    NSArray *array = [super layoutAttributesForElementsInRect:correctRect];
    CGFloat riseOfCurrentItem = CELL_CURRHEIGHT-DRAG_INTERVAL;
    CGFloat incrementalHeightOfCurrentItem =CELL_CURRHEIGHT-CELL_HEIGHT;
    CGFloat offsetOfNextItem = incrementalHeightOfCurrentItem - riseOfCurrentItem;
    
    if (screen_y >= HEADER_HEIGHT) {
        for (UICollectionViewLayoutAttributes *attributes in array) {
            NSInteger row = attributes.indexPath.row;
            if (row < current_floor) {
                attributes.zIndex = 0;
                attributes.frame = CGRectMake(0, (HEADER_HEIGHT-DRAG_INTERVAL)+DRAG_INTERVAL*row, CELL_WIDTH, CELL_CURRHEIGHT);
                [self setEffectViewAlpha:1.f forIndexPath:attributes.indexPath];
            }else if(row == current_floor){
                attributes.zIndex = 1;
                attributes.frame = CGRectMake(0, (HEADER_HEIGHT-DRAG_INTERVAL)+DRAG_INTERVAL*row, CELL_WIDTH, CELL_CURRHEIGHT);
                [self setEffectViewAlpha:1 forIndexPath:attributes.indexPath];
            }else if (row == current_floor+1){
                attributes.zIndex = 2;
                attributes.frame = CGRectMake(0, attributes.frame.origin.y+(current_floor-1)*offsetOfNextItem-riseOfCurrentItem*percent, CELL_WIDTH, CELL_HEIGHT+(CELL_CURRHEIGHT-CELL_HEIGHT)*percent);
                [self setEffectViewAlpha:percent forIndexPath:attributes.indexPath];
            }else{
                attributes.zIndex = 0;
                attributes.frame = CGRectMake(0, attributes.frame.origin.y+(current_floor-1)*offsetOfNextItem+offsetOfNextItem*percent, CELL_WIDTH, CELL_HEIGHT);
                [self setEffectViewAlpha:0 forIndexPath:attributes.indexPath];
            }
            [self setImageViewOfItem:(screen_y-attributes.frame.origin.y)/568.f*IMAGEVIEW_MOVE_DISTANCE withIndexPath:attributes.indexPath];
        }
    }else{
        for (UICollectionViewLayoutAttributes *attributes in array) {
            if (attributes.indexPath.row > 1) {
                [self setEffectViewAlpha:0 forIndexPath:attributes.indexPath];
            }
            [self setImageViewOfItem:(screen_y-attributes.frame.origin.y)/568.f*IMAGEVIEW_MOVE_DISTANCE withIndexPath:attributes.indexPath];
        }
    }
    
    return array;
}

//设置CELL里imageView的位置偏移动画
- (void)setImageViewOfItem:(CGFloat)distance withIndexPath:(NSIndexPath *)indexpath
{
    YYSlideViewCell *cell = (YYSlideViewCell *)[self.collectionView cellForItemAtIndexPath:indexpath];
    cell.backImgView.frame = CGRectMake(0, IMAGEVIEW_ORIGIN_Y+distance, CELL_WIDTH, cell.backImgView.frame.size.height);
}

- (void)setEffectViewAlpha:(CGFloat)percent forIndexPath:(NSIndexPath *)indexPath
{
    YYSlideViewCell *cell = (YYSlideViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.maskView.alpha = MAX((1-percent)*0.6, 0.2);
    cell.descLabel.alpha = percent*0.85;
    cell.descLabel.frame =  CGRectMake(10, 85+percent*60, cell.descLabel.frame.size.width, cell.descLabel.frame.size.height);
    cell.titleLabel.layer.transform = CATransform3DMakeScale(0.5+0.5*percent, 0.5+0.5*percent, 1);
    cell.titleLabel.center = CGPointMake(SCREENWIDTH/2, CELL_HEIGHT/2+(CELL_CURRHEIGHT-CELL_HEIGHT)/2*percent);
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGPoint destination;
    CGFloat positionY;
    CGFloat screen_y = self.collectionView.contentOffset.y;
    CGFloat cc;
    CGFloat count;
    
    if (screen_y < 0) {
        return proposedContentOffset;
    }
    
    if (0 == velocity.y) {//此情况可能由于拖拽不放手，停下时再放手的可能，所以加速度为0
        count = roundf((proposedContentOffset.y-HEADER_HEIGHT)/DRAG_INTERVAL)+1;
        if (0 == count) {
            positionY = 0;
        }else{
            positionY = HEADER_HEIGHT+(count-1)*DRAG_INTERVAL;
        }
    }else{
        if (velocity.y > 1) {
            cc = 1;
        }else if (velocity.y < -1){
            cc = -1;
        }else{
            cc = velocity.y;
        }
        
        if (velocity.y > 0) {
            count = ceilf((screen_y + cc*DRAG_INTERVAL - HEADER_HEIGHT)/DRAG_INTERVAL)+1;
        }else{
            count = floorf((screen_y + cc*DRAG_INTERVAL - HEADER_HEIGHT)/DRAG_INTERVAL)+1;
        }
        
        if (count == 0) {
            positionY = 0;
        }else{
            positionY = HEADER_HEIGHT+(count-1)*DRAG_INTERVAL;
        }
    }
    
    if (positionY < 0) {
        positionY = 0;
    }
    
    if (positionY > self.collectionView.contentSize.height - SCREENHEIGHT) {
        positionY = self.collectionView.contentSize.height - SCREENHEIGHT;
    }
    
    destination = CGPointMake(0, positionY);
    self.collectionView.decelerationRate = 0.8f;
    
    return destination;
}
@end
