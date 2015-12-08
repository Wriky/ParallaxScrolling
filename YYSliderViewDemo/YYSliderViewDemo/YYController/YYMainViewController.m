//
//  YYMainViewController.m
//  YYSliderViewDemo
//
//  Created by REiFON-MAC on 15/12/7.
//  Copyright © 2015年 L. All rights reserved.
//

#import "YYMainViewController.h"

@interface YYMainViewController ()
{
    UICollectionView *yyCollectionCiew;
    NSMutableArray *dataArray;
}
@end

@implementation YYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self configCollecionView];

}

- (void)getData
{
    dataArray = [NSMutableArray array];
    for (int i=0; i<10; i++) {
        [dataArray addObject:[NSString stringWithFormat:@"YY%d.jpg",i+1]];
       //  [dataArray addObject:@"test.jpg"];
    }
    
}

- (void)configCollecionView
{
    YYSliderViewLayout *layoutView = [[YYSliderViewLayout alloc] init];
    [layoutView setContentSize:10];
    yyCollectionCiew = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH, SCREENHEIGHT) collectionViewLayout:layoutView];
    [yyCollectionCiew registerClass:[YYSlideViewCell class] forCellWithReuseIdentifier:@"YYSlideViewCell"];
    yyCollectionCiew.delegate = self;
    yyCollectionCiew.dataSource = self;
    [self.view addSubview:yyCollectionCiew];
}

#pragma  mark - UICollectionView Delegate and Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataArray.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return CGSizeMake(CELL_WIDTH, HEADER_HEIGHT);
    }else if(indexPath.row == 1){
        return CGSizeMake(CELL_WIDTH, CELL_CURRHEIGHT);
    }else{
        return CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
    }
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YYSlideViewCell *cell = (YYSlideViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"YYSlideViewCell" forIndexPath:indexPath];
    cell.tag = indexPath.row;
    [cell setIndex:indexPath.row];
    [cell reset];
    
    if (0 == indexPath.row) {
        cell.backImgView.image = nil;
    }else{
        if (1 == indexPath.row) {
            [cell revisePositionAtFirstCell];
        }
     
        [cell setNameLabelStr:[NSString stringWithFormat:@"Gallery nickname %zi",indexPath.row]];
        [cell setDescLabelStr:[NSString stringWithFormat:@"Gallery description %zi",indexPath.row]];
        UIImage *image = [UIImage imageNamed:[dataArray objectAtIndex:indexPath.row-1]];
        cell.backImgView.image = image;
    }
    return cell;
}

@end
