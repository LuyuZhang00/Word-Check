@Entry
@Component
struct PracticePage {
  build() {
    Column() {
      Column() {
        Text("统计信息")
        Text("统计信息")
        Text("统计信息")
        Text("统计信息")
      }.statBgStyle()

      Column() {
        Text("单词")
          .wordStyle()
        Text("例句")
          .sentenceStyle()
      }

      Column() {
        ForEach([1, 2, 3, 4], (option) => {
          Button(option.toString())
            .optionButtonStyle({
              bg:Color.White,
              font: Color.Black
            })
        })
      }

      Row(){
        Button("停止测试")
          .controlButtonStyle({
            bg:Color.Transparent,
            border: Color.Black,
            font: Color.Black
          })
        Button("开始测试")
          .controlButtonStyle({
            bg:Color.Black,
            border: Color.Black,
            font: Color.White
          })
      }
    }.practiceBgStyle()
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