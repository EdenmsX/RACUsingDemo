//
//  ViewController.m
//  RACDemo
//
//  Created by 刘李斌 on 2020/5/28.
//  Copyright © 2020 Brilliance. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC.h>
#import <AFNetworking.h>

#import "Person.h"

#import "NetWorkTools.h"

@interface ViewController ()

/** per */
@property(nonatomic, strong) Person *person;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self racListenInKVO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.name = [NSString stringWithFormat:@"test %d", arc4random_uniform(1000)];
}


- (void)networkToolsDemo {
    //监听信号
    [[[NetWorkTools sharedTools] getRequestWithURL:@"https://www.baidu.com" params:nil progress:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"success %@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"error %@", error);
    }];
}

- (void)racListenInSystem {
    //监听APP进入后台
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"APP进入后台了");
    }];
}

- (void)racListenInTextField {
    [[self.textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"textField的内容变为: %@",x);
    }];
}

- (void)racListenInBtnEvent {
    [[self.btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"按钮被点击了");
    }];
}

- (void)racListenInKVO {
    
    self.person = [[Person alloc] init];
    
    //监听person中name的变化
    @weakify(self);
    [RACObserve(self.person, name) subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        @strongify(self);
        self.nameLabel.text = x;
    }];
}


@end
