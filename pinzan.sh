# new Env('品赞代理');
#by-莫老师，版本1.0
#青龙创建变量pinz，值为手机号@登录密码@aes密钥@套餐编号@套餐密钥
#例如13888888888@ABC12345@9c13sltjjjd5gk0a@20250101797178617771@46isnsn9jdn4uhx@71KUVS8SH7K
#cron:0 8 * * 1
IFS='@' read -r pzphone pass aeskey no key userid <<< "$pinz"
encoded=$(echo -n "${pzphone}QWERIPZAN1290QWER${pass}" | base64 | tr -d '\n')
t=$(head -c 400 /dev/urandom | xxd -p -l 200 | tr -d '\n' | head -c 400)
account=$(echo "${t:0:100}${encoded:0:8}${t:100:100}${encoded:8:12}${t:200:100}${encoded:20}${t:300:100}")
token=$(curl -sk -X POST -H "Host: service.ipzan.com" -H "Content-Type: application/json;charset=UTF-8" -d '{"account":"'$account'","source":"ipzan-home-one"}' "https://service.ipzan.com/users-login" | jq -r '.data.token')
curl -sk -X GET -H "Host: service.ipzan.com" -H "Authorization: Bearer $token" "https://service.ipzan.com/home/userWallet-receive" | jq -r '.data'