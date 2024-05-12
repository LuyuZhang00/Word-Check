@Observed
export class PostInfo {
  id: number;             //打卡文案
  postText: string;
  rightCount: number;    //正确个数
  answeredCount: number; //答题个数
  timeUsed: number;      //用时
  createTime: string;    //打卡时间
  likeCount: number;    //点赞个数
  nickname: string;     //用户昵称
  avatarUrl: string     //用户头像
  isLike: boolean;      //当前登录用户是否已点赞

  constructor(post:{id: number, postText: string, rightCount: number, answeredCount: number, timeUsed: number, createTime: string, likeCount: number, nickname: string, avatarUrl: string, isLike: boolean}) {
    this.id = post.id;
    this.postText = post.postText;
    this.rightCount = post.rightCount;
    this.answeredCount = post.answeredCount;
    this.timeUsed = post.timeUsed;
    this.createTime = post.createTime;
    this.likeCount = post.likeCount;
    this.nickname = post.nickname;
    this.avatarUrl = post.avatarUrl;
    this.isLike = post.isLike;
  }
}