import { getMyPost } from '../http/Api';
import { PostInfo } from '../model/PostInfo';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { convertMillisecondsToTime } from '../utils/DateUtil';

@Entry
@Component
struct PostHistoryPage {
  @State postInfoList: PostInfo[] = []
  page: number = 1;
  total: number = 0;

  onPageShow() {
    this.postInfoList = []
    this.page = 1
    this.total = 0
    this.getMyPostInfoList(this.page)
  }

  async getMyPostInfoList(page: number) {
    let response = await getMyPost(page, 10)
    response.data.data.records.forEach(post => this.postInfoList.push(new PostInfo(post)))
    this.total = response.data.data.total;
    this.page += 1;
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .onClick(() => {
            router.back()
          })
        Text('打卡记录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.ic_back'))
          .width(24)
          .height(24)
          .visibility(Visibility.Hidden)
      }.width('100%')
      .height(40)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 20, right: 20 })

      Divider()
        .color(Color.Black)
        .margin({ left: 20, right: 20 })

      if (this.postInfoList.length > 0) {
        this.listBuilder()
      } else {
        this.emptyBuilder()
      }

    }
    .height('100%')
    .width('100%')
    .padding({
      top: 40
    })
  }

  @Builder
  listBuilder() {
    List() {
      ForEach(this.postInfoList, (post) => {
        ListItem() {
          this.postItemBuilder(post)
        }.width('100%')
      })
    }
    .width('100%')
    .layoutWeight(1)
    .alignListItem(ListItemAlign.Center)
    .onReachEnd(() => {
      if (this.postInfoList.length < this.total) {
        this.getMyPostInfoList(this.page)
      } else {
        promptAction.showToast({ message: '没有更多的数据了...' })
      }
    })
  }

  @Builder
  emptyBuilder() {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(200)
        .height(200)
      Text('暂无数据')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor('#7e8892')
    }.width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  postItemBuilder(post: PostInfo) {
    Row() {
      Column({ space: 10 }) {
        Text(post.createTime)
          .fontSize(14)
          .fontColor('#999999')
          .height(21)
        Row() {
          Text('单词数 : ' + post.answeredCount)
            .fontSize(14)
            .fontColor('#1C1C1C')
            .height(21)
            .margin({
              right: 20
            })
          Text('准确率 : ' + (post.rightCount / post.answeredCount * 100).toFixed(0) + '%')
            .fontSize(14)
            .fontColor('#1C1C1C')
            .height(21)
        }

        Text('用时 : ' + convertMillisecondsToTime(post.timeUsed))
          .fontSize(14)
          .fontColor('#1C1C1C')
          .height(21)

      }.alignItems(HorizontalAlign.Start)

      Blank()

      Text(post.createTime.substring(8, 10))
        .width(58)
        .height(58)
        .fontSize(18)
        .textAlign(TextAlign.Center)
        .fontColor('#333333')
        .fontWeight(FontWeight.Bold)
        .backgroundImage($r('app.media.ic_history_date'))
        .backgroundImageSize(ImageSize.Contain)
    }
    .borderWidth(1)
    .padding(10)
    .borderRadius(10)
    .shadow({ radius: 20 })
    .width('90%')
    .margin({ top: 10 })
  }
}