export interface UniversityInfo {
  id: number;
  nameCN: string;
  nameUS: string;
  alias: string;
  location: string;
  usNewsRank: number;
  badgeURL: string;
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
  },
  {
    id: 1,
    nameCN: "麻省理工学院",
    nameUS: "Massachusetts Institute of Technology",
    alias: "mit",
    location: "剑桥，马萨诸塞",
    usNewsRank: 2,
    badgeURL: "badges/mit.png",
  },
  {
    id: 2,
    nameCN: "哈佛大学",
    nameUS: "Harvard University",
    alias: "harvard",
    location: "剑桥，马萨诸塞",
    usNewsRank: 3,
    badgeURL: "badges/harvard.png",
  },
  {
    id: 3,
    nameCN: "斯坦福大学",
    nameUS: "Stanford University",
    alias: "stanford",
    location: "斯坦福，加利福尼亚",
    usNewsRank: 3,
    badgeURL: "badges/stanford.png",
  },
  {
    id: 4,
    nameCN: "耶鲁大学",
    nameUS: "Yale University",
    alias: "yale",
    location: "纽黑文，康涅狄格",
    usNewsRank: 5,
    badgeURL: "badges/yale.png",
  },
  {
    id: 5,
    nameCN: "宾夕法尼亚大学",
    nameUS: "University of Pennsylvania",
    alias: "pennsylvania",
    location: "费城，宾夕法尼亚",
    usNewsRank: 6,
    badgeURL: "badges/pennsylvania.png",
  },
  {
    id: 6,
    nameCN: "加州理工学院",
    nameUS: "California Institute of Technology",
    alias: "cit",
    location: "帕萨迪纳，加利福尼亚",
    usNewsRank: 7,
    badgeURL: "badges/cit.png",
  },
  {
    id: 7,
    nameCN: "杜克大学",
    nameUS: "Duke University",
    alias: "duke",
    location: "达勒姆，北卡罗莱纳",
    usNewsRank: 8,
    badgeURL: "badges/duke.png",
  },
  {
    id: 8,
    nameCN: "布朗大学",
    nameUS: "Brown University",
    alias: "brown",
    location: "普罗维登斯，罗德岛",
    usNewsRank: 9,
    badgeURL: "badges/brown.png",
  },
  {
    id: 9,
    nameCN: "约翰斯霍普金斯大学",
    nameUS: "Johns Hopkins University",
    alias: "johns",
    location: "巴尔的摩，马里兰",
    usNewsRank: 10,
    badgeURL: "badges/johns.png",
  },
]


