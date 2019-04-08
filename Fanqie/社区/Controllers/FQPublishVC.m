//
//  FQPublishVC.m
//  Fanqie
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 周建波. All rights reserved.
//

#import "FQPublishVC.h"
#import "CoreManager+Home.h"
//#import <TZImagePickerController.h>
#import <QiniuSDK.h>
#import <QBImagePickerController.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FQPublishVC ()<QBImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITextField *titleTextfiel;
///发布短文是显示
@property (weak, nonatomic) IBOutlet UIView *characterView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *vedioView;
@property (weak, nonatomic) IBOutlet UICollectionView *pictureCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;


@property (weak, nonatomic) IBOutlet UIButton *vedioButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIButton *characterButton;
@property (nonatomic, strong) UIButton* selectButton;
@property (weak, nonatomic) IBOutlet UIButton *postButton;


///图片数组(缩略图显示)
@property (nonatomic,strong)NSMutableArray*imageArray;
///图片地址数组
@property (nonatomic,strong)NSMutableArray*imageUrls;

@property (nonatomic,strong)NSString*vedioUrl;

@property (nonatomic,strong)CoreManager*task;

@property (nonatomic,copy)NSString*token;

@property (nonatomic,strong)QNUploadManager * upManager;

/// 1 文本 2图片 3视频 默认3
@property (nonatomic,assign)int type;
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
    _task = [[CoreManager alloc]init];
    [self gettoken];
    _type = 3;
    [self bind];
    _imageUrls = [[NSMutableArray alloc]init];
    _upManager = [[QNUploadManager alloc] init];
    [self setCollectionView];
}
-(void)gettoken{
    @weakify(self)
    [_task fq_qiniu_tokenCompleteBlock:^(id success) {
        @strongify(self)
        self.token = success;
    } FaildBlock:^(id error) {
        
    }];
}

-(void)setCollectionView{
    
    CGFloat padding = 10;
    CGFloat W = (iPhone_Width-26-padding*2)/3.0;
    _layout.itemSize = CGSizeMake(W, W);
    _layout.minimumLineSpacing = padding;
    _layout.minimumInteritemSpacing = padding;
    
    _pictureCollectionView.delegate = self;
    _pictureCollectionView.dataSource = self;
    _pictureCollectionView.collectionViewLayout = self.layout;
    [_pictureCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FQPictureCell"];
    _pictureCollectionView.backgroundColor = [UIColor whiteColor];
}

-(void)bind{
    @weakify(self)
    RACSignal * enableSignal = [RACSignal combineLatest:@[self.titleTextfiel.rac_textSignal,self.textView.rac_textSignal] reduce:^id(NSString*title,NSString*content){
        @strongify(self)
        if (self.type == 1) {
            return @(title.length>=4&&content.length>0&&title.length<=50);
        }
        
        if (self.type == 2) {
            return @(title.length>=4&&self.imageUrls.count>0&&title.length<=50);
        }
        
        if (self.type == 3) {
            
            return @(self.vedioUrl.length>0&&title.length>=4&&title.length<=50);
        }
        return @(0);
    }];
    
    self.postButton .rac_command = [[RACCommand alloc]initWithEnabled:enableSignal signalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self publicWithType:self.type];
        
        return [RACSignal empty];
    }];
    
}
-(void)publicWithType:(int)type{
    
    
    MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"发布中";
    @weakify(self)
    [self.task fq_communityPublicTitle:self.titleTextfiel.text Textcontent:self.textView.text Picturecontent:self.imageUrls videocontent:self.vedioUrl Type:type CompleteBlock:^(id success) {
        @strongify(self)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if(self.pulicComplete)
            {
                self.pulicComplete();
            }
            [self.navigationController popViewControllerAnimated:YES];
        });
    } FaildBlock:^(id error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    }];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 添加视频
- (IBAction)addVedio:(UIButton *)sender {
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.mediaType = QBImagePickerMediaTypeVideo;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
   
}
#pragma mark 添加图片
- (IBAction)addPicture:(id)sender {
    
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
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
            _type = 2;
        }
            break;
        case 2:
        {
            //character
            [_pictureView setHidden:YES];
            [_vedioView setHidden:YES];
            [_characterView setHidden:NO];
            _type = 1;
            
        }
            break;
            
        default:
        {
            //vedio
            [_pictureView setHidden:YES];
            [_vedioView setHidden:NO];
            [_characterView setHidden:YES];
            _type = 3;
            
        }
            break;
    }
}


- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    if (imagePickerController.mediaType == QBImagePickerMediaTypeImage) {
        for (PHAsset *asset in assets) {
            // Do something with the asset
            PHImageManager * imageManager = [PHImageManager defaultManager];
            self.imageArray = [[NSMutableArray alloc]init];
            @weakify(self)
            [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                @strongify(self)
                
                UIImage * image = [UIImage imageWithData:imageData];
                [self.imageArray addObject:image];
                if (self.imageArray.count == assets.count) {
                    [self.pictureCollectionView reloadData];
                }
            }];
            
            
        }
    }
    
    [self .imageUrls removeAllObjects];

        if (self.token.length>0) {
            @weakify(self)
            MBProgressHUD*hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.detailsLabel.text = @"上传中";

            [self uploadImages:assets Index:0 Complete:^{
                ///上传图片完成
                dispatch_async(dispatch_get_main_queue(), ^{

                    [hud hideAnimated:YES];
                });

            }];

        }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
///图片递归上传
-(void)uploadImages:(NSArray*)array Index:(int)index Complete:(void(^)(void))complete{
    __block int currentIndex = index;
    
    PHAsset*asset = array[index];
    @weakify(self)
    [_upManager putPHAsset:asset key:[self return16LetterAndNumber] token:self.token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        @strongify(self)
        [self.imageUrls addObject:key];
        if (self.imageUrls.count == array.count) {
            if (complete) {
                complete();
            }
        }else{
            currentIndex +=1;
            [self uploadImages:array Index:currentIndex++ Complete:complete];
        }
        
    } option:nil];
 
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


#pragma mark collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FQPictureCell" forIndexPath:indexPath];
    UIImageView*imageView = [cell.contentView viewWithTag:99];
    imageView= [[UIImageView alloc]initWithFrame:cell.contentView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 99;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    imageView.image = self.imageArray[indexPath.row];
    return cell;
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
