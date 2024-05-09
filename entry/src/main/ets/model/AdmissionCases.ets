export interface AdmissionCase {
  admissionYear: number;
  graduateUniversity: string;
  graduateMajor: string;
  undergraduateUniversity: string;
  undergraduateMajor: string;
  gpa: number;
  toefl: number;
  gre: number;
}

export const admissionCaseData: AdmissionCase[] = [
  {
    admissionYear: 2024,
    graduateUniversity: "普林斯顿大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "普林斯顿大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "普林斯顿大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "普林斯顿大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "普林斯顿大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "普林斯顿大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "普林斯顿大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "斯坦福大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "斯坦福大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
  {
    admissionYear: 2024,
    graduateUniversity: "斯坦福大学",
    graduateMajor: "计算机科学",
    undergraduateUniversity: "上海交通大学",
    undergraduateMajor: "计算机科学与技术",
    gpa: 3.8,
    toefl: 110,
    gre: 330,
  },
]

export function getAdmissionCasesByUniversity(graduateUniversity: string) {
  let indexes: number[] = [];
  for (let i = 0; i < admissionCaseData.length; i++) {
    if (admissionCaseData[i]["graduateUniversity"] === graduateUniversity) {
      indexes.push(i)
    }
  }
  return indexes.map(index => admissionCaseData[index])
}


