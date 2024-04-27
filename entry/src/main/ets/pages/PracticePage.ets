import { AnswerStatus } from '../enums/AnswerStatus'
import { PracticeStatus } from '../enums/PracticeStatus'
import { getRandomQuestions, Question } from '../model/Question'
import promptAction from '@ohos.promptAction'
import { OptionStatus } from '../enums/OptionStatus'
import { convertMillisecondsToTime } from '../utils/DateUtil'
import router from '@ohos.router'
import { createPost } from '../http/Api'

@Component
export struct PracticePage {
  @State practiceStatus: PracticeStatus = PracticeStatus.Stopped
  @State totalCount: number = 10
  @State questions: Question[] =getRandomQuestions(this.totalCount)
  @State currentIndex: number = 0
  @State answerStatus:AnswerStatus = AnswerStatus.Answering
  @State selectedOption:string = ''
  @State answeredCount:number = 0
  @State rightCount:number = 0
  timerController: TextTimerController = new TextTimerController();
  timeUsed:number = 0
  dialogController:CustomDialogController = new CustomDialogController({
    builder:ResultDialog({
      answeredCount:this.answeredCount,
      rightCount:this.rightCount,
      timeUsed:this.timeUsed,
      resetPractice:()=>{
        this.questions=getRandomQuestions(this.totalCount)
        this.currentIndex=0
        this.answeredCount=0
        this.rightCount=0
        this.timeUsed=0
        this.timerController.reset()
        this.answeredCount=AnswerStatus.Answering
      },
      startPractice:()=>{
        this.startPractice()
      }

    }),
    customStyle:true,
    autoCancel:false

  })

  startPractice(){
    this.practiceStatus=PracticeStatus.Running
    //启动计时器
    this.timerController.start()
  }

  pausePractice(){
    this.practiceStatus=PracticeStatus.Paused
    //停止计时器
    this.timerController.pause()
  }

  stopPractice(){
    this.practiceStatus=PracticeStatus.Stopped
    //停止计时器
    this.timerController.reset()
    //todo:弹窗
    this.dialogController.open()
  }

  build() {
    Column() {
      //统计信息
      Column() {
        //准确率
        StatItem({
          icon:$r('app.media.ic_accuracy'),
          name:"准确率",
          fontColor:Color.Black,
        }){
          Text((this.answeredCount === 0 ? 0 : this.rightCount / this.answeredCount*100).toFixed()+'%')
            .width(100)
            .textAlign(TextAlign.Center)
        }

        //进度
        StatItem({
          icon:$r('app.media.ic_progress'),
          name:"进度",
          fontColor:Color.Black,
        }){
            Progress({value:this.answeredCount,total:this.totalCount})
              .width(100)

        }

        //个数
        StatItem({
          icon:$r('app.media.ic_count'),
          name:"个数",
          fontColor:Color.Black,
        }){
          Button(this.totalCount.toString())
            .width(100)
            .height(25)
            .backgroundColor('#EBEBEB')
            .fontColor(Color.Black)
            .enabled(this.practiceStatus === PracticeStatus.Stopped)
            .onClick(()=>{
              TextPickerDialog.show({
                range:['5','10','15','20'],
                value:this.totalCount.toString(),
                onAccept:(result)=>{
                  this.totalCount=parseInt(result.value)
                  this.questions = getRandomQuestions(this.totalCount)
                }
              })
            })

        }

        //用时
        StatItem({
          icon:$r('app.media.ic_timer'),
          name:"用时",
          fontColor:Color.Black,
        }) {
          Row(){
            TextTimer({ controller: this.timerController })
              .onTimer((utc,elapsedTime)=>{
                this.timeUsed=elapsedTime;
              })
          }.width(100)
          .justifyContent(FlexAlign.Center)
        }
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

              //判断正误
              this.selectedOption = option

              //更新统计信息
              this.answeredCount++
              if(option===this.questions[this.currentIndex].answer){
                this.rightCount++
              }

              //切换题目
              this.answerStatus = AnswerStatus.Answered
              if(this.currentIndex<this.questions.length-1){
                setTimeout(()=>{
                  this.currentIndex++
                  this.answerStatus = AnswerStatus.Answering
                },500)
              }else{
                this.stopPractice()
              }
            })
        },option => this.questions[this.currentIndex].word + '-' + option)
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

//@Preview
@CustomDialog
struct ResultDialog{
  answeredCount:number;
  rightCount:number;
  timeUsed:number;
  resetPractice:()=>void
  startPractice:()=>void
  controller:CustomDialogController = new CustomDialogController({
    builder:ResultDialog()
  })
  @StorageProp('token') token:string = ''
  @StorageLink('currentTabIndex') currentTabIndex: number = 0;

  build(){
    Column({space:10}){
        Image($r('app.media.ic_close'))
          .width(25)
          .height(25)
          .alignSelf(ItemAlign.End)
          .onClick(()=>{
            this.controller.close()
            this.resetPractice()

          })

        Column({space:10}){
          Image($r('app.media.img_post'))
            .width('100%')
            .borderRadius(10)

          StatItem({
            icon:$r('app.media.ic_timer'),
            name:'用时',
            fontColor:Color.Black
          }){
            Text(convertMillisecondsToTime(this.timeUsed))
          }

          StatItem({
            icon:$r('app.media.ic_accuracy'),
            name:'准确率',
            fontColor:Color.Black
          }){
            Text((this.answeredCount===0?0:this.rightCount/this.answeredCount*100).toFixed() + '%')
          }

          StatItem({
            icon:$r('app.media.ic_count'),
            name:'个数',
            fontColor:Color.Black
          }){
            Text(this.answeredCount.toString())
          }
          Divider()
          Row({space:30}){
            Button("再来一局")
              .controlButtonStyle({
                bg:Color.Transparent,
                border:Color.Black,
                font:Color.Black
              })
              .onClick(()=>{
                this.controller.close()
                this.resetPractice()
                this.startPractice()
              })
            Button(this.token ? "立即打卡" : "登录打卡")
              .controlButtonStyle({
                bg:Color.Black,
                border:Color.Black,
                font:Color.White
              })
              .onClick(async ()=>{
                this.controller.close()
                this.resetPractice()
                //todo:登录并打卡
                if(this.token){
                // if(true){
                    //发送打卡请求
                    await createPost({
                      rightCount:this.rightCount,
                      answeredCount:this.answeredCount,
                      timeUsed:this.timeUsed
                    })
                    promptAction.showToast({message:'打卡成功'})
                    //跳转到打卡圈
                    this.currentTabIndex=1
                  }else{
                  //跳转到登录页面
                  router.pushUrl({url:'pages/LoginPage',params:{
                    rightCount:this.rightCount,
                    answeredCount:this.answeredCount,
                    timeUsed:this.timeUsed

                  }})

                }
              })
          }
        }.backgroundColor(Color.White)
        .width('100%')
        .padding(20)
        .borderRadius(10)

    }.backgroundColor(Color.Transparent)
    .width('80%')

  }
}

@Component
export struct StatItem {
  icon:Resource;
  name:string;
  @BuilderParam statComp:()=>void
  fontColor:Color

  build() {
    Row({space:10}){
      Image(this.icon)
        .height(14)
        .width(14)

      Text(this.name)
        .fontWeight(FontWeight.Medium)
        .fontSize(14)
        .fontColor(this.fontColor)

      Blank()
      this.statComp()
    }
    .width('100%')
    .height(30)

  }
}


@Component
struct OptionButton {
  option:string;
  answer:string;
  @State optionStatus:OptionStatus = OptionStatus.Default;
  @Prop selectedOption:string;
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
          font: this.optionStatus===OptionStatus.Default?Color.Black:Color.White
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