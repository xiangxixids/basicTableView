//
//  ViewController.m
//  TableViewBasic
//
//  Created by xixi.xxx on 16/1/20.
//  Copyright © 2016年 xixi.xxx. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@property (strong, nonatomic) NSMutableArray<NSString *> *dataSource;
@property (strong, nonatomic) NSMutableArray<NSString *> *imageList;
@property (nonatomic) UITableViewCellEditingStyle style;
@end

static NSString *CELLID = @"mycell";



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    if (self.dataSource == nil) {
        self.dataSource = [[NSMutableArray alloc]initWithObjects:@"0", @"1", @"2", @"3", @"4",@"0", @"1", @"2", @"3", @"4",@"0", @"1", @"2", @"3", @"4",@"0", @"1", @"2", @"3", @"4", nil];
    }
    if (self.imageList == nil) {
        self.imageList = [[NSMutableArray alloc]initWithObjects:@"apple",@"bananer", @"caomei",@"boluo",@"mihoutao", nil];
    }
    // tableview  有可能出现跟titlebar 有空白的情况, 这个设置能够解决
    self.automaticallyAdjustsScrollViewInsets = false;
    UINib *nib = [UINib nibWithNibName:@"MyTableViewCell" bundle:nil];
    [self.mTableView registerNib:nib forCellReuseIdentifier:CELLID];
    self.style = UITableViewCellEditingStyleNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 添加button 改变cell 是否可以移动,
- (IBAction)changeEditMode:(UIBarButtonItem *)sender
{
    if ([self.editButton.title isEqualToString:@"Edit"]) {
        [self.editButton setTitle:@"Done"];
        // 只有设置了编辑模式, 才能出现移动的标识
        [self.mTableView setEditing:YES animated:YES];
    }else{
        [self.editButton setTitle:@"Edit"];
        [self.mTableView setEditing:NO animated:NO];
    }
    [self.mTableView reloadData];
}

- (void)moveItemAtIndex:(NSInteger)from toIndex:(NSInteger)to
{
    id item = [self.dataSource objectAtIndex:from];
    [self.dataSource removeObjectAtIndex:from];
    [self.dataSource insertObject:item atIndex:to];
    //[self.mTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}


- (MyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    NSString *content = [self.dataSource objectAtIndex:indexPath.row];
    NSLog(@"%@", content);
    //cell.image.image = [UIImage imageNamed:[self.imageList objectAtIndex:(indexPath.row % [self.imageList count])]];
    cell.image.image = [UIImage imageNamed:[self.imageList objectAtIndex:[content intValue]]];
    [cell.image setContentMode:UIViewContentModeScaleAspectFit];
    cell.title.text = [NSString stringWithFormat:@"%@ %@" , @"my name is:", [self.imageList objectAtIndex:(indexPath.row % [self.imageList count])]];
    cell.hint.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

// 调整cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Who am i?"
                                                                             message:[NSString stringWithFormat:@"I am %@", [self.imageList objectAtIndex:(indexPath.row % [self.imageList count])]]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.style;
}

// 添加delete 模式
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"will delete the item %ld", indexPath.row);
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

// 添加移动的 模式
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 这个方法是移动后, cell的位置, 但是需要同时修改datasource. 否则 tableview reloaddata 会导致cell reset.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSLog(@"from %ld, to %ld", sourceIndexPath.row, destinationIndexPath.row);
    [self moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}
@end
