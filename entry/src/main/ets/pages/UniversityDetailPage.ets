import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { UniversityInfo, universityInfoData } from '../model/UniversityInfo'
import { AdmissionCase, getAdmissionCasesByUniversity } from '../model/AdmissionCases'

@Preview
@Entry
@Component
struct UniversityDetailPage {
  // @State routerParams:Object = router.getParams()
  // @State universityInfo:UniversityInfo = this.routerParams["universityInfo"]
  @State universityInfo:UniversityInfo = universityInfoData[0] // 测试用
  @State admissionCases:AdmissionCase[] = getAdmissionCasesByUniversity(this.universityInfo["nameCN"])
  scroller:Scroller = new Scroller()

  build() {
    Column() {
      // 返回图标
      Image($r('app.media.ic_back'))
        .backStyle()
        .alignSelf(ItemAlign.Start)
        .onClick(() => {
          // 返回上一页面
          router.back()
        })

      // header：学校信息
      Row({ space: 25 }) {
        // 校徽
        Image(this.universityInfo.badgeURL)
          .height(70)
          .width(70)
          .borderRadius(5)

        // 学校信息
        Column({ space: 0 }) {
          Text(this.universityInfo.nameCN)
            .height(30)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
          Text(this.universityInfo.nameUS)
            .height(20)
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
          Text("US News排名：" + String(this.universityInfo.usNewsRank))
            .height(20)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text("位置：" + this.universityInfo.location)
            .height(20)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
        } // Column: 学校信息
        .alignItems(HorizontalAlign.Start)
      } // Row
      .alignItems(VerticalAlign.Center)
      .padding(10)
      .width('90%')
      .margin({ top: 5 })
      .borderRadius(10)

      Divider().padding({top: 5})

      List({scroller:this.scroller}) {  // 打卡记录列表
        ListItem() {
          Image(this.universityInfo.photoURL)
            .height(200)
            .width(360)
            .borderRadius(10)
            .padding({top: 15})
        }

        ListItem() {
          Column() {
            Text("学校简介")
              .fontWeight(FontWeight.Bold)
              .height(35)

            Text(this.universityInfo.introduction)
              .fontSize(14)

            Text("录取案例")
              .fontWeight(FontWeight.Bold)
              .height(35)
              .margin({ top: 5 })
          } // Column: 学校简介
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 5 })
        }



        ForEach(this.admissionCases, (admissionCase) => {
          ListItem() {
            Text(admissionCase["graduateUniversity"])
          }
        })
      } // List
      .width('100%')
      .height('100%')
      .alignListItem(ListItemAlign.Center)
      .onReachEnd(()=>{ // 列表到底了
        promptAction.showToast({message:'没有更多数据了'})
      })

    } // 最外层 Column
    .bgStyle()
  }
}

@Styles function backStyle() {
  .width(25)
  .height(25)
}

@Styles function bgStyle() {
  .width('100%')
  .height('100%')
  .padding({
    top: 30, bottom: 30, left: 20, right: 20
  })
}