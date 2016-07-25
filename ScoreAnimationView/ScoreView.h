//
//  DNJScoreHeaderView.h
//  dnj
//
//  Created by CC on 16/7/21.
//  Copyright © 2016年 CC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreView : UIView

@property (nonatomic, assign) NSInteger score;

@end

@interface AnimateButton : UIButton

- (void)animationWithIsAdd:(BOOL)isAdd;

- (void)setInitProgress:(NSInteger)score;

@end
