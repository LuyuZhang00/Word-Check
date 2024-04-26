import { PracticePage } from './PracticePage';
@Entry
@Component
struct Index {
  @State currentTabIndex: number = 0;

  build() {
    Tabs(){
      TabContent(){
        PracticePage()
      }.tabBar(this.barBuilder(0, '答题', $r('app.media.ic_practice'), $r('app.media.ic_practice_selected')))

      TabContent(){
        Text("圈子")
      }.tabBar(this.barBuilder(1, '圈子', $r('app.media.ic_circle'), $r('app.media.ic_circle_selected')))

      TabContent(){
        Text("我的")
      }.tabBar(this.barBuilder(2, '我的', $r('app.media.ic_mine'), $r('app.media.ic_mine_selected')))

    }.barPosition(BarPosition.End)
    .onChange((index) => {
      this.currentTabIndex = index;
    })
  }

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