import axios, { AxiosError, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import promptAction from '@ohos.promptAction';

// 创建axios实例
export const instance = axios.create({
  baseURL: 'http://192.168.3.70:3000',
  timeout: 1000
})

// 添加请求拦截器
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  // 通过 AppStorage 获取 token
  const token = AppStorage.Get('token')
  if (token) {
    // 若 token 存在，则将其添加到请求头
    config.headers['token'] = token
  }
  return config;
}, (error: AxiosError) => {
  // 若出现异常，则提示异常信息
  promptAction.showToast({ message: error.message })
  return Promise.reject(error);
});

// 添加响应拦截器
instance.interceptors.response.use((response: AxiosResponse) => {
  // 若服务器返回的是正常数据，不做任何处理
  if (response.data.code === 200) {
    return response
  } else {
    // 若服务器返回的是异常数据，则提示异常信息
    promptAction.showToast({ message: response.data.message })
    return Promise.reject(response.data.message)
  }
}, (error: AxiosError) => {
  // 若出现异常，则提示异常信息
  promptAction.showToast({ message: error.message })
  return Promise.reject(error);
});