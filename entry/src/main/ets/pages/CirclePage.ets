import { PostInfo } from '../model/PostInfo'
import router from '@ohos.router'
import { StatItem } from './PracticePage'
import { convertMillisecondsToTime } from '../utils/DateUtil'
import { cancelLike, getAllPost, like } from '../http/Api'
import promptAction from '@ohos.promptAction'
import emitter from '@ohos.events.emitter'

@Component
export struct CirclePage {
  @State postInfoList: PostInfo[] = []
  @StorageProp('token') @Watch('onTokenChange') token: string = ''
  page:number = 1 // 当前页面号
  total:number = 0  // 总页面数量
  @State isLoading:Boolean = false;
  scroller:Scroller = new Scroller()

  // 加载某一页的数据
  async getPostInfoPage(){
    let response = await getAllPost(this.page,10)
    response.data.data.records.forEach(post=>this.postInfoList.push(new PostInfo(post)))
    this.total = response.data.data.total;
    this.page++;
  }

  // 刷新页面
  async refresh(){
    this.isLoading = true;
    this.postInfoList=[]
    this.page=1
    this.total=0
    await this.getPostInfoPage()
    this.isLoading = false;
  }

  // 当组件出现时，如果用户已登录，则加载数据
  aboutToAppear(){
    if(this.token){
      this.getPostInfoPage()
    }

    // 当组件出现时，开始监听提交新的打卡记录的事件
    emitter.on({eventId:1},()=>{
      this.refresh()
    })
  }

  // 当 token 改变时，如果用户登录，则加载数据；如果用户退出登录，则清楚数据
  onTokenChange(){
    if (this.token) {
      this.getPostInfoPage()
    }
    else {
      this.postInfoList=[]
      this.total=0
      this.page=1
    }
  }

  build() {
    Column() {
      // header
      Text('英语打卡圈')
        .fontSize(18)
        .margin({ top: 45 })
        .fontWeight(FontWeight.Bold)
      Divider()
        .color(Color.Black)
        .margin({ left: 20, right: 20, top: 10 })

      if (this.token) { // 已登录
        if(this.isLoading){
          this.loadingBuilder()
        }else{
          this.listBuilder()
        }
      } else {  // 未登录
        this.unLoginBuilder()
      }
    }.height('100%')
    .width('100%')
  }

  // 未登录页面布局
  @Builder
  unLoginBuilder() {
    Column({ space: 30 }) {
      Image($r("app.media.ic_unLogin_bg"))
        .width(177)
        .height(177)

      Text('未登录暂无数据')
        .fontSize(14)
        .fontColor('#999999')

      Button('去登录')
        .fontColor(Color.White)
        .fontSize(14)
        .width(100)
        .height(34)
        .backgroundColor('#43C6A0')
        .onClick(() => router.pushUrl({ url: 'pages/LoginPage' }))
    }
    .width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  // 加载中页面布局
  @Builder
  loadingBuilder() {
    Column({ space: 15 }) {
      Image($r('app.media.ic_loading'))
        .width(30)
        .height(30)
      Text('加载中...')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#7e8892')
    }.width('100%')
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  // 打卡记录列表页面布局
  @Builder
  listBuilder() {
    Stack() { // 将打卡记录列表与控制按钮堆叠在一起
      // 打卡记录列表
      List({scroller:this.scroller}) {  // 打卡记录列表
        ForEach(this.postInfoList, (post) => {
          ListItem() {
            PostItem({ post: post })  // 打卡记录
          }
        })
      }.width('100%')
      .height('100%')
      .alignListItem(ListItemAlign.Center)
      .onReachEnd(()=>{ // 列表到底了
        if (this.postInfoList.length < this.total) {  // 未加载全部条目
          this.getPostInfoPage()
        }
        else {  // 已加载全部条目
          promptAction.showToast({message:'没有更多数据了'})
        }
      })

      // 返回顶部按钮和刷新按钮
      Column({ space: 20 }) {
        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_top'))
            .height(14)
            .width(14)
        }
        .height(40)
        .width(40)
        .backgroundColor(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          // 返回顶部
          this.scroller.scrollToIndex(0)
        })

        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.ic_refresh'))
            .height(14)
            .width(14)
        }
        .height(40)
        .width(40)
        .backgroundColor(Color.Black)
        .opacity(0.5)
        .onClick(() => {
          this.refresh()
        })
      }
      .offset({ x: -20, y: -50 })
    }.width('100%')
    .layoutWeight(1)
    .alignContent(Alignment.BottomEnd)
  }

}

// 自定义打卡记录组件
@Component
struct PostItem {
  @ObjectLink post: PostInfo;

  build() {
    Column({ space: 10 }) {
      // header
      Row({ space: 10 }) {
        Image(this.post.avatarUrl)
          .height(40)
          .width(40)
          .borderRadius(20)
        Text(this.post.nickname)
          .height(40)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text(this.post.createTime)
          .height(40)
          .fontSize(14)
          .fontColor('#999999')
          .fontWeight(FontWeight.Medium)
      }.width('100%')

      Text(this.post.postText)
        .width('100%')

      Row() {
        // 打卡信息
        Column() {
          StatItem({
            icon: $r('app.media.ic_timer_white'),
            name: '用时',
            fontColor: Color.White }) {
            Text(convertMillisecondsToTime(this.post.timeUsed))
              .statTextStyle()
          }

          StatItem({
            icon: $r('app.media.ic_accuracy_white'),
            name: '准确率',
            fontColor: Color.White
          }) {
            Text((this.post.answeredCount === 0 ? 0 : this.post.rightCount / this.post.answeredCount * 100).toFixed(0) + '%')
              .statTextStyle()
          }

          StatItem({
            icon: $r('app.media.ic_count_white'),
            name: '个数',
            fontColor: Color.White
          }) {
            Text(this.post.answeredCount.toString())
              .statTextStyle()
          }
        }
        .padding(10)
        .borderRadius(10)
        .layoutWeight(1)
        .backgroundImage($r('app.media.img_post_bg'))
        .backgroundImageSize(ImageSize.Cover)

        // 点赞信息
        Column() {
          Text(this.post.likeCount.toString())
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.post.isLike ? '#3ECBA1' : '#000000')
          Image(this.post.isLike ? $r('app.media.ic_post_like_selected') : $r('app.media.ic_post_like'))
            .width(26)
            .height(26)
            .onClick(() => {
              // 点赞/取消点赞
              if(this.post.isLike){
                // 已点赞，则取消点赞
                this.post.isLike=false;
                this.post.likeCount--;
                cancelLike(this.post.id)

              }else{
                // 未点赞，则点赞
                this.post.isLike=true;
                this.post.likeCount++;
                like(this.post.id)
              }
            })
        }.width(50)
      }.width('100%')
      .alignItems(VerticalAlign.Bottom)
    }
    .padding(10)
    .width('90%')
    .margin({ top: 10 })
    .borderRadius(10)
    .shadow({ radius: 20 })
  }
}

@Extend(Text) function statTextStyle() {
  .width(100)
  .fontSize(16)
  .textAlign(TextAlign.End)
  .fontWeight(FontWeight.Medium)
  .fontColor(Color.White)
}