//获取验证码
import { instance } from './Axios';
export function sendCode(phone: string) {
  return instance.get('/word/user/code', { params: { phone: phone } });
}

//登录
export function login(phone: string, code: string) {
  return instance.post('/word/user/login', { phone: phone, code: code });
}