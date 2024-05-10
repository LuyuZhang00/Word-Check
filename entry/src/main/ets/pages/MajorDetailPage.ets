import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import { AdmissionCase, getAdmissionCasesByUniversityAndMajor } from '../model/AdmissionCases'
import { getUniversityInfoByName, UniversityInfo } from '../model/UniversityInfo'
import { MajorInfo, majorInfoData } from '../model/MajorInfo'

@Preview
@Entry
@Component
struct MajorDetailPage {
  @State routerParams:Object = router.getParams()
  @State majorInfo:MajorInfo = this.routerParams["majorInfo"]
  // @State majorInfo:MajorInfo = majorInfoData[0] // 测试用
  @State universityInfo:UniversityInfo = getUniversityInfoByName(this.majorInfo.university)
  @State admissionCases:AdmissionCase[] = getAdmissionCasesByUniversityAndMajor(this.universityInfo.nameCN, this.majorInfo.name)
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

      // header：项目名称
      Row({ space: 25 }) {
        // 校徽
        Image(this.universityInfo.badgeURL)
          .height(70)
          .width(70)
          .borderRadius(5)

        // 专业信息
        Column({ space: 0 }) {
          Text(this.majorInfo.name)
            .height(30)
            .fontSize(25)
            .fontWeight(FontWeight.Bold)
          Text(this.universityInfo.nameCN)
            .height(20)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
          Text(this.majorInfo.type)
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

      // 项目信息列表
      List({scroller:this.scroller}) {  // 学校信息列表
        // 项目信息
        ListItem() {
          Column() {
            Text("项目信息")
              .fontWeight(FontWeight.Bold)
              .height(35)

            Text("专业方向" + "    " + this.majorInfo.category)
              .fontSize(14)
              .height(20)

            Text("专业排名" + "    " + String(this.majorInfo.qsRank))
              .fontSize(14)
              .height(20)

            Text("项目时长" + "    " + String(this.majorInfo.duration) + "年")
              .fontSize(14)
              .height(20)
          } // Column: 学校简介
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 5 })
        }

        // 项目简介
        ListItem() {
          Column() {
            Text("项目简介")
              .fontWeight(FontWeight.Bold)
              .height(35)
            Text(this.majorInfo.introduction)
              .fontSize(14)
          } // Column: 学校简介
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 5 })
        }

        // 语言要求
        ListItem() {
          Column() {
            Text("语言要求")
              .fontWeight(FontWeight.Bold)
              .height(35)

            Row({space : 30}) {
              Column() {
                Text("TOEFL")
                  .fontSize(14)
                  .height(20)

                Text("GRE")
                  .fontSize(14)
                  .height(20)
              }
              .alignItems(HorizontalAlign.Start)

              Column() {
                Text(this.majorInfo.requiredTOEFL === 0 ? "需要提交" : String(this.majorInfo.requiredTOEFL))
                  .fontSize(14)
                  .height(20)

                Text(this.majorInfo.requiredTOEFL === 0 ? "需要提交" : String(this.majorInfo.requiredTOEFL))
                  .fontSize(14)
                  .height(20)
              }
              .alignItems(HorizontalAlign.Start)
            }
          } // Column: 语言要求
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 5 })
        } // ListItem: 语言要求

        // 其他要求
        ListItem() {
          Column() {
            Text("其他要求")
              .fontWeight(FontWeight.Bold)
              .height(35)

            Text(this.majorInfo.requirements)
              .fontSize(14)
          } // Column: 其他要求
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .margin({ top: 5 })
        }

        // 录取案例
        ListItem() {
          Text("录取案例")
            .fontWeight(FontWeight.Bold)
            .height(35)
            .margin({ top: 5 })
        }

        ForEach(this.admissionCases, (admissionCase) => {
          ListItem() {
            AdmissionCaseItem({ admissionCase : admissionCase })
          }
          .padding({ left:7 })
        })

        ListItem().height(140).selectable(false)  // 占位符，不然最后一个项目在屏幕外
      } // List
      .width('100%')
      .height('100%')
      .alignListItem(ListItemAlign.Start)
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

// 自定义录取案例组件
// @Preview
@Component
struct AdmissionCaseItem {
  admissionCase:AdmissionCase;

  build() {
    // 录取详情
    Column({ space: 0 }) {
      Text(this.admissionCase.graduateMajor)
        .height(25)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Text("录取年份：" + String(this.admissionCase.admissionYear))
        .height(20)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
      Text("本科院校：" + this.admissionCase.undergraduateUniversity)
        .height(20)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
      Text("本科专业：" + this.admissionCase.undergraduateMajor)
        .height(20)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
    } // Column: 学校信息
    .alignItems(HorizontalAlign.Start)
    .padding(10)
    .width('97%')
    .margin({ top: 10 })
    .borderRadius(10)
    .shadow({ radius: 20 })
    .onClick(()=>{
      router.pushUrl({url:'pages/AdmissionCaseDetailPage',params:{  // 点击学校介绍时，切换到学校详情页面
        admissionCase:this.admissionCase
      }})
    })  // onClick
  } // build
}