//
//  FQPublishVC.m
//  Fanqie
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQPublishVC.h"
#import "TZImagePickerController.h"

@interface FQPublishVC ()<TZImagePickerControllerDelegate>
///发布短文是显示
@property (weak, nonatomic) IBOutlet UIView *characterView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *vedioView;


@property (weak, nonatomic) IBOutlet UIButton *vedioButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *characterButton;
@property (nonatomic, strong) UIButton* selectButton;

@end

@implementation FQPublishVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectButton = _vedioButton;
    _vedioButton.selected = YES;
    [_pictureView setHidden:YES];
    [_vedioView setHidden:NO];
    [_characterView setHidden:YES];
}

#pragma mark 添加视频
- (IBAction)addVedio:(UIButton *)sender {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:9 delegate:self];
    // 3. 设置是否可以选择视频/图片/原图
        imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = NO;
    
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = NO;
    
    // 设置首选语言 / Set preferred language
    imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    
    [imagePickerVc setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *asset) {
        NSLog(@"%@",coverImage);
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark 添加图片
- (IBAction)addPicture:(id)sender {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//    imagePickerVc.allowPickingOriginalPhoto = YES;
//    imagePickerVc.isSelectOriginalPhoto = YES;
//    imagePickerVc.
//    imagePickerVc.sortAscendingByModificationDate = NO;
    [self.navigationController presentViewController:imagePickerVc animated:YES completion:nil];
    
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
//    // 3. 设置是否可以选择视频/图片/原图
////    imagePickerVc.allowPickingVideo = self.allowPickingVideoSwitch.isOn;
//    imagePickerVc.allowPickingImage = YES;
//    imagePickerVc.allowPickingOriginalPhoto = YES;
//    imagePickerVc.hideWhenCanNotSelect = NO;
//    imagePickerVc.allowCrop = NO;
//    imagePickerVc.showPhotoCannotSelectLayer = YES;
//    imagePickerVc.allowPreview = YES;
//    // 4. 照片排列按修改时间升序
//    imagePickerVc.sortAscendingByModificationDate = YES;
//
//
//    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
//
//    // 设置是否显示图片序号
//    imagePickerVc.showSelectedIndex = NO;
//
//    // 设置首选语言 / Set preferred language
//     imagePickerVc.preferredLanguage = @"zh-Hans";
//
//    // You can get the photos by block, the same as by delegate.
//    // 你可以通过block或者代理，来得到用户选择的照片.
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        NSLog(@"%@",photos);
//    }];
//
//    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (IBAction)changePublicType:(UIButton*)sender {
    _selectButton.selected = NO;
    sender.selected = YES;
    _selectButton = sender;
    
    switch (sender.tag) {
        case 1:
        {
            //picture
            [_pictureView setHidden:NO];
            [_vedioView setHidden:YES];
            [_characterView setHidden:YES];
        }
            break;
        case 2:
        {
            //character
            [_pictureView setHidden:YES];
            [_vedioView setHidden:YES];
            [_characterView setHidden:NO];
            
        }
            break;
            
        default:
        {
            //vedio
            [_pictureView setHidden:YES];
            [_vedioView setHidden:NO];
            [_characterView setHidden:YES];
            
        }
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
