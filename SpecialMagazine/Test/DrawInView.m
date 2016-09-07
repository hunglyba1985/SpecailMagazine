//
//  DrawInView.m
//  SpecialMagazine
//
//  Created by Macbook Pro on 9/5/16.
//  Copyright © 2016 Macbook Pro. All rights reserved.
//

#import "DrawInView.h"

@implementation DrawInView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // Using core graphic
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    
//    // Draw them with a 2.0 stroke width so they are a bit more visible.
//    CGContextSetLineWidth(context, 2.0f);
//    
//    CGContextMoveToPoint(context, 0.0f, 0.0f); //start at this point
//    
//    CGContextAddLineToPoint(context, 20.0f, 20.0f); //draw to this point
//    
//    // and now draw the Path!
//    CGContextStrokePath(context);
    
    
    // Using UIKit
    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(10.0, 10.0)];
//    [path addLineToPoint:CGPointMake(100.0, 100.0)];
//    path.lineWidth = 3;
//    [[UIColor blueColor] setStroke];
//    [path stroke];
    
    // Draw half circle
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set]; //[[NSColor whiteColor]set];
    UIRectFill([self bounds]);
    float dim = MIN(self.bounds.size.width, self.bounds.size.height);
    int subdiv=512;
    float r=dim/4;
    float R=dim/2;
    
    float halfinteriorPerim = M_PI*r;
    float halfexteriorPerim = M_PI*R;
    float smallBase= halfinteriorPerim/subdiv;
    float largeBase= halfexteriorPerim/subdiv;
    
    UIBezierPath * cell = [UIBezierPath bezierPath];
    
    [cell moveToPoint:CGPointMake(- smallBase/2, r)];
    
    [cell addLineToPoint:CGPointMake(+ smallBase/2, r)];
    
    [cell addLineToPoint:CGPointMake( largeBase /2 , R)];
    [cell addLineToPoint:CGPointMake(-largeBase /2,  R)];
    [cell closePath];
    
    float incr = M_PI / subdiv;
    //CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextTranslateCTM(context, +self.bounds.size.width/2, +self.bounds.size.height/2);
    
    CGContextScaleCTM(context, 0.9, 0.9);
    CGContextRotateCTM(context, M_PI/2);
    CGContextRotateCTM(context,-incr/2);
    
    for (int i=0;i<subdiv;i++) {
        // replace this color with a color extracted from your gradient object
        [[UIColor colorWithHue:(float)i/subdiv saturation:1 brightness:1 alpha:1] set];
        [cell fill];
        [cell stroke];
        CGContextRotateCTM(context, -incr);
    }

//    
//    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
//    [bezierPath addArcWithCenter:CGPointMake(100, 100) radius:50 startAngle:0 endAngle:2 * M_PI clockwise:YES];
//    [[UIColor blueColor] setStroke];
//    [bezierPath stroke];

}

@end





















