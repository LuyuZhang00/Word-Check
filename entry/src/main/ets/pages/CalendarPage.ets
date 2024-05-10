import { CalendarEvent, calendarEventData } from '../model/CalendarEvent'

@Preview
@Component
export struct CalendarPage {
  scroller:Scroller = new Scroller()
  @State calendarEvents:CalendarEvent[] = calendarEventData

  build() {
    Column() {
      // header
      Text('留学日历')
        .fontSize(18)
        .margin({ top: 45 })
        .fontWeight(FontWeight.Bold)
      
      Divider()
        .color(Color.Black)
        .margin({ left: 20, right: 20, top: 10 })

      Column() {
        Text('添加事件')
          .fontWeight(FontWeight.Bold)
          .height(35)
          .fontSize(18)
          .fontColor(Color.Blue)
      }
      .width('90%')
      .padding(10)
      .margin({ top: 10 })
      .borderRadius(10)
      .shadow({ radius: 20 })
      .onClick(()=>{  // 点击事件卡，修改事件
        let newCalendarEvent = new CalendarEvent()
        this.calendarEvents.push(newCalendarEvent)
      })  // onClick

      Divider()
        .color(Color.Black)
        .margin({ left: 20, right: 20, top: 10 })


      List() {
        ForEach(this.calendarEvents, (calendarEvent) => {
          ListItem() {
            CalendarEventItem({ calendarEvent:calendarEvent })
          }
        })
        ListItem().height(150).selectable(false)  // 占位符，不然最后一个项目在屏幕外
      } // List
      .width('100%')
      .height('100%')
      .alignListItem(ListItemAlign.Center)
    } // 最外层 Column
    .height('100%')
    .width('100%')
  }
}

// 自定义日历事件组件
@Component
struct CalendarEventItem {
  @State calendarEvent:CalendarEvent = calendarEventData[0]

  dialogController:CustomDialogController = new CustomDialogController({
    builder:ModifyEventDialog({
      calendarEvent:this.calendarEvent,
      isComplete:this.calendarEvent.isComplete
    }),
    customStyle:true, // 允许使用自定义的弹窗样式
    autoCancel:true  // 允许点击遮障层退出
  })

  build() {
    // 录取详情
    Row({space:15}) {
      if (this.calendarEvent.isComplete) {
        Image($r('app.media.ic_complete'))
          .height(60)
          .width(60)
      }
      else {
        Image($r('app.media.ic_incomplete'))
          .height(60)
          .width(60)
      }

      Column() {
        Text(this.calendarEvent.name)
          .height(30)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)

        if (this.calendarEvent.isComplete) {
          Text(this.calendarEvent.completeValue)
            .height(20)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
        }
        else {
          Text(this.calendarEvent.incompleteValue)
            .height(20)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)

          Text(this.calendarEvent.year.toString() + '/' + this.calendarEvent.month.toString() + '/' + this.calendarEvent.day.toString())
            .height(20)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
        }
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('90%')
    .padding(10)
    .margin({ top: 10 })
    .borderRadius(10)
    .shadow({ radius: 20 })
    .onClick(()=>{  // 点击事件卡，修改事件
      this.dialogController.open()
    })  // onClick
  } // build
}

// 自定义弹窗
@Preview
@CustomDialog
struct ModifyEventDialog{
  calendarEvent:CalendarEvent = calendarEventData[0]
  @Prop isComplete:boolean
  controller:CustomDialogController

  build(){
    Column() {
      Text("修改事件")
        .fontSize(18)
        .fontWeight(FontWeight.Bold)

      Column() {
        // 事件名称
        Row({ space:10 }) {
          Text("事件名称")
          TextInput({ placeholder: '请输入事件名称', text:this.calendarEvent.name })
            .inputStyle()
            .onChange((value)=>{
              this.calendarEvent.name = value
            })
        }
        .padding({ top:0 })

        // 事件详情
        if (this.isComplete) {
          Row({ space:10 }) {
            Text("事件详情")
            TextInput({ placeholder: '请输入事件详情', text:this.calendarEvent.completeValue })
              .inputStyle()
              .onChange((value)=>{
                this.calendarEvent.completeValue = value
              })
          }
          .padding({ top:15 })
        }
        else {
          Row({ space:10 }) {
            Text("事件详情")
            TextInput({ placeholder: '请输入事件详情', text:this.calendarEvent.incompleteValue })
              .inputStyle()
              .onChange((value)=>{
                this.calendarEvent.incompleteValue = value
              })
          }
          .padding({ top:15 })
        }

        // deadline
        if (!this.isComplete) {
          Row({ space:10 }) {
            Text("事件日期")
            DatePicker({
              start: new Date('1970-1-1'),
              end: new Date('2100-1-1'),
              selected: this.calendarEvent.date,
            })
              .width(170)
              .onChange((value: DatePickerResult) => {
                this.calendarEvent.date.setFullYear(value.year, value.month, value.day)
                this.calendarEvent.year = value.year
                this.calendarEvent.month = value.month + 1
                this.calendarEvent.day = value.day
              })
          }
          .padding({ top:15 })
        }

        // 完成情况
        Row({ space:10 }) {
          Text("未完成")
          Radio({ value: 'complete', group: 'radioGroup' })
            .checked(!this.calendarEvent.isComplete)
            .onChange((isChecked: boolean) => {
              if(isChecked) {
                this.isComplete = false
                this.calendarEvent.isComplete = false
              }
            })

          Blank()
          Text("已完成")
          Radio({ value: 'incomplete', group: 'radioGroup' })
            .checked(this.calendarEvent.isComplete)
            .onChange((isChecked: boolean) => {
              if(isChecked) {
                this.isComplete = true
                this.calendarEvent.isComplete = true
              }
            })
        }
        .width('100%')
        .padding({ top:15 })

      } // 主体 Column
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .padding({ top:20 })
    } // 最外层 Column
    .backgroundColor(Color.White)
    .width('80%')
    .padding(20)
    .borderRadius(10)
  }
}

@Extend(TextInput) function inputStyle() {
  .height(40)
  .layoutWeight(1)
  .fontSize(14)
}
