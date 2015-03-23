//
//  HTTickerLabel.m
//  HTTickerLabel
//
//  Created by zhs on 17-3-15.
//  Copyright (c) 2013年 HuaZhu. All rights reserved.
//

#import "HTTickerLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface HTTickerCharacterView : UIView

@property (nonatomic, strong) NSArray *charactersArray;
@property (nonatomic, strong) NSString *selectedCharacter;
@property (nonatomic, strong) NSArray *textLabels;

@property (nonatomic, unsafe_unretained) float changeTextAnimationDuration;
@property (nonatomic, unsafe_unretained) HTTickerLabelScrollDirection scrollDirection;
@property (nonatomic, unsafe_unretained) NSInteger selectedTickerCharacterIndex;

- (void)setSelectedCharacter:(NSString *)selectedCharacter animated:(BOOL)animated;
- (id)initWithFrame:(CGRect)frame textLabels:(NSArray *)textLabels;

@end

@implementation HTTickerCharacterView

@synthesize charactersArray = _charactersArray;
@synthesize selectedCharacter = _selectedCharacter;
@synthesize textLabels = _textLabels;
@synthesize changeTextAnimationDuration = _changeTextAnimationDuration;

- (id)initWithFrame:(CGRect)frame textLabels:(NSArray *)textLabels{
    
    if(self = [super initWithFrame: frame]){
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabels = textLabels;
        for (UILabel *item in self.textLabels) {
            [self addSubview: item];
        }
        
    }
    
    return self;
}

- (CGFloat)positionYForCharacterAtIndex:(NSInteger)index{
    UILabel *textLabel = [self.textLabels objectAtIndex:index];
    return -textLabel.frame.origin.y;
}

- (void)animateToPositionY:(CGFloat)positionY withCallback:(void(^)(void))callback{
    
    CGRect newFrame = self.frame;
    newFrame.origin.y = positionY;
    
    [UIView animateWithDuration:self.changeTextAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = newFrame;
    } completion:^(BOOL finished) {
        callback();
    }];

//    [UIView animateWithDuration:self.changeTextAnimationDuration animations:^{
//        self.frame = newFrame;
//    } completion:^(BOOL finished) {
//        
//        callback();
//    }];
}

- (void)setSelectedCharacter:(NSString *)selectedCharacter animated:(BOOL)animated{
    
    if(self.scrollDirection == HTTickerLabelScrollDirectionUp){
        
        NSInteger selectedCharacterIndex = [selectedCharacter integerValue];
        
        if(selectedCharacterIndex < self.selectedTickerCharacterIndex){
            
            [self animateToPositionY:[self positionYForCharacterAtIndex: selectedCharacterIndex] withCallback:^{
                self.selectedCharacter = selectedCharacter;
                self.selectedTickerCharacterIndex = selectedCharacterIndex;

            }];
        }
        else if(selectedCharacterIndex > self.selectedTickerCharacterIndex){
            
            //We try to find the chatracter in secod part of array
            for(unsigned long i = [self.charactersArray count] / 2; i < [self.charactersArray count]; i++){
                
                if([self.charactersArray[i] isEqualToString: selectedCharacter]){
                    selectedCharacterIndex = i;
                    break;
                }
            }
            
            [self animateToPositionY:[self positionYForCharacterAtIndex: selectedCharacterIndex] withCallback:^{
                self.selectedCharacter = selectedCharacter;
                self.selectedTickerCharacterIndex = [self.charactersArray indexOfObject: selectedCharacter];
            }];
        }
    }
    else{
        

        
        NSInteger selectedCharacterIndex = [self.charactersArray count] - 1 - [selectedCharacter integerValue];
        
        if(selectedCharacterIndex < self.selectedTickerCharacterIndex){
            
            [self animateToPositionY:[self positionYForCharacterAtIndex: selectedCharacterIndex] withCallback:^{
                self.selectedCharacter = selectedCharacter;
                self.selectedTickerCharacterIndex = selectedCharacterIndex;
            }];
        }
        else if(selectedCharacterIndex > self.selectedTickerCharacterIndex){
            
            //We try to find the chatracter in secod part of array
            for(unsigned long i = [self.charactersArray count] / 2; i < [self.charactersArray count]; i++){
                
                if([self.charactersArray[i] isEqualToString: selectedCharacter]){
                    selectedCharacterIndex = i;
                    break;
                }
            }
            
            [self animateToPositionY:[self positionYForCharacterAtIndex: selectedCharacterIndex] withCallback:^{
                self.selectedCharacter = selectedCharacter;
                self.selectedTickerCharacterIndex = selectedCharacterIndex;//[self.charactersArray indexOfObject: selectedCharacter];
            }];
        }
    }
}

@end

@interface HTTickerLabel()

@property (nonatomic, strong) NSMutableArray *characterViewsArray;
@property (nonatomic, strong) NSArray *charactersArray;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
/*!
 * 单个字符宽度
 */
@property (nonatomic, unsafe_unretained) float characterWidth;
@end

@implementation HTTickerLabel

@synthesize text = _text;
@synthesize font = _font;
@synthesize characterWidth = _characterWidth;
@synthesize textColor = _textColor;
@synthesize changeTextAnimationDuration = _changeTextAnimationDuration;


- (id)initWithFrame:(CGRect)frame
{
    CGRect newFrame = frame;
    newFrame.size.width = 0;
    self = [super initWithFrame:newFrame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.characterWidth = newFrame.size.height*0.5;
        self.font = [UIFont systemFontOfSize: 12.];
        self.textColor = [UIColor blackColor];
        self.characterViewsArray = [NSMutableArray array];
        self.changeTextAnimationDuration = 1.f;
        self.scrollDirection = HTTickerLabelScrollDirectionDown;
        
        [self addMaskLayer];
    }
    return self;
}

#pragma mark MaskLayer

- (CGRect)maskLayerFrame{
    
    CGRect frame = CGRectZero;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    //FIXME:==
    frame.size.height = self.frame.size.height;
    frame.origin.x = 0;
    frame.origin.y = 0;
    
    return frame;
}

- (void)updateMaskLayerPath{
    
    CGPathRef path = CGPathCreateWithRect([self maskLayerFrame], NULL);
    self.maskLayer.path = path;
    CGPathRelease(path);
}

- (void)addMaskLayer{
    
    self.maskLayer = [CAShapeLayer layer];
    
    CGPathRef path = CGPathCreateWithRect([self maskLayerFrame], NULL);
    self.maskLayer.path = path;
    CGPathRelease(path);
    
    [self.maskLayer setFillColor: [UIColor redColor].CGColor];
    [self.layer setMask: self.maskLayer];
}

#pragma mark HTTickerCharacterView
- (void)addMoneyLabel
{
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.characterWidth, self.frame.size.height)];
    moneyLabel.font = self.font;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.backgroundColor = [UIColor clearColor];
    moneyLabel.textColor = self.textColor;
    moneyLabel.numberOfLines = 1;
    moneyLabel.text = @"¥";
    [self addSubview:moneyLabel];
}

- (void)insertNewTickerCharacterView{
    
    if ([self.characterViewsArray count] == 0) {
        [self addMoneyLabel];
    }
    
    NSMutableArray *characterLabels = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [self.charactersArray count]; i++) {
        float singleLineHeight = self.frame.size.height;
        CGRect aRect = CGRectMake(0, singleLineHeight*i, self.characterWidth, singleLineHeight);
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:aRect];
        textLabel.font = self.font;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = self.textColor;
        
        textLabel.text = self.charactersArray[i];

        [characterLabels addObject:textLabel];
    }

    CGRect tickerCharacterViewFrame = self.bounds;
    //FIXME:==
    tickerCharacterViewFrame.size.height = self.frame.size.height*self.charactersArray.count;
    tickerCharacterViewFrame.origin.y = (self.scrollDirection == HTTickerLabelScrollDirectionDown) ? -self.frame.size.height * ([self.charactersArray count] - 1) : 0;
    HTTickerCharacterView *numbericView = [[HTTickerCharacterView alloc] initWithFrame:tickerCharacterViewFrame textLabels: characterLabels];
    numbericView.selectedCharacter = @"0";
    numbericView.selectedTickerCharacterIndex = [self.charactersArray count] - 1;
    
    numbericView.charactersArray = self.charactersArray;
    numbericView.scrollDirection = self.scrollDirection;
    numbericView.changeTextAnimationDuration = self.changeTextAnimationDuration;

    CGRect myframe = numbericView.frame;
    myframe.origin.y = (self.scrollDirection == HTTickerLabelScrollDirectionDown) ? -self.frame.size.height * ([self.charactersArray count] - 1) : 0;
    numbericView.frame = myframe;
    
    [self addSubview: numbericView];
    
    [self.characterViewsArray addObject: numbericView];
}

- (void)deleteCharacterView{
    
    HTTickerCharacterView *numericView = [self.characterViewsArray objectAtIndex:0];
    [numericView removeFromSuperview];
    [self.characterViewsArray removeObject: numericView];

}

#pragma mark Frames
- (void)updateSelfFrame{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut //设置动画类型
                     animations:^{
                         CGRect newViewFrame = weakSelf.frame;
                         newViewFrame.size.width = ([weakSelf.characterViewsArray count]+1) * weakSelf.characterWidth;
                         newViewFrame.origin.x += weakSelf.frame.size.width - newViewFrame.size.width;

                         weakSelf.frame = newViewFrame;

                     }
                     completion:^(BOOL finished) {
                         
                     }
     ];

}

- (void)updateTickerCharacterViewsFrames{
    
    __block float originX = self.characterWidth;
    [self.characterViewsArray enumerateObjectsUsingBlock:^(HTTickerCharacterView *numericView, NSUInteger idx, BOOL *stop) {
        
        CGRect numericViewFrame = numericView.frame;
        numericViewFrame.origin.x = originX;
        numericViewFrame.size.width = self.characterWidth;
        numericView.frame = numericViewFrame;
 
        originX += self.characterWidth;
    }];
}

- (void)updateUIFrames{
    
    [self updateSelfFrame];
    [self updateMaskLayerPath];
    [self updateTickerCharacterViewsFrames];
}

#pragma mark Interface

- (void)setScrollDirection:(HTTickerLabelScrollDirection)scrollDirection{
    
    if(scrollDirection != _scrollDirection){
        
        _scrollDirection = scrollDirection;
        
        if(scrollDirection == HTTickerLabelScrollDirectionDown){
            self.charactersArray = @[@"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", @"1", @"0", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", @"1", @"0"];
        }
        else{
            self.charactersArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
        }
        
        [self.characterViewsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            HTTickerCharacterView *numericView = (HTTickerCharacterView *)obj;
            [numericView setScrollDirection: _scrollDirection];
        }];
    }
}

- (void)setChangeTextAnimationDuration:(float)changeTextAnimationDuration{
    
    if(_changeTextAnimationDuration != changeTextAnimationDuration){
        
        _changeTextAnimationDuration = changeTextAnimationDuration;
        
        [self.characterViewsArray enumerateObjectsUsingBlock:^(HTTickerCharacterView *obj, NSUInteger idx, BOOL *stop) {
            obj.changeTextAnimationDuration = changeTextAnimationDuration;
        }];
    }
}

- (void)setTextColor:(UIColor *)textColor{
    
    if(![_textColor isEqual: textColor]){
        
        _textColor = textColor;
        
    }
}

- (void)setFont:(UIFont *)font{
    
    if(![_font isEqual: font]){
        
        _font = font;
        
        [self updateUIFrames];
    }
}

- (void)setCharacterWidth:(float)characterWidth{
    
    if(_characterWidth != characterWidth){
        
        _characterWidth = characterWidth;
        
        [self updateUIFrames];
    }
}

- (void)setText:(NSString *)text{
    
    if(![_text isEqualToString: text]){
        
        NSInteger oldTextLength = [_text length];
        NSInteger newTextLength = [text length];
        
        if(newTextLength > oldTextLength){
            
            NSInteger textLengthDelta = newTextLength - oldTextLength;
            for(int i = 0 ; i < textLengthDelta; i++){
                
                [self insertNewTickerCharacterView];
            }
            
            [self updateUIFrames];
        }
        else if(newTextLength < oldTextLength){
            
            NSInteger textLengthDelta = oldTextLength - newTextLength;
            
            
            for(int i = 0 ; i < textLengthDelta; i++){
                
                [self deleteCharacterView];
            }
            
            [self updateUIFrames];
        }
        
        [self.characterViewsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            HTTickerCharacterView *numericView = (HTTickerCharacterView *)obj;
            [numericView setSelectedCharacter:[text substringWithRange:NSMakeRange(idx, 1)] animated:YES];
        }];
        
        _text = text;
        
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
