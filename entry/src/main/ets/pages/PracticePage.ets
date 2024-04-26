import { AnswerStatus } from '../enums/AnswerStatus'
import { PracticeStatus } from '../enums/PracticeStatus'
import { getRandomQuestions, Question } from '../model/Question'
import promptAction from '@ohos.promptAction'
import { OptionStatus } from '../enums/OptionStatus'
@Entry
@Component
struct PracticePage {
  @State practiceStatus: PracticeStatus = PracticeStatus.Stopped
  @State questions: Question[] =getRandomQuestions(10)
  @State currentIndex: number = 0
  @State answerStatus:AnswerStatus = AnswerStatus.Answering
  @State selectedOption:string = ''

  startPractice(){
    this.practiceStatus=PracticeStatus.Running
    //todo:启动计时器
  }

  pausePractice(){
    this.practiceStatus=PracticeStatus.Paused
    //todo:停止计时器
  }

  stopPractice(){
    this.practiceStatus=PracticeStatus.Stopped
    //todo:停止计时器
    //todo:弹窗
  }

  build() {
    Column() {
      //统计信息
      Column() {
        Text("统计信息")
        Text("统计信息")
        Text("统计信息")
        Text("统计信息")
      }.statBgStyle()

      //单词模块
      Column() {
        Text(this.questions[this.currentIndex].word)
          .wordStyle()
        Text(this.questions[this.currentIndex].sentence)
          .sentenceStyle()
      }

      //选项
      Column({space:10}) {
        ForEach(this.questions[this.currentIndex].options, (option) => {
           OptionButton({
             option:option,
             answerStatus:this.answerStatus,
             answer:this.questions[this.currentIndex].answer,
             selectedOption:this.selectedOption
           })
            .enabled(this.answerStatus===AnswerStatus.Answering)
            .onClick(()=>{
              //判断练习状态
              if(this.practiceStatus !==PracticeStatus.Running){
                promptAction.showToast({message:"请先点击开始测试"})
                return
              }

              //todo:判断正误
              this.selectedOption = option

              //todo:更新统计信息

              //todo:切换题目
              if(this.currentIndex<this.questions.length-1){
                setTimeout(()=>{
                  this.currentIndex++
                },500)
              }else{
                this.stopPractice()
              }
            })
        })
      }

      //开始、停止按钮
      Row({space:50}){
        Button('停止测试')
          .controlButtonStyle({
            bg: Color.Transparent,
            border: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black,
            font: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black
          })
          .enabled(this.practiceStatus !== PracticeStatus.Stopped)
          .onClick(()=>{
            this.stopPractice()
          })

        Button(this.practiceStatus === PracticeStatus.Running ? '暂停测试' : '开始测试')
          .controlButtonStyle({
            bg: this.practiceStatus === PracticeStatus.Running ? '#555555' : Color.Black,
            border: this.practiceStatus === PracticeStatus.Running ? '#555555' : Color.Black,
            font: Color.White
          })
          .stateEffect(false)
          .onClick(()=>{
            if(this.practiceStatus===PracticeStatus.Running){
              //暂停测试
              this.pausePractice()
            }else {
              //开始测试
              this.startPractice()
            }

          })
      }
    }.practiceBgStyle()
  }
}

@Component
struct OptionButton {
  option:string;
  answer:string;
  @State optionStatus:OptionStatus = OptionStatus.Default
  @Prop selectedOption:string
  @Prop @Watch('onAnswerStatusChange') answerStatus:AnswerStatus


  onAnswerStatusChange(){
    if(this.option===this.answer){
      this.optionStatus = OptionStatus.Right
    }else{
      if(this.option === this.selectedOption){
        this.optionStatus = OptionStatus.Wrong
      }else{
        this.optionStatus = OptionStatus.Default
      }
    }
  }

  getBgColor(){
    switch(this.optionStatus){
      case OptionStatus.Right:
        return "#1DBF7B"
      case OptionStatus.Wrong:
        return "#FA635F"
      default:
        return Color.White
    }
  }

  build() {
    Stack(){
      Button(this.option)
        .optionButtonStyle({
          bg:this.getBgColor(),
          font: this.optionStatus===OptionStatus.Default ? Color.Black:Color.White
        })
      if(this.optionStatus===OptionStatus.Right){
        Image($r('app.media.ic_right'))
          .width(22)
          .height(22)
          .offset({x:10})
      }else if(this.optionStatus===OptionStatus.Wrong){
        Image($r('app.media.ic_wrong'))
          .width(22)
          .height(22)
          .offset({x:10})
      }
    }.alignContent(Alignment.Start)
  }
}
@Extend(Column) function practiceBgStyle() {
  .width('100%')
  .height('100%')
  .backgroundImage($r('app.media.img_practice_bg'))
  .backgroundImageSize({ width: '100%', height: '100%' })
  .justifyContent(FlexAlign.SpaceEvenly)
}

@Styles function statBgStyle() {
  .backgroundColor(Color.White)
  .width('90%')
  .borderRadius(10)
  .padding(20)
}

@Extend(Text) function wordStyle() {
  .fontSize(50)
  .fontWeight(FontWeight.Bold)
}

@Extend(Text) function sentenceStyle() {
  .height(40)
  .fontSize(16)
  .fontColor('#9BA1A5')
  .fontWeight(FontWeight.Medium)
  .width('80%')
  .textAlign(TextAlign.Center)
}

@Extend(Button) function optionButtonStyle(color: {
  bg: ResourceColor,
  font: ResourceColor
}) {
  .width(240)
  .height(48)
  .fontSize(16)
  .type(ButtonType.Normal)
  .fontWeight(FontWeight.Medium)
  .borderRadius(8)
  .backgroundColor(color.bg)
  .fontColor(color.font)
}

@Extend(Button) function controlButtonStyle(color: {
  bg: ResourceColor,
  border: ResourceColor,
  font: ResourceColor
}) {
  .fontSize(16)
  .borderWidth(1)
  .backgroundColor(color.bg)
  .borderColor(color.border)
  .fontColor(color.font)
}