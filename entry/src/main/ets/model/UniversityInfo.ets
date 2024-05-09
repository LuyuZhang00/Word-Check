export interface UniversityInfo {
  id: number;
  nameCN: string;
  nameUS: string;
  alias: string;
  location: string;
  usNewsRank: number;
  badgeURL: string;
  photoURL: string;
  introduction: string;
}

export const universityInfoData: UniversityInfo[] = [
  {
    id: 0,
    nameCN: "普林斯顿大学",
    nameUS: "Princeton University",
    alias: "princeton",
    location: "普林斯顿，新泽西",
    usNewsRank: 1,
    badgeURL: "badges/princeton.png",
    photoURL: "photos/princeton.jpg",
    introduction: "普林斯顿大学（英语：Princeton University），简称普林斯顿（英语：Princeton），位于美国新泽西州的普林斯顿市，是世界著名的私立研究型大学，也是与哈佛大学、耶鲁大学齐名的美国三大学府之一和常春藤盟校成员。根据2023/24年美国新闻与世界报导、福布斯美国大学榜及华尔街日报美国大学榜，普林斯顿位列全美第一。"
  },
  {
    id: 1,
    nameCN: "麻省理工学院",
    nameUS: "Massachusetts Institute of Technology",
    alias: "mit",
    location: "剑桥，马萨诸塞",
    usNewsRank: 2,
    badgeURL: "badges/mit.png",
    photoURL: "photos/mit.jpg",
    introduction: "麻省理工学院（英语：Massachusetts Institute of Technology，缩写为MIT）是位于美国马萨诸塞州剑桥市的私立研究型大学，成立于1861年。主校区沿查尔斯河而建，当时目的是为了响应美国与日俱增的工业化需求。学校采用了欧洲理工大学的模式办学，早期着力于应用科学与工程学的实验教学。学校的研究人员在第二次世界大战及冷战期间，致力于开发电脑、雷达及惯性导航系统技术；战后的防御性科技研究使学校得以进一步发展，教职员人数及校园面积在詹姆斯·赖恩基利安的带领下有所上升。大学于1916年迁往现在位于查尔斯河北岸的校址，沿岸伸延逾1英里（1.6千米），占地168英亩（68公顷）。"
  },
  {
    id: 2,
    nameCN: "哈佛大学",
    nameUS: "Harvard University",
    alias: "harvard",
    location: "剑桥，马萨诸塞",
    usNewsRank: 3,
    badgeURL: "badges/harvard.png",
    photoURL: "photos/harvard.jpg",
    introduction: "哈佛大学（英语：Harvard University）为一所本部坐落于美国马萨诸塞州剑桥市的私立研究型大学。其因历史、学术影响力、财富等因素而获评为世上最享负盛名的学府之一。"
  },
  {
    id: 3,
    nameCN: "斯坦福大学",
    nameUS: "Stanford University",
    alias: "stanford",
    location: "斯坦福，加利福尼亚",
    usNewsRank: 3,
    badgeURL: "badges/stanford.png",
    photoURL: "photos/stanford.jpg",
    introduction: "小利兰·斯坦福大学（英语：Leland Stanford Junior University），常直接称为斯坦福大学（Stanford University），为一所坐落于美国加州斯坦福的私立研究型大学，临近硅谷，是美洲大学协会的12个创始会员之一，因其学术声誉和创业氛围而获评为世界上最知名的高等学府之一。"
  },
  {
    id: 4,
    nameCN: "耶鲁大学",
    nameUS: "Yale University",
    alias: "yale",
    location: "纽黑文，康涅狄格",
    usNewsRank: 5,
    badgeURL: "badges/yale.png",
    photoURL: "photos/yale.jpeg",
    introduction: "耶鲁大学（英语：Yale University）是一所坐落于美国康涅狄格州纽希文市的私立研究型大学，是美洲大学协会的十二个创始校成员之一，及NCAA体育赛事联盟常春藤盟校的成员。学校最初于1701年10月9日，以“大学学院”之名成立，是全美第三古老的高等学府。校方为了感谢伊利胡·耶鲁（英属东印度公司总裁）的捐助，而在1718年改名为“耶鲁学院”。学院最初旨在为公理会培养神学与圣典语言学人才，其后自1777年起加入了人文与科学教育课程。19世纪期间，学校增设了多所研究生与专业学院，更于1861年颁发了美国第一个博士学位。1886年，耶鲁正式以现代大学的运作模式办学。"
  },
  {
    id: 5,
    nameCN: "宾夕法尼亚大学",
    nameUS: "University of Pennsylvania",
    alias: "penn",
    location: "费城，宾夕法尼亚",
    usNewsRank: 6,
    badgeURL: "badges/penn.png",
    photoURL: "photos/penn.jpg",
    introduction: "宾夕法尼亚大学（英语：University of Pennsylvania），简称宾夕法尼亚大学或宾大（Penn或UPenn），是一所位于美国宾夕法尼亚州费城的世界著名私立研究型大学。宾大是享誉国际的常春藤盟校之一，美洲大学协会的12所创始校之一，全球大学校长论坛成员。宾大创建于1740年，是美国第五古老的高等教育机构，也是美国第一所从事科学技术和人文教育的现代高等学校。该校的创建者是美利坚合众国著名开国元勋之一的本杰明·富兰克林。"
  },
  {
    id: 6,
    nameCN: "加州理工学院",
    nameUS: "California Institute of Technology",
    alias: "caltech",
    location: "帕萨迪纳，加利福尼亚",
    usNewsRank: 7,
    badgeURL: "badges/caltech.png",
    photoURL: "photos/caltech.jpg",
    introduction: "加州理工学院（英语：California Institute of Technology，缩写：Caltech）是一所位于美国加利福尼亚州帕萨迪纳的私立研究型大学，创建于1891年，以自然科学及工程学著称，常被评为世界前十的大学之一，并与麻省理工学院、伦敦帝国理工学院、苏黎世联邦理工学院并称世界四大理工学院。"
  },
  {
    id: 7,
    nameCN: "杜克大学",
    nameUS: "Duke University",
    alias: "duke",
    location: "达勒姆，北卡罗莱纳",
    usNewsRank: 8,
    badgeURL: "badges/duke.png",
    photoURL: "photos/duke.jpg",
    introduction: "杜克大学（Duke University），简称“Duke”或“杜克”，创建于1838年，坐落于美国北卡罗来纳州的达勒姆，是一所私立综合研究型大学。杜克大学为全球大学高研院联盟和美国大学协会成员，官方吉祥物为“蓝魔”（Blue Devil）。"
  },
  {
    id: 8,
    nameCN: "布朗大学",
    nameUS: "Brown University",
    alias: "brown",
    location: "普罗维登斯，罗德岛",
    usNewsRank: 9,
    badgeURL: "badges/brown.png",
    photoURL: "photos/brown.png",
    introduction: "布朗大学（英语：Brown University，拉丁语：Universitas Brunensis），简称布朗（英语：Brown），位于美国罗德岛州普罗维登斯市，是美国八所著名常春藤盟校之一，布朗大学也是美国第一所接受任何宗教背景的学生入学的学府，前身为1764年创立的美洲新英格兰英属罗德岛和普罗维登斯殖民地学院（英语：College in the English Colony of Rhode Island and Providence Plantations, In New England, In America）。布朗大学的入学竞争极为激烈，是全美所有具有博士授予权的机构中列于第6最低的录取率。截止2017年，共有7位校友及教职工曾获得诺贝尔奖（其中1位校友）。"
  },
  {
    id: 9,
    nameCN: "约翰斯霍普金斯大学",
    nameUS: "Johns Hopkins University",
    alias: "johns",
    location: "巴尔的摩，马里兰",
    usNewsRank: 10,
    badgeURL: "badges/johns.png",
    photoURL: "photos/johns.jpg",
    introduction: "约翰斯·霍普金斯大学（英语：The Johns Hopkins University），简称霍普金斯（英语：Johns Hopkins、Hopkins或JHU），是一所主校区位于美国马里兰州巴尔的摩的研究型私立大学，1876年依据慈善家约翰斯·霍普金斯的遗嘱用其遗产建立。约翰斯·霍普金斯大学附设10个学院及主要分支机构，并在美国马里兰州、华府、意大利和中国设有校区或国际中心。"
  }
]


