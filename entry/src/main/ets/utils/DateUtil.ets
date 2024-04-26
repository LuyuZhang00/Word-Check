export function convertMillisecondsToTime(timeUsed: number): string {
  // 计算小时、分钟和秒
  const hours = Math.floor(timeUsed / 3600000); // 1小时 = 3600000毫秒
  const minutes = Math.floor((timeUsed % 3600000) / 60000); // 1分钟 = 60000毫秒
  const seconds = Math.floor((timeUsed % 60000) / 1000); // 1秒 = 1000毫秒

  // 将结果格式化为时分秒字符串
  if (hours > 0) {
    return `${hours}时  ${minutes}分 ${seconds}秒`
  } else if (minutes > 0) {
    return `${minutes}分 ${seconds}秒`
  } else {
    return `${seconds}秒`
  }
}