import { AnswerStatus } from '../enums/AnswerStatus'
import { PracticeStatus } from '../enums/PracticeStatus'
import { getRandomQuestions, Question } from '../model/Question'
import promptAction from '@ohos.promptAction'
import { OptionStatus } from '../enums/OptionStatus'
import { convertMillisecondsToTime } from '../utils/DateUtil'
import router from '@ohos.router'
import { createPost } from '../http/Api'
import emitter from '@ohos.events.emitter'

// 练习界面
@Component
export struct PracticePage {
  @State practiceStatus:PracticeStatus = PracticeStatus.Stopped  // 练习状态，默认为 Stopped
  @State totalCount:number = 10 // 题目数量
  @State questions:Question[] = getRandomQuestions(this.totalCount)  // 题目，从题库中随机抽取
  @State currentIndex:number = 0  // 当前题目
  @State answerStatus:AnswerStatus = AnswerStatus.Answering // 作答状态
  @State selectedOption:string = '' // 用户选择的选项
  @State answeredCount:number = 0 // 已回答题目的数量
  @State rightCount:number = 0  // 回答正确题目的数量
  timerController:TextTimerController = new TextTimerController()
  timeUsed:number = 0

  dialogController:CustomDialogController = new CustomDialogController({
    builder:ResultDialog({
      answeredCount:this.answeredCount,
      rightCount:this.rightCount,
      timeUsed:this.timeUsed,
      resetPractice:()=>{ // 重置测试的函数
        this.questions=getRandomQuestions(this.totalCount)
        this.currentIndex=0
        this.answeredCount=0
        this.rightCount=0
        this.timeUsed=0
        this.timerController.reset()
        this.answeredCount=AnswerStatus.Answering
      },
      startPractice:()=>{ // 开始测试的函数
        this.startPractice()
      }
    }),
    customStyle:true, // 允许使用自定义的弹窗样式
    autoCancel:false  // 不允许点击遮障层退出

  })

  // 开始练习回调函数：修改练习状态变量 PracticeStatus，启动计时器
  startPractice(){
    this.practiceStatus=PracticeStatus.Running
    this.timerController.start()
  }

  // 暂停练习回调函数：修改练习状态变量 PracticeStatus，暂停计时器
  pausePractice(){
    this.practiceStatus=PracticeStatus.Paused
    this.timerController.pause()
  }

  // 结束练习回调函数：修改练习状态变量 PracticeStatus，停止计时器，打开弹窗
  stopPractice(){
    this.practiceStatus=PracticeStatus.Stopped
    this.timerController.reset()
    this.dialogController.open()
  }

  build() {
    Column() {  // 最外层 Column 容器
      // 统计面板
      Column() {
        // 准确率
        StatItem({
          icon:$r('app.media.ic_accuracy'),
          name:"准确率",
          fontColor:Color.Black,
        }) {  // 自定义组件中只有一个 @BuilderParam，可以用大括号的方式传参
          Text((this.answeredCount === 0 ? 0 : this.rightCount / this.answeredCount * 100).toFixed() + '%')
            .width(100)
            .textAlign(TextAlign.Center)
        }

        // 进度
        StatItem({
          icon:$r('app.media.ic_progress'),
          name:"进度",
          fontColor:Color.Black,
        }) {
            Progress({value:this.answeredCount, total:this.totalCount})  // 进度条
              .width(100)
        }

        // 个数
        StatItem({
          icon:$r('app.media.ic_count'),
          name:"个数",
          fontColor:Color.Black,
        }) {
          Button(this.totalCount.toString())
            .width(100)
            .height(25)
            .backgroundColor('#EBEBEB')
            .fontColor(Color.Black)
            .enabled(this.practiceStatus === PracticeStatus.Stopped)
            .onClick(()=>{
              TextPickerDialog.show({ // 文本选择器
                range:['5','10','15','20'],
                value:this.totalCount.toString(),
                onAccept:(result)=>{  // 选择了新的题目个数
                  this.totalCount = parseInt(result.value)  // 更新题目个数
                  this.questions = getRandomQuestions(this.totalCount)  // 获取新题目
                }
              })
            })
        }

        // 用时
        StatItem({
          icon:$r('app.media.ic_timer'),
          name:"用时",
          fontColor:Color.Black,
        }) {
          Row(){
            TextTimer({ controller: this.timerController }) // 计时器组件
              .onTimer((utc,elapsedTime)=>{ // 计时器每次改变，都会出发 onTimer 事件
                this.timeUsed = elapsedTime
              })
          }.width(100)
          .justifyContent(FlexAlign.Center)
        }

      }.statBgStyle() // 统计面板样式

      // 单词模块
      Column() {
        Text(this.questions[this.currentIndex].word)  // 单词
          .wordStyle()
        Text(this.questions[this.currentIndex].sentence)  // 例句
          .sentenceStyle()
      }

      // 选项按钮
      Column({space:10}) {
        ForEach(this.questions[this.currentIndex].options, (option) => {
           OptionButton({
             option:option, // 选项字符串
             answer:this.questions[this.currentIndex].answer, // 正确答案字符串
             selectedOption:this.selectedOption,
             answerStatus:this.answerStatus
           })
             .enabled(this.answerStatus === AnswerStatus.Answering)  // 作答中，按钮可用
             .onClick(()=>{
              // 判断练习状态
              if(this.practiceStatus !== PracticeStatus.Running){
                promptAction.showToast({message:"请先点击开始测试"})
                return
              }

              // 判断正误
              this.selectedOption = option

              // 更新统计信息
              this.answeredCount++
              if (option === this.questions[this.currentIndex].answer) {
                this.rightCount++
              }

              // 切换题目
              this.answerStatus = AnswerStatus.Answered // 按下选项按钮，转换为已作答状态，选项按钮不可用
              if (this.currentIndex < this.questions.length - 1) {  // 不是最后一题，切换题目
                setTimeout(()=>{  // 延时 500ms 后，currentIndex 加 1，切换题目
                  this.currentIndex++
                  this.answerStatus = AnswerStatus.Answering
                }, 500)
              }
              else {  // 是最后一题，停止测试
                this.stopPractice()
              }
            })
          }, option => this.questions[this.currentIndex].word + '-' + option) // ForEach 的第三个参数，每当它改变的时候就重新渲染
      }

      // 控制按钮
      Row({space:50}){  // 横向排布
        Button('停止测试')
          .controlButtonStyle({ // 控制按钮样式
            bg: Color.Transparent,
            border: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black,
            font: this.practiceStatus === PracticeStatus.Stopped ? Color.Gray : Color.Black
          })  // 控制按钮样式
          .enabled(this.practiceStatus !== PracticeStatus.Stopped)  // 控制按钮是否可用
          .onClick(()=>{
            this.stopPractice()
          })  // 点击事件回调函数

        Button(this.practiceStatus === PracticeStatus.Running ? '暂停测试' : '开始测试')
          .controlButtonStyle({ // 控制按钮样式
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

    }.practiceBgStyle() // 最外层 Column 样式
  }
}

// 自定义弹窗
@CustomDialog
struct ResultDialog{
  answeredCount:number;
  rightCount:number;
  timeUsed:number;
  resetPractice:()=>void
  startPractice:()=>void
  controller:CustomDialogController = new CustomDialogController({
    builder:ResultDialog()  // DialogController 用于控制当前弹窗
  })
  @StorageProp('token') token:string = '' // 与 PersistentStorage 中的 token 进行单向链接
  @StorageLink('currentTabIndex') currentTabIndex: number = 0;

  build(){
    Column({space:10}){
        Image($r('app.media.ic_close')) // 关闭
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
            Text((this.answeredCount === 0 ? 0:this.rightCount / this.answeredCount * 100).toFixed() + '%')
          }

          StatItem({
            icon:$r('app.media.ic_count'),
            name:'个数',
            fontColor:Color.Black
          }){
            Text(this.answeredCount.toString())
          }

          Divider() // 分割线

          Row({space:30}){
            Button("再来一局")
              .controlButtonStyle({
                bg:Color.Transparent,
                border:Color.Black,
                font:Color.Black
              })
              .onClick(()=>{
                this.controller.close()
                this.resetPractice()  // 按下“再来一局”，重启测试
                this.startPractice()  // 重启测试后，开始测试
              })

            Button(this.token ? "立即打卡" : "登录打卡")
              .controlButtonStyle({
                bg:Color.Black,
                border:Color.Black,
                font:Color.White
              })
              .onClick(async ()=>{
                this.controller.close()
                this.resetPractice()  // 重启测试
                // 登录并打卡
                if(this.token){ // 已登录
                  // 发送打卡请求
                  await createPost({  // 等待请求完成后再执行接下来的指令
                    rightCount:this.rightCount,
                    answeredCount:this.answeredCount,
                    timeUsed:this.timeUsed
                  })
                  promptAction.showToast({message:'打卡成功'})
                  // 通知打卡圈页面提交了新的打卡记录
                  emitter.emit({eventId:1})

                  // 跳转到打卡圈
                  this.currentTabIndex=1
                }
                else{  // 未登录
                  // 跳转到登录页面
                  router.pushUrl({url:'pages/LoginPage',params:{  // 切换页面，也可以返回，路由时传递必要的参数
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

// 自定义状态组件
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

// 自定义选项按钮组件
@Component
struct OptionButton {
  option:string // 选项字符串
  answer:string // 正确答案字符串
  @Prop selectedOption:string // 用户选择的选项
  @Prop @Watch('onAnswerStatusChange') answerStatus:AnswerStatus  // 作答状态
  // Prop 变量的更新顺序和声明顺序是一样的，因此 answerStatus 应该在 selectedOption 之后声明
  @State optionStatus:OptionStatus = OptionStatus.Default

  onAnswerStatusChange(){
    if (this.option === this.answer) {  // 自己是正确答案，改为绿色
      this.optionStatus = OptionStatus.Right
    }
    else {  // 自己不是正确答案
      if (this.option === this.selectedOption) {  // 自己是用户选择的选项，改为红色
        this.optionStatus = OptionStatus.Wrong
      }
      else {  // 自己不是用户选择的选项，不改变样式
        this.optionStatus = OptionStatus.Default
      }
    }
  }

  // 根据选项按钮状态选择按钮颜色
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
    Stack(){  // 将选项按钮和勾叉图标堆叠在一起
      // 选项按钮
      Button(this.option)
        .optionButtonStyle({
          bg:this.getBgColor(),
          font: this.optionStatus === OptionStatus.Default ? Color.Black : Color.White
        })

      // 勾叉图标
      if (this.optionStatus === OptionStatus.Right) {
        Image($r('app.media.ic_right'))
          .width(22)
          .height(22)
          .offset({x:10})
      }
      else {
        if (this.optionStatus === OptionStatus.Wrong) {
          Image($r('app.media.ic_wrong'))
            .width(22)
            .height(22)
            .offset({x:10})
        }
      }
    }.alignContent(Alignment.Start)
  }
}

// 最外层 Column 样式
@Extend(Column) function practiceBgStyle() {
  .width('100%')
  .height('100%')
  .backgroundImage($r('app.media.img_practice_bg'))
  .backgroundImageSize({ width: '100%', height: '100%' })
  .justifyContent(FlexAlign.SpaceEvenly)  // 均匀排布
}

// 统计面板样式
@Styles function statBgStyle() {
  .backgroundColor(Color.White)
  .width('90%')
  .borderRadius(10)
  .padding(20)
}

// 单词样式
@Extend(Text) function wordStyle() {
  .fontSize(50)
  .fontWeight(FontWeight.Bold)
}

// 例句样式
@Extend(Text) function sentenceStyle() {
  .height(40)
  .fontSize(16)
  .fontColor('#9BA1A5')
  .fontWeight(FontWeight.Medium)
  .width('80%')
  .textAlign(TextAlign.Center)
}

// 选项按钮样式
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

// 控制按钮样式
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