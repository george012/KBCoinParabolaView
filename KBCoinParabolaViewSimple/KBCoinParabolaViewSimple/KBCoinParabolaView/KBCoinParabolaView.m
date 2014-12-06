//
//  KBCoinParabolaView.m
//  KBCoinParabolaViewSimple
//
//  Created by 高文明 on 14/12/6.
//  Copyright (c) 2014年 北京浙星信息技术有限公司. All rights reserved.
//

#import "KBCoinParabolaView.h"


#define kCoinCountKey   100     //金币总数

@interface KBCoinParabolaView ()
{
    UIImageView     *_bagView;      //福袋图层
    NSMutableArray  *_coinArr;  //存放生成的所有金币对应的tag值
}

@end


@implementation KBCoinParabolaView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSelfUI];
    }
    return self;
}



- (void)didMoveToSuperview
{
    [self startSelAnimations];

}

- (void)createSelfUI
{
    _coinArr = [NSMutableArray array];
    
    //主福袋层
    _bagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hongbao_bags"]];
    _bagView.frame = self.bounds;
    _bagView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_bagView];
}

static int coinCount = 0;
- (void)startSelAnimations
{
    //初始化金币生成的数量
    coinCount = 0;
    for (int i = 0; i<kCoinCountKey; i++) {
        //延迟调用函数
        [self performSelector:@selector(initCoinViewWithInt:) withObject:[NSNumber numberWithInt:i] afterDelay:i * 0.01];
    }
}


- (void)initCoinViewWithInt:(NSNumber *)i
{
    UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_coin_%d",[i intValue] % 4 + 1]]];
    
    //初始化金币的最终位置
    coin.center = CGPointMake(self.center.x+ arc4random()%40 * (arc4random() %3 - 1) - 10, self.center.y -10);
    [_coinArr addObject:coin];
    
    [self.superview addSubview:coin];
    
    [self setAnimationWithLayer:coin];
}

- (void)setAnimationWithLayer:(UIView *)coin
{
    if (self.superview != nil) {
        
        CGFloat duration = 0.8f;
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        //绘制从底部到福袋口之间的抛物线
        CGFloat positionX   = coin.layer.position.x;    //终点x
        CGFloat positionY   = coin.layer.position.y;    //终点y
        CGMutablePathRef path = CGPathCreateMutable();
        int fromX       = arc4random() % (int)self.superview.frame.size.width;     //起始位置:x轴上随机生成一个位置
        int height      = self.frame.origin.y+ self.frame.size.height + coin.frame.size.height;      //y轴以屏幕高度为准
        int fromY       = arc4random() % (int)(self.frame.origin.y+self.frame.size.height);               //起始位置:生成位于福袋上方的随机一个y坐标
        
        CGFloat cpx = positionX + (fromX - positionX)/2;            //x控制点
        CGFloat cpy = fromY / 2 - positionY;                        //y控制点,确保抛向的最大高度在屏幕内,并且在福袋上方(负数)
        
        //动画的起始位置
        CGPathMoveToPoint(path, NULL, fromX, height);
        CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, positionX, positionY);
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        [animation setPath:path];
        CFRelease(path);
        path = nil;
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        //图像由大到小的变化动画
        CGFloat from3DScale = 1 + arc4random() % 10 *0.1;
        CGFloat to3DScale = from3DScale * 0.5;
        CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
        scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        
        ////////////////////////////////////////////////////////////////////////////////////////////
        //动画组合
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.delegate = self;
        group.duration = duration;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        group.animations = @[scaleAnimation, animation];
        [coin.layer addAnimation:group forKey:@"position and transform"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        //动画完成后把金币从 父视图 和数组中 移除
        UIView *coinView = _coinArr[0];
        [coinView removeFromSuperview];
        [_coinArr removeObjectAtIndex:0];
        
        //全部金币完成动画后执行的动作
        if (++coinCount == kCoinCountKey) {
            [self bagShakeAnimation];
        }
    }
}

//福袋晃动动画
- (void)bagShakeAnimation
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:- 0.2];
    shake.toValue   = [NSNumber numberWithFloat:+ 0.2];
    shake.duration = 0.1;
    shake.autoreverses = YES;
    shake.repeatCount = 4;
    
    [_bagView.layer addAnimation:shake forKey:@"bagShakeAnimation"];
}



@end
