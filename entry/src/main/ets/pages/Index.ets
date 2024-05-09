import { CirclePage } from './CirclePage';
import { MinePage } from './MinePage';
import { PracticePage } from './PracticePage';

@Entry
@Component
struct Index {
  @StorageLink('currentTabIndex') currentTabIndex: number = 0;  // 被选中的页签索引

  build() {
    Tabs({index:this.currentTabIndex}){ // index 指示 Tabs 显示哪个页面
      TabContent(){
        PracticePage()
      }.tabBar(this.barBuilder(0, '答题', $r('app.media.ic_practice'), $r('app.media.ic_practice_selected')))

      TabContent(){
        CirclePage()
      }.tabBar(this.barBuilder(1, '圈子', $r('app.media.ic_circle'), $r('app.media.ic_circle_selected')))

      TabContent(){
        MinePage()
      }.tabBar(this.barBuilder(2, '我的', $r('app.media.ic_mine'), $r('app.media.ic_mine_selected')))

    }.barPosition(BarPosition.End)  // 导航栏位于页面底部
    .onChange((index) => {  // 选择新的页签时，修改被选中的页签索引
      this.currentTabIndex = index;
    })
  }

  // 自定义页签结构，根据被选中的页签索引决定每一个页签的样式
  @Builder barBuilder(index: number, title: string, icon: Resource, iconSelected: Resource) {
    Column() {
      Image(this.currentTabIndex === index ? iconSelected : icon)
        .width(25)
        .height(25)
      Text(title)
        .tabTitleStyle(this.currentTabIndex === index ? Color.Black:'#959595')
    }
  }
}

@Extend(Text) function tabTitleStyle(color: ResourceColor) {
  .fontSize(10)
  .fontWeight(FontWeight.Medium)
  .fontColor(color) //Color.Black
  .margin({ bottom: 2 })
}