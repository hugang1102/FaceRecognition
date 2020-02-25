//
//  FaceDetectionViewController.m
//  SeetaFace2SDKDemo
//
//  Created by 49you on 2019/12/20.
//  Copyright © 2019 nrh. All rights reserved.
//

#import "FaceDetectionViewController.h"
#import <SeetaFace2SDK/SeetaFace2SDK.h>

@interface FaceDetectionViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
/** layer */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation FaceDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = _photoImageView.bounds;
    [_photoImageView.layer addSublayer:_shapeLayer];
    
    _shapeLayer.lineWidth = 1;
    _shapeLayer.strokeColor = [[UIColor redColor] CGColor];
    _shapeLayer.fillColor = [[UIColor clearColor] CGColor];
}

- (IBAction)startButtonClick:(id)sender {
    [self camera];
}

- (void)camera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _photoImageView.image = image;
    
    // 开始检测
    NSDictionary *resDic = [SFTSDK detecFaceWithImage:image];
    NSLog(@"检测结果是：%@", resDic);
    
    int count = [resDic[@"count"] intValue];
    NSArray *data = [NSArray arrayWithArray:resDic[@"data"]];
    // 画矩形框
    UIBezierPath *totalPath = [UIBezierPath bezierPath];
    
    for (SFTFaceInfo *info in data) {
        CGRect tmp = CGRectMake(info.x, info.y, info.width, info.height);
        CGRect rect = [self getPathLayerRect:_shapeLayer.bounds imageSize:image.size pathRect:tmp];
        UIBezierPath *subPath = [UIBezierPath bezierPathWithRect:rect];
        [totalPath appendPath:subPath];
    }
    _shapeLayer.path = totalPath.CGPath;
}

- (CGRect)getPathLayerRect:(CGRect)layerRect imageSize:(CGSize)imageSize pathRect:(CGRect)pathRect
{
    CGFloat width = layerRect.size.width;
    CGFloat height = layerRect.size.height;
    CGFloat radio1 = width / height;
    CGFloat radio2 = imageSize.width / imageSize.height;
    
    if (radio2 > radio1) {
        // 宽度
        CGFloat tmpH = width / radio2;
        CGRect imageRect = CGRectMake(0, (height - tmpH)/2, width, tmpH);
        
        CGFloat radio = layerRect.size.width / imageSize.width;
        CGRect res = CGRectMake(pathRect.origin.x * radio, pathRect.origin.y * radio + imageRect.origin.y, pathRect.size.width * radio, pathRect.size.height * radio);
        return res;
    } else {
        // 高度
        CGFloat tmpW = height * radio2;
        CGRect imageRect = CGRectMake((width - tmpW)/2, 0, tmpW, height);
        
        CGFloat radio = layerRect.size.height / imageSize.height;
        CGRect res = CGRectMake(pathRect.origin.x * radio +  + imageRect.origin.x, pathRect.origin.y * radio, pathRect.size.width *radio, pathRect.size.height * radio);
        return res;
    }
}

@end
