import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { AdmissionCase, admissionCaseData, getAdmissionCasesByUniversity } from '../model/AdmissionCases'
import { getUniversityInfoByName, UniversityInfo } from '../model/UniversityInfo'

@Preview
@Entry
@Component
struct AdmissionCaseDetailPage {
  @State routerParams:Object = router.getParams()
  @State admissionCase:AdmissionCase = this.routerParams["admissionCase"]
  // @State admissionCase:AdmissionCase = admissionCaseData[0] // 测试用
  @State universityInfo:UniversityInfo = getUniversityInfoByName(this.admissionCase.graduateUniversity)
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

        // 学生背景
        Column({ space: 0 }) {
          Text(this.admissionCase.graduateMajor)
            .height(30)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
          Text("录取院校：" + this.universityInfo.nameCN)
            .height(30)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text("录取年份：" + String(this.admissionCase.admissionYear))
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

      // 本科背景
      Column() {
        Text("本科背景")
          .fontWeight(FontWeight.Bold)
          .height(35)

        Text("本科院校" + "    " + this.admissionCase.undergraduateUniversity)
          .fontSize(14)
          .height(20)

        Text("本科专业" + "    " + this.admissionCase.undergraduateMajor)
          .fontSize(14)
          .height(20)
      } // Column: 学校简介
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 5 })

      // 标化成绩
      Column() {
        Text("标化成绩")
          .fontWeight(FontWeight.Bold)
          .height(35)

        Row({space : 30}) {
          Column() {
            Text("GPA")
              .fontSize(14)
              .height(20)

            Text("TOEFL")
              .fontSize(14)
              .height(20)

            Text("GRE")
              .fontSize(14)
              .height(20)
          }
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text(String(this.admissionCase.gpa))
              .fontSize(14)
              .height(20)

            Text(String(this.admissionCase.toefl))
              .fontSize(14)
              .height(20)

            Text(String(this.admissionCase.gre))
              .fontSize(14)
              .height(20)
          }
          .alignItems(HorizontalAlign.Start)
        }
      } // Column: 标化成绩
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 5 })

      // 主要经历
      Column() {
        Text("主要经历")
          .fontWeight(FontWeight.Bold)
          .height(35)

        Text("实习经历" + "    " + this.admissionCase.internshipExperience)
          .fontSize(14)
          .height(20)

        Text("科研经历" + "    " + this.admissionCase.researchExperience)
          .fontSize(14)
          .height(20)
      } // Column: 学校简介
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 5 })

      // 经验分享
      Column() {
        Text("经验分享")
          .fontWeight(FontWeight.Bold)
          .height(35)

        Text(this.admissionCase.share)
          .fontSize(14)

      } // Column: 学校简介
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 5 })

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