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

/** loginbtn */
@property(nonatomic, strong) UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self combineLaestDemo2];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.name = [NSString stringWithFormat:@"test %d", arc4random_uniform(1000)];
}

- (void)combineLaestDemo2 {
    UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, 200, 60)];
    accountTextField.borderStyle = UITextBorderStyleRoundedRect;
    accountTextField.placeholder = @"账号";
    [self.view addSubview:accountTextField];
    
    UITextField *pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 300, 200, 60)];
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    pwdTextField.placeholder = @"密码";
    [self.view addSubview:pwdTextField];
    
    
    
    self.loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-30, 400, 60, 40)];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self)
    //判断用户名和密码都不为空登录按钮才可以使用
    [[RACSignal combineLatest:@[accountTextField.rac_textSignal, pwdTextField.rac_textSignal] reduce:^id _Nonnull(NSString *account, NSString *pwd){
        //获取要监听的控件中的内容
        NSLog(@"account = %@, pwd = %@", account, pwd);
        //返回处理结果(以信号形式发送)
        return @(account.length > 0 && pwd.length > 0);
    }] subscribeNext:^(id  _Nullable x) {
        //接收reduceBlock发送的信号
        NSLog(@"接收到信号  %@", x);
        //根据信号做对应的操作
        @strongify(self)
        self.loginBtn.enabled = [x boolValue];
    }];
}

- (void)btnClick {
    NSLog(@"click");
}


- (void)combineLaestDemo {
    
    UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, 200, 60)];
    accountTextField.borderStyle = UITextBorderStyleRoundedRect;
    accountTextField.placeholder = @"账号";
    [self.view addSubview:accountTextField];
    
    UITextField *pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 300, 200, 60)];
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    pwdTextField.placeholder = @"密码";
    [self.view addSubview:pwdTextField];
    
    [[RACSignal combineLatest:@[accountTextField.rac_textSignal, pwdTextField.rac_textSignal]] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"%@",x);
        NSString *account = x.first;
        NSString *pwd = x.second;
    }];
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
