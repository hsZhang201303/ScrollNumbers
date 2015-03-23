//
//  HTTickerLabel.h
//  HTTickerLabel
//
//  Created by zhs on 17-3-15.
//  Copyright (c) 2013年 HuaZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    HTTickerLabelScrollDirectionUp = 1,
    HTTickerLabelScrollDirectionDown = 2
}HTTickerLabelScrollDirection;

@interface HTTickerLabel : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSString *text;
/*!
 * 默认一秒
 */
@property (nonatomic, unsafe_unretained) float changeTextAnimationDuration;

/*!
 * 默认HTTickerLabelScrollDirectionDown
 */
@property (nonatomic, unsafe_unretained) HTTickerLabelScrollDirection scrollDirection;

@end
