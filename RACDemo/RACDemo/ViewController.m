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
