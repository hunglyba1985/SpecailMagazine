//
//  NewDetailViewController.m
//  SpecialMagazine
//
//  Created by MobileFolk on 2017-01-05.
//  Copyright © 2017 Macbook Pro. All rights reserved.
//

#import "NewDetailViewController.h"
#import "DetailCell1.h"
#import "DetailCell2.h"
#import "TFHpple.h"

@interface NewDetailViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSArray *tableData;
    NSMutableArray *heightCell;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"original content is %@",self.article.content);
    
    
    tableData = [self convertHtmlStringToArray:self.article.content];
    
    
    NSLog(@"when convert to array we have %@",tableData);
    
    [self getHeightForCell];
    
}


-(NSArray *) convertHtmlStringToArray:(NSString *) htmlStr
{
    
    
    NSMutableArray *temp = [NSMutableArray new];
    
    NSData* data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:data];
    
    NSString *tutorialsXpathQueryString = @"//div[@class='text-conent']/p";
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    
    [tutorialsNodes enumerateObjectsUsingBlock:^(TFHppleElement *element , NSUInteger idx, BOOL * _Nonnull stop) {
        
//                NSLog(@"get content --------------------%@",element.firstChild.content);
        
        if (element.firstChild.content != nil) {
            [temp addObject:element.firstChild.content];
            
        }
        
        if (element.firstChild.content == nil) {
//                        NSLog(@"each element element.firstChild.attributes in this object is:%@",[element.firstChild.attributes objectForKey:@"src"]);
            
            if ([element.firstChild.attributes objectForKey:@"src"] != nil) {
                NSDictionary *linkImage = @{LINK_IMAGE:[element.firstChild.attributes objectForKey:@"src"]};
                [temp addObject:linkImage];
            }
            
            
        }
        
        
    }];
    
    
    return temp;
}

-(void) getHeightForCell
{
    heightCell = [NSMutableArray new];
    [tableData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *) obj;
            
            CGFloat heightStr = [self getHeightString:str];
            
            [heightCell addObject:[NSString stringWithFormat:@"%f",heightStr]];
            
            
        }
        else
        {
            [heightCell addObject:@"300"];

        }
        
    }];
    
    [self.tableView reloadData];
    
}

- (CGFloat)getHeightString:(NSString*)string
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGSize constraint = CGSizeMake((screenWidth - 30), CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [string boundingRectWithSize:constraint
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                              context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return (size.height + 10);
}



#pragma mark - TableView Datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableData.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id  cellData = [tableData objectAtIndex:indexPath.row];
    
    if ([cellData isKindOfClass:[NSString class]]) {
        
        DetailCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell1" forIndexPath:indexPath];

        
        cell.label.text = cellData;
        cell.label.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        return cell;

    }
    else
    {
        DetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell2" forIndexPath:indexPath];

        NSDictionary *dic = (NSDictionary *) cellData;
        
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:LINK_IMAGE]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        

        return cell;

    }
    
}

#pragma mark - TableView Delegate
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[heightCell objectAtIndex:indexPath.row] floatValue];
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
