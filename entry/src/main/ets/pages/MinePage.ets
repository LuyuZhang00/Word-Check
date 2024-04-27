import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { info } from '../http/Api';

@Component
export struct MinePage {
  @StorageLink('token') @Watch('onTokenChange') token: string = ''
  @State userInfo: {
    nickname?: string,
    avatarUrl?: string
  } = {};

  async onTokenChange() {
    if (this.token) {
      let response = await info()
      this.userInfo = response.data.data;
    } else {
      this.userInfo = {}
    }
  }

  async aboutToAppear() {
    if (this.token) {
      let response = await info()
      this.userInfo = response.data.data;
    }
  }

  build() {
    Stack() {
      Column() {
        Image(this.token ? this.userInfo.avatarUrl : $r('app.media.img_avatar'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ top: 120 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/LoginPage' })
          })

        Text(this.token ? this.userInfo.nickname : '暂未登录')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({ top: 20 })

        if (!this.token) {
          Text('请点击头像登录')
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.Black)
            .margin({ top: 4 })
        }
      }
      .width('100%')
      .height('50%')
      .backgroundImage(this.token ? this.userInfo.avatarUrl : $r('app.media.img_avatar'))
      .backgroundImageSize({ height: '100%', width: '100%' })
      .backgroundBlurStyle(BlurStyle.Regular)

      Column({ space: 10 }) {
        this.mineItemBuilder($r('app.media.ic_mine_card'), '打卡记录', () => {
          if (this.token) {
            router.pushUrl({ url: 'pages/PostHistoryPage' })
          } else {
            promptAction.showToast({ message: '请先点击头像登录' })
          }
        })
        Divider()
        this.mineItemBuilder($r('app.media.ic_mine_update'), '检查更新', () => {
          promptAction.showToast({ message: '已是最新' })
        })
        Divider()
        this.mineItemBuilder($r('app.media.ic_mine_about'), '关于', () => {
          promptAction.showToast({ message: '没有关于' })
        })

        Blank()

        if (this.token) {
          Button('退出登录')
            .width('100%')
            .fontSize(18)
            .backgroundColor(Color.Gray)
            .fontColor(Color.White)
            .onClick(() => {
              this.token = ''
            })
        }

      }
      .width('100%')
      .height('60%')
      .offset({ y: '40%' })
      .borderRadius({ topLeft: 50, topRight: 50 })
      .backgroundColor(Color.White)
      .padding(30)

    }.width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
  }

  @Builder
  mineItemBuilder(icon: Resource, title: string, callback?: () => void) {
    Row({ space: 10 }) {
      Image(icon)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(16)
        .height(24)
        .fontWeight(FontWeight.Medium)
      Blank()
      Image($r('app.media.ic_arrow_right'))
        .width(24)
        .height(24)
    }.width('100%')
    .height(40)
    .onClick(() => {
      callback();
    })
  }
}