//
//  EmitterButton.m
//  EmitterAnimation
//
//  Created by anyongxue on 2017/1/18.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "EmitterButton.h"

@interface EmitterButton ()

//两种不同的CAEmitterLayer
@property (strong, nonatomic) CAEmitterLayer *chargeLayer;
@property (strong, nonatomic) CAEmitterLayer *explosionLayer;

@end

@implementation EmitterButton

/**
 *  通过fram初始化
 *
 *  @param frame WclEmitterButton的fram
 *
 *  @return 返回WclEmitterButton对象
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    [self buttonAnimation];
}
/**
 *  配置WclEmitterButton
 */

- (void)setupLayer{

    //CAEmitterCell: CAEmitterCell是粒子发射系统里的粒子，用CAEmitterCell来定义你所需要的粒子的样式，图片，颜色，方向，运动，缩放比例和生命周期等等。
    CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
    explosionCell.name = @"explosion";
    explosionCell.alphaRange = 0.10;//一个粒子的颜色alpha能改变的范围
    explosionCell.alphaSpeed = -1.0;//粒子透明度在生命周期内的改变速度
    explosionCell.lifetime = 0.7;//生命周期
    explosionCell.lifetimeRange = 0.3;
    explosionCell.birthRate = 0;//每秒发射的粒子数量
    explosionCell.velocity = 40.00;//速度
    explosionCell.velocityRange = 10.00;//速度范围
    explosionCell.scale = 0.04;//缩放比例
    explosionCell.scaleRange = 0.02;//缩放比例范围
    explosionCell.contents = (id)[UIImage imageNamed:@"Sparkle"].CGImage;//是个CGImageRef的对象,既粒子要展现的图片
    
    //CAEmitterLayer ：CAEmitterLayer类提供了一个粒子发射器系统为核心的动画。这些粒子是由CAEmitterCell组成的实例，它相当于一个管理者，来管理 CAEmitterCell的发射的一些细节，比如发射的位置，发射形状等等。
    _explosionLayer = [CAEmitterLayer layer];
    _explosionLayer.name = @"emitterLayer";
    _explosionLayer.emitterShape = kCAEmitterLayerCircle;//发射源的形状
    _explosionLayer.emitterMode = kCAEmitterLayerOutline;//发射模式
    _explosionLayer.emitterSize = CGSizeMake(10, 0);//发射源的大小
    _explosionLayer.emitterCells = @[explosionCell];//装着CAEmitterCell对象的数组，被用于把粒子投放到layer上
    _explosionLayer.renderMode = kCAEmitterLayerOldestFirst;//渲染模式
    _explosionLayer.masksToBounds = NO;
    _explosionLayer.position      = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    _explosionLayer.zPosition     = -1;
    [self.layer addSublayer:_explosionLayer];
    
    /*
     uiview   clipsToBounds
     是指视图上的子视图,如果超出父视图的部分就截取掉,
     calayer  masksToBounds
     却是指视图的图层上的子图层,如果超出父图层的部分就截取掉
     */
    
    //CALayer中position与anchorPoint详解 http://www.cnblogs.com/AbeDay/p/5026870.html
    
    CAEmitterCell *chargeCell = [CAEmitterCell emitterCell];
    chargeCell.name = @"charge";
    chargeCell.alphaRange = 0.10;
    chargeCell.alphaSpeed = -1.0;
    chargeCell.lifetime = 0.3;
    chargeCell.lifetimeRange = 0.1;
    chargeCell.birthRate = 0;
    chargeCell.velocity = -40.0;
    chargeCell.velocityRange = 0.00;
    chargeCell.scale = 0.03;
    chargeCell.scaleRange = 0.02;
    chargeCell.contents = (id)[UIImage imageNamed:@"Sparkle"].CGImage;

    _chargeLayer               = [CAEmitterLayer layer];
    _chargeLayer.name          = @"emitterLayer";
    _chargeLayer.emitterShape  = kCAEmitterLayerCircle;
    _chargeLayer.emitterMode   = kCAEmitterLayerOutline;
    _chargeLayer.emitterSize   = CGSizeMake(20, 0);
    _chargeLayer.emitterCells  = @[chargeCell];
    _chargeLayer.renderMode    = kCAEmitterLayerOldestFirst;
    _chargeLayer.masksToBounds = NO;
    _chargeLayer.position      = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    _chargeLayer.zPosition     = -1;
    
    [self.layer addSublayer:_chargeLayer];
}

/**
 *  开始动画
 */
- (void)buttonAnimation{
    //CABasicAnimation只能从一个数值(fromValue)变到另一个数值(toValue)，而CAKeyframeAnimation会使用一个NSArray保存这些数值
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    
    if (self.selected) {
        animation.values = @[@1.5 ,@0.8, @1.0,@1.2,@1.0];
        animation.duration = 0.5;
        [self startAnimate];
    }else{
        animation.values = @[@0.8, @1.0];
        animation.duration = 0.4;
    }
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:@"transform.scale"];
    
    /*
     CAKeyframeAnimation : http://blog.csdn.net/u011700462/article/details/37540709
     cacluationMode:在关键帧动画中还有一个非常重要的参数,那便是calculationMode,计算模式.其主要针对的是每一帧的内容为一个座标点的情况,也就是对anchorPoint 和 position 进行的动画.当在平面座标系中有多个离散的点的时候,可以是离散的,也可以直线相连后进行插值计算,也可以使用圆滑的曲线将他们相连后进行插值计算. calculationMode目前提供如下几种模式 kCAAnimationLinear
     */
}

/**
 *  开始喷射
 */
- (void)startAnimate {
    //chareLayer开始时间
    self.chargeLayer.beginTime = CACurrentMediaTime();
    //chareLayer每秒喷射的80个
    [self.chargeLayer setValue:@80 forKeyPath:@"emitterCells.charge.birthRate"];
    //进入下一个动作
    [self performSelector:@selector(explode) withObject:nil afterDelay:0.2];
    
    //NSDate 或 CFAbsoluteTimeGetCurrent() 返回的时钟时间将会会网络时间同步，从时钟 偏移量的角度，mach_absolute_time() 和 CACurrentMediaTime() 是基于内建时钟的，能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）,但它和系统的uptime有关,系统重启后CACurrentMediaTime()会被重置。
}
/**
 *  大量喷射
 */
- (void)explode {
    //让chareLayer每秒喷射的个数为0个
    [self.chargeLayer setValue:@0 forKeyPath:@"emitterCells.charge.birthRate"];
    //explosionLayer开始时间
    self.explosionLayer.beginTime = CACurrentMediaTime();
    //explosionLayer每秒喷射的2500个
    [self.explosionLayer setValue:@2500 forKeyPath:@"emitterCells.explosion.birthRate"];
    //停止喷射
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.1];
}

/**
 *  停止喷射
 */
- (void)stop {
    //让chareLayer每秒喷射的个数为0个
    [self.chargeLayer setValue:@0 forKeyPath:@"emitterCells.charge.birthRate"];
    //explosionLayer每秒喷射的0个
    [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
