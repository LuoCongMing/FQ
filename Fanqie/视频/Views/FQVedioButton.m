//
//  FQVedioButton.m
//  Fanqie
//
//  Created by mac on 2019/4/9.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQVedioButton.h"

@implementation FQVedioButton

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
   
    return CGRectMake(0, contentRect.size.height-15, contentRect.size.width, 15);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 0, contentRect.size.width, contentRect.size.width);
}

@end
