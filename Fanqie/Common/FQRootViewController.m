//
//  FQRootViewController.m
//  Fanqie
//
//  Created by 周建波 on 2019/3/13.
//  Copyright © 2019 周建波. All rights reserved.
//

#import "FQRootViewController.h"
#import <objc/runtime.h>
#import "FQHomeViewController.h"
#import "FQVideoViewController.h"
#import "FQLiveViewController.h"
#import "FQMyViewController.h"


@interface FQRootViewController ()

@end

@implementation FQRootViewController

#pragma mark -  -----------------以下两个方法解决ios12.1tabbar图标位移问题，如以后IOS12.1解决则可移除--------------

/**
 *  用 block 重写某个 class 的指定方法
 *  @param targetClass 要重写的 class
 *  @param targetSelector 要重写的 class 里的实例方法，注意如果该方法不存在于 targetClass 里，则什么都不做
 *  @param implementationBlock 该 block 必须返回一个 block，返回的 block 将被当成 targetSelector 的新实现，所以要在内部自己处理对 super 的调用，以及对当前调用方法的 self 的 class 的保护判断（因为如果 targetClass 的 targetSelector 是继承自父类的，targetClass 内部并没有重写这个方法，则我们这个函数最终重写的其实是父类的 targetSelector，所以会产生预期之外的 class 的影响，例如 targetClass 传进来  UIButton.class，则最终可能会影响到 UIView.class），implementationBlock 的参数里第一个为你要修改的 class，也即等同于 targetClass，第二个参数为你要修改的 selector，也即等同于 targetSelector，第三个参数是 targetSelector 原本的实现，由于 IMP 可以直接当成 C 函数调用，所以可利用它来实现“调用 super”的效果，但由于 targetSelector 的参数个数、参数类型、返回值类型，都会影响 IMP 的调用写法，所以这个调用只能由业务自己写。
 */
CG_INLINE BOOL
OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(Class originClass, SEL originCMD, IMP originIMP)) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    if (!originMethod) {
        return NO;
    }
    IMP originIMP = method_getImplementation(originMethod);
    method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originIMP)));
    return YES;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (@available(iOS 12.1, *)) {
            OverrideImplementation(NSClassFromString(@"UITabBarButton"), @selector(setFrame:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP originIMP) {
                return ^(UIView *selfObject, CGRect firstArgv) {
                    
                    if ([selfObject isKindOfClass:originClass]) {
                        // 如果发现即将要设置一个 size 为空的 frame，则屏蔽掉本次设置
                        if (!CGRectIsEmpty(selfObject.frame) && CGRectIsEmpty(firstArgv)) {
                            return;
                        }
                    }
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, CGRect);
                    originSelectorIMP = (void (*)(id, SEL, CGRect))originIMP;
                    originSelectorIMP(selfObject, originCMD, firstArgv);
                };
            });
        }
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addVC];
}

-(void)addVC{
   
    FQVideoViewController*video = [[FQVideoViewController alloc]init];
//    FQLiveViewController*live = [[FQLiveViewController alloc]init];
   
     UINavigationController*homeNavi = [UIStoryboard storyboardWithName:@"HomeStoryboard" bundle:nil].instantiateInitialViewController;
    homeNavi.tabBarItem = [self tabBarItemWithTitle:@"社区" NormalImage:@"shouye（未选中）" SelectImage:@"shouye（选择）"];
    UINavigationController*videoNavi= [[UINavigationController alloc]initWithRootViewController:video];
    videoNavi.tabBarItem  = [self tabBarItemWithTitle:@"视频" NormalImage:@"caifu（未选中）" SelectImage:@"caifu（选中）"];
    
    UINavigationController*liveNavi = [UIStoryboard storyboardWithName:@"FQLiveStoryboard" bundle:nil].instantiateInitialViewController;;
    liveNavi.tabBarItem = [self tabBarItemWithTitle:@"直播" NormalImage:@"touzi（未选中）" SelectImage:@"touzi（选中）"];
    UINavigationController*myNavi = [UIStoryboard storyboardWithName:@"FQMyStoryboard" bundle:nil].instantiateInitialViewController;
    myNavi.tabBarItem = [self tabBarItemWithTitle:@"我的" NormalImage:@"wode(未选中）" SelectImage:@"wode(选中）"];
    self.viewControllers = @[homeNavi,videoNavi,liveNavi,myNavi];
    [self.tabBar setBarTintColor:[UIColor whiteColor]];

    
    
}

-(UITabBarItem*)tabBarItemWithTitle:(NSString*)title NormalImage:(NSString*)normalImage SelectImage:(NSString*)selectImage{
    
    UITabBarItem*item = [[UITabBarItem alloc]initWithTitle:title image:[UIImage imageNamed:normalImage] selectedImage:[UIImage imageNamed:selectImage]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x999999)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xFB2020)} forState:UIControlStateSelected];
    return item;
}

@end
