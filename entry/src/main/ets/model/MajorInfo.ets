export interface MajorInfo {
  name: string;
  university: string;
  type: string;
  category: string;
  duration: number;
  qsRank: number;
  introduction: string;
  requiredTOEFL: number;
  requiredGRE: number;
  requirements: string;
}

export const majorInfoData: MajorInfo[] = [
  {
    name: "计算机科学",
    university: "普林斯顿大学",
    type: "工学",
    category: "计算机",
    duration: 2,
    qsRank: 14,
    introduction: "普林斯顿大学计算机系比较注重对数理逻辑、量子力学等知识的掌握。除了理论研究之外，还在网络与系统，图形与视觉，编程语言等方面展开前沿性研究。截止2020年，共有14位世界计算机最高奖图灵奖得主来自普林斯顿大学。\n\n普林斯顿大学开设的CS硕士项目工程科学硕士是一个为期两年的全日制课程。所有录取的学生最初将注册为工程科学硕士，在第1年春季学期开始时，所有学生都可以选择转到工程硕士继续学习。",
    requiredTOEFL: 0,
    requiredGRE: 0,
    requirements: "研究导向录取，看重学生的研究背景。",
  },
  {
    name: "金融",
    university: "普林斯顿大学",
    type: "商科",
    category: "金融",
    duration: 2,
    qsRank: 29,
    introduction: "普林斯顿大学金融专业是一个涵盖金融学领域广度与深度的学科体系。在这个专业中，学生将学习金融市场的运作与监管、资本市场、投资管理以及金融工程等相关知识。通过系统学习，培养学生掌握金融理论与实践的能力，为日后在各种机构、企业从事金融分析、金融工程、风险管理等相关工作打下坚实的基础。",
    requiredTOEFL: 0,
    requiredGRE: 0,
    requirements: "希望申请者在中级本科课程水平上熟悉数学，包括线性代数、多元微积分、微分方程以及概率和统计。",
  }
]

export function getMajorInfoByUniversity(university: string) {
  let indexes: number[] = [];
  for (let i = 0; i < majorInfoData.length; i++) {
    if (majorInfoData[i]["university"] === university) {
      indexes.push(i)
    }
  }
  return indexes.map(index => majorInfoData[index])
}

