//
//  FQPostShortVideoVC.m
//  Fanqie
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQPostShortVideoVC.h"
#import <QiniuSDK.h>
#import <QBImagePickerController.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CoreManager+Home.h"
#import "CoreManager+Video.h"

@interface FQPostShortVideoVC ()<QBImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumbImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vedioPreView;

@property (nonatomic,strong)CoreManager*task;

@property (nonatomic,copy)NSString*token;

@property (nonatomic,strong)QNUploadManager * upManager;
///视频资源
@property (nonatomic,strong)PHAsset*asset;

@property (nonatomic,copy)NSString*videoUrl;
@end

@implementation FQPostShortVideoVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _task = [[CoreManager alloc]init];
    _upManager = [[QNUploadManager alloc] init];
    [self gettoken];
    [self bind];
}

-(void)bind{
    
    RACSignal*enableSignal = [RACSignal combineLatest:@[self.titleTextField.rac_textSignal,RACObserve(self, token)] reduce:^id(NSString*title,NSString*token){
        
        return @(title.length>0&&token.length>0);
    }];
    @weakify(self)
    self.postButton.rac_command = [[RACCommand alloc]initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadVedio:self.asset Complete:^{
                
                [self.task fq_publicShortVideoTitle:self.titleTextField.text VideoUrl:self.videoUrl Description:@"" CompleteBlock:^(id success) {
                    @strongify(self)
                    if (self.complete) {
                        self.complete();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                   
                    
                } FaildBlock:^(id error) {
                    
                    
                }];
            } Faild:^{
                
               
            }];
        });
        
        return [RACSignal empty];
    }];
}

-(void)gettoken{
    @weakify(self)
    [_task fq_qiniu_tokenCompleteBlock:^(id success) {
        @strongify(self)
        self.token = success;
    } FaildBlock:^(id error) {
        
    }];
}
- (IBAction)selectVideo:(id)sender {
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.mediaType = QBImagePickerMediaTypeVideo;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    if (imagePickerController.mediaType == QBImagePickerMediaTypeVideo) {
        self.asset = assets.firstObject;
        [self getVideoImageFromPHAsset:assets.firstObject Complete:^(UIImage *image) {
            self.vedioPreView.image = image;
        }];
    }
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)getVideoImageFromPHAsset:(PHAsset *)asset Complete:(void (^)(UIImage *image))resultBack{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        UIImage *iamge = result;
        resultBack(iamge);
    }];
}
////上传视频
-(void)uploadVedio:(PHAsset*)asset Complete:(void(^)(void))complete Faild:(void(^)(void))faild{
    
    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.detailsLabel.text = @"上传中";
    QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil
                                                        progressHandler:^(NSString *key, float percent) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                hud.detailsLabel.text = [NSString stringWithFormat:@"%d%@",(int)percent*100,@"%"];
                                                                [hud hideAnimated:YES afterDelay:0.5];
                                                            });
                                                            
                                                        }
                                                                 params:nil
                                                               checkCrc:NO
                                                     cancellationSignal:nil];
    @weakify(self)
    [_upManager putPHAsset:asset key:[self return16LetterAndNumber] token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        @strongify(self)
        if (info.error) {
            if (faild) {
                faild();
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                hud.detailsLabel.text = @"发布失败";
                [hud hideAnimated:YES afterDelay:0.5];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES ];
            });
            self.videoUrl = key;
            if (complete) {
                complete();
            }
            
        }
        
        
    } option:uploadOption];
}
//随机名称
-(NSString *)return16LetterAndNumber{
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:16];
    for (int i = 0; i < 16; i++)
    {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
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
