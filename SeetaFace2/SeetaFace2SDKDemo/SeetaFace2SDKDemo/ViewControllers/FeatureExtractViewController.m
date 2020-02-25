//
//  FeatureExtractViewController.m
//  SeetaFace2SDKDemo
//
//  Created by 49you on 2019/12/20.
//  Copyright © 2019 nrh. All rights reserved.
//

#import "FeatureExtractViewController.h"
#import <SeetaFace2SDK/SeetaFace2SDK.h>
#import "Tools.h"

@interface FeatureExtractViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSArray *_featuresArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation FeatureExtractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)startButtonClick:(id)sender {
    [self camera];
}


- (IBAction)saveItemClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存" message:@"保存人脸特征到本地" preferredStyle:UIAlertControllerStyleAlert];
    // 添加输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入特征标识";
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *name = alert.textFields.firstObject.text;
        if (!name || name.length == 0) {
            [Tools showToastWithMessage:@"姓名不能为空"];
            return;
        }
        if (self->_featuresArray.count != 1024) {
            [Tools showToastWithMessage:@"特征不正确"];
            return;
        }
        // 保存
        BOOL success = [Tools saveFeatures:self->_featuresArray withName:name];
        success ? [Tools showToastWithMessage:@"保存成功"] : [Tools showToastWithMessage:@"保存失败"];
    }];
    [alert addAction:save];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    
    // 开始提取
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *arr = [SFTSDK featureExtractWithImage:image];
        [Tools showToastWithMessage:@"提取成功"];
        self->_featuresArray = [NSArray arrayWithArray:arr.firstObject];
    });
}

@end
