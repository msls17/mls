# new Env('中国联通');
#by-莫老师，版本1.7
#青龙创建变量zglt，值为手机号@联通app登录密码
#例如13888888888@ABC12345
#cron:50 9 * * *
#需要开通权益超市会员才能使用https://contact.bol.wo.cn/market-act/introPrivileges?key=c%3DqZNyJ8B4%26p%3D243%3A1918178
#新增签到，权益超市抽奖及自动领取奖品功能，浇水
zh=($(echo $zglt | sed 's/&/ /g'))
tokens=($(cat zglt 2>/dev/null))
IFS='@' read -r pzphone pass aeskey no key <<< "$pinz"
rsa_encrypt() {
echo -n "$1" | openssl pkeyutl -encrypt -pubin -inkey <(echo "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDc+CZK9bBA9IU+gZUOc6FUGu7yO9WpTNB0PzmgFBh96Mg1WrovD1oqZ+eIF4LjvxKXGOdI79JRdve9NPhQo07+uqGQgE4imwNnRx7PFtCRryiIEcUoavuNtuRVoBAm6qdB0SrctgaqGfLgKvZHOnwTjyNqjBUxzMeQlEC2czEMSwIDAQAB" | base64 -d | openssl rsa -pubin -inform DER -outform PEM 2>/dev/null) -pkeyopt rsa_padding_mode:pkcs1 | base64 -w 0 | tr -d '\n'
}
login(){
device_id=$(echo -n "$mobile" | md5sum | cut -d' ' -f1)
tmp=$(curl -sk -X POST 'https://m.client.10010.com/mobileService/login.htm' -H 'User-Agent: Dalvik/2.1.0 (Linux; U; Android 15; PJZ110 Build/AP3A.240617.008);unicom{version:android@12.0601};ltst;' -H 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'isFirstInstall=0' --data-urlencode 'simCount=1' --data-urlencode 'yw_code=' --data-urlencode 'deviceOS=Android 15' --data-urlencode 'mobile='$(rsa_encrypt "$mobile")'' --data-urlencode 'netWay=Wifi' --data-urlencode 'deviceCode='$device_id'' --data-urlencode 'isRemberPwd=true' --data-urlencode 'version=android@12.0601' --data-urlencode 'deviceId='$device_id'' --data-urlencode 'password='$(rsa_encrypt "$pass${2:-000000}")'' --data-urlencode 'keyVersion=2' --data-urlencode 'pip=100.101.65.169' --data-urlencode 'provinceChanel=general' --data-urlencode 'appId=3f31e4f31439ef1c9288878871f9b2c2c3aa74c5e1f80b7290a3f652102e4382602a37f5c94307c204f6fb2ef22c4a2f0ffcd5a2815e8779c1255ba72b2bd96c8a8ab5ef51c63796a1bb02570c8da6e9' --data-urlencode 'simOperator=5,chn-ct,460,11,cn@5,--,460,11,cn' --data-urlencode 'deviceModel=PJZ110' --data-urlencode 'androidId=992c5115da660bd3' --data-urlencode 'deviceBrand=OnePlus' --data-urlencode 'uniqueIdentifier='$device_id'' --data-urlencode "timestamp=$(date +%Y%m%d%H%M%S)")
if [[ "$tmp" == *"ecs_token"* ]]; then
newtoken=$(echo "$tmp" | jq -r '.ecs_token')
echo "账号$mobile登陆成功"
if [ "$all" = 1 ]; then
echo "${zh[$s]}@$newtoken" >>zglt
else
sed -i 's/'$token'/'$newtoken'/g' zglt
fi
else
echo "账号$mobile未获取到token，可能登陆失败"
login
fi
}
rush(){
unset all_proxy
tmp=$(curl -sk -X POST -H "Host: backward.bol.wo.cn" -H "Content-type: application/json" -H "Authorization: Bearer ${qycstoken[0]}" -d '{"majorId":3,"subCodeList":["YOUCHOICEONE"],"currentTime":"'$(date +%Y-%-m-%-d)'","withUserStatus":1}' "https://backward.bol.wo.cn/prod-api/promotion/activity/roll/getActivitiesDetail?yGdtco4r=0IBed6GEqWJYyFa3zh3XQf8dzF3NdvdfrwSR1yaVIpxYehLewmhR8EHD2jANwdKqrV7y2W.TiI3mGC1BgeNPtOGADw0yQE.MmQcO.xSVxK5i4esBxeYYEGd3HTw6Uu5l2K3BK6Qt2N8HS3VjfknYJugdbzltdFLVb_f8EwTsMOzzwgpgv6Y2Hst6MLLwcJAVw0Jj6YnMh80vuojETo9qfjxHDGSrB9QJvXd2g0Imr0lCWQF3uyu8MmtzLpmlba2wuZm5hx0INOQODiwTQFBX16GTuG7LlwXdi9GwDOA3F854bdxO3EUrQKlEuJDrS1h8Q3LsIGrYGOlWZaazjbR_S.c8HWsL12_PalpoGuHohMWlssoyVehi9AbMtSsV2sftAgUkE1rqSTytC9a2waM2Wrea2MkZ2En.mP7x.Lp46_x8l.mpaw28uHRMKS8IKE2zJ6LmPiVmFjiPWeh4_Sycmim427Z4KGpobYDkDzjJKue4kwrBnWuOkyX3Tp4MOK2ivYgu7a0et_Xp7sn1ArX4Bf7dRi7T0Lzcbqa")
ids=($(echo ''$tmp'' | jq -r '.data[].detailList.[].id'))
products=($(echo ''$tmp'' | jq -r '.data[].detailList.[].productCode'))
names=($(echo ''$tmp'' | jq -r '.data[].detailList.[].productName'))
for q in "${!tokens[@]}"; do
IFS='@' read -r mobile pass token <<< "${tokens[$q]}"
curl -sk -X POST -H "Host: backward.bol.wo.cn" -H "Content-type: application/json" -H "Authorization: Bearer ${qycstoken[$q]}" -d '{"mobile":"'$mobile'","id":'${ids[0]}',"activityId":"YOUCHOICEONE"}' "https://backward.bol.wo.cn/prod-api/promotion/activity/roll/unlock/surpriseInterest?yGdtco4r=0osjbNqEqWHQw1zqDqibH3bi6qE7NN6fZpmf0xnH9BbcLYAY9eC7F5m0987FP0zcZOvW_crKDhgmGkAYLSXQYOvuiK69pvlSNFhhknqtbYCebFZMQVXDnOK4TgeOB0P0eCgkrnb3d21fUkbZESctdDju55xOR1Wx67Z0SRKvp_YHS4FeJuaaHz16Vu3fGHVoBR.Yw6q_yRj.Poki.cQ3IThgWGbbv.GZ1H9fKc44fbjJUgtUqzBwYGCIbn8C62VX4LcNgyT4E4Ec7Itsb.KDt7QZbHxqQ5JWTfPPVtKk0lqpwerv55LdZYo3RGxEz6z3oW41QFjEXel8Qa6pPdvTMaHlKcrzAZ.dLX3ueAQFntqpQnKyiZhmy9ejJSGD5TSa1Y1ome8nvU_QKYDWcOoU5i_5a3yOCVnDxAF5SWlmkOvuF2BqvPu4JnXPh25cgEGPs7iGn_f3KIIKRLHPTga028cfBx2uQWw9haWNj04txWTfHW.9077j7vJRcL.4eXhAbKVJMgIOlvc41wFTS59M8P2lWpzTCkx.RNA" | jq -r '.msg'
done
sm=$(($(date -d "10:00:00" +%s) - $(date +%s)))
echo "稍等$sm秒"
sleep $sm
for s in "${!tokens[@]}"; do
IFS='@' read -r mobile pass token <<< "${tokens[$s]}"
for x in "${!ids[@]}"; do
echo "账号$mobile领取${products[$x]}$(curl -sk -X POST -H "Host: backward.bol.wo.cn" -H "Content-type: application/json" -H "Authorization: Bearer ${qycstoken[$s]}" -d '{"channelId":null,"activityId":11,"productId":'${ids[$x]}',"productCode":"'${products[$x]}'","currentTime":"'$(date +%Y-%-m-%-d)'","accountType":"4"}' "https://backward.bol.wo.cn/prod-api/promotion/activity/roll/receiveRights?yGdtco4r=0q977DqEqWJUYSTYzWxJshdusO25Hrw4imYaQ29TDGZlgW8.HSRQhA64Sq1.zsleJFuZQFsKdc3mGa9J4FNbwiweQpenoL5OlVi4hMHaFxJlpWtaUadt4oZ8IDPdjayrfxCko1u4GyfTIFsY1ah8UDanbMzvFOwvt_8VFBWUOz69d6WMUZrUDih3rR6AWegCKcQ09xGjDj28lTvmnbVbuXSO8VLAog7KXPoEyG6PzcjJ5kvSivJJ8r_KeWTdS4IWNGetTsy1qgbihos0rDM1Ion.YFMij0ThB_EudeyYW7hM5s9oztud3Bh_3OFtaFUKCrZ3zF8WPoHxSYwAYdZFXL2we_1KreoNoORRT3Ur_RF7xE0KzkncrlRh_swfRjMlDCPjIx937zYcy7Nqg79KLQXJTD8N3z7My5imFf.x8WeabZ6ALpQLFKl5vfRiB1ykWBg50e5ACcXoH1Yurs6YWOET9A2G_XTGhWgXtfn4gBsIDblh84upwz6PPhEpQAguU5PkS2OqtxP3C.rWRrAuaKKJLnkeGr7TIbG" | jq -r '.msg')"
done
done
}
qylogin(){
ticket=$(curl -sik -X GET -H "Host: m.client.10010.com" -H "user-agent: Dalvik/2.1.0 (Linux; U; Android 15; PJZ110 Build/AP3A.240617.008);unicom{version:android@12.0601};ltst;" -H "cookie: ecs_token=$token" "https://m.client.10010.com/mobileService/openPlatform/openPlatLineNew.htm?to_url=https%3A%2F%2Fcontact.bol.wo.cn%2Fmarket" | grep -o 'ticket=[^&]*' | cut -d'=' -f2)
if [ -z "$ticket" ]; then
echo "账号$mobile未获取到ticket，可能token失效"
else
tmp=$(curl -sk -X POST "https://backward.bol.wo.cn/prod-api/auth/marketUnicomLogin?yGdtco4r=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9._-' | fold -w 800 | head -n 1)" -H "Host: backward.bol.wo.cn" -H "Content-type: application/x-www-form-urlencoded" -d "ticket=$ticket")
qycstoken[$s]=$(echo "$tmp" | jq '.data.token' | sed 's/\"//g')
fi
}
#localip=$(curl -sk -X GET "https://ip.3322.net")
#curl -sk -X GET -H "Host: service.ipzan.com" "https://service.ipzan.com/whiteList-add?no=$no&sign=$(echo -n "$pass:$key:$(date +%s)" | openssl enc -aes-128-ecb -K "$(echo -n "$aeskey" | xxd -p)" -nosalt | xxd -p | tr -d '\n')&ip=$localip"
getip(){
tmp=$(curl -sk -X GET "https://service.ipzan.com/core-extract?num=1&no=$no&minute=3&format=json&repeat=1&protocol=3&pool=ordinary&mode=whitelist&secret=$key")
ip=$(echo ''$tmp'' | jq -r '.data.list[].ip')
port=$(echo ''$tmp'' | jq -r '.data.list[].port')
if [ -n "$ip" ]; then
export all_proxy="socks5://$ip:$port"
if [ "$(curl -sk -X GET "https://ip.3322.net")" = "$ip" ]; then
echo "###$ip:$port可用###"
else
unset all_proxy
sleep 3
echo "###$ip:$port不可用##"
getip
fi
fi
}
cj(){
count=0
for s in "${!tokens[@]}"; do
IFS='@' read -r mobile pass token <<< "${tokens[$s]}"
qylogin
num=$(curl -sk -X POST -H "Host: backward.bol.wo.cn" -H "Authorization: Bearer ${qycstoken[$s]}" -d "" "https://backward.bol.wo.cn/prod-api/promotion/home/raffleActivity/getUserRaffleCount?yGdtco4r=0d_cINGEqWiIlnHQkS15F8BrZkdOE.GAMGVsUXeS1p8.PGs1.DejSqtWJITeW2ClV3l6z2abPVEmaUizUh.IyjFtLCn0SHJNvxeZj450ehQxfQPnXpI6.ShPV9a3hfvdJe9Gw9JTrnzDjYjai2WU0DvFczrsjeDVi5G0_LcSW1kjS_LMrNLmc2jQSQm6PH6T.hOcUf.Iukhi9TSO2A8lcR3LQ9XB0sX0SeSSUq_FJU6f8T93jgC.gQnA24en64Uz6VG7QKKf5tLdYXSAEuQXnm24cSAlNFGlgwZuBFPE2dB1CXgOexgYr8J4m4Cs5PDkjWvr0VGw4eXuzXC2W1JvYwbehO07Y_bQvs5NpyuXSdcoAZBl6NznoCmmnNdIReFZbqg1GH2xvQdMtOeNRCymNLHISW5sybfRTrET9436jnnW.PC2q6J8arHkM7dA2iIzFD1EEciFD04_9E0I4bxFkpZfzByY9F_eWvE2nKge5xkKX_vWG.1wICJr4fTVbnZyfmbWaWgc1Cnst4uUHy3KWBByI1C38iVTr_T_lmaO3yiLsVLA4ILxk9KQ" | jq '.data')
echo "$mobile获得$num次抽奖次数，开始抽奖"
for i in $(seq $num); do
#if [ $((count % 15)) -eq 0 ]; then
#getip
#fi
tmp=$(curl -sk -X POST -H "Host: backward.bol.wo.cn" -H "Authorization: Bearer ${qycstoken[$s]}" -d "" "https://backward.bol.wo.cn/prod-api/promotion/home/raffleActivity/userRaffle?yGdtco4r=0xw7jwGEqWljEGt2ANu_NAJ97mYKiQ.nAMIxnrGTRttR07V7bNk5BY236SgGjgiilh0_4elJgOgmaA.HEMXeg1Zp8hovSf.nfzOJUbYGTHoxZrDhRp92KAZPtvYcUmJy6bREzZ9WqY.f2VkfQo7qJbX6WYjXP5q9g9gH5t3kRKCoT3Sx6c0Kwu6d5bIyt_6IIDl_dD0P60MxNLZFRMTIPyGcm70oirbNfbuIxVZATKKxmMNAqIRxnxS6SINKLel4UoKTSM_owT7Dk1jPDbTs2nLavAfDzQ2NylBB6tYtmqaZgdTVjiUd3mdJ5eJQM.p4Ifu54c49Ut7ov.MoQQkzd5qLHRxAHIU50s1cUY4rkMSV3DhhejGVV3uUGe9QcezxJUmmXQn3W3IfGganHgGyotzYgH8pKvlVpsKfyGGZYh8Ve8SHhNYB1jZ1lJ8cA6abrGZnyiwRjARM6US5Yzn0HRyx6bGRXZ6_IX9I0eOvl_7H7SzQdnaC97jOI8ikZBlguw.EIh9GXAGnn_8po2nJVI0NmxvqXXe9laXlUyRn4_HuQ4YGfDn.pXkZ")
recordId=$(echo "$tmp" | jq '.data.lotteryRecordId')
if [ "$recordId" = "0" ]; then
echo "未中奖"
elif [ "$recordId" = "null" ]; then
echo "未成功抽奖，可能ip达到抽奖上限"
else
echo "恭喜中奖$recordId$(echo "$tmp" | jq '.data.prizesName')领取$(curl -sk -X POST -H "Host: backward.bol.wo.cn" -H "Content-type: application/json" -H "Authorization: Bearer ${qycstoken[$s]}" -d '{"recordId":'$recordId'}' "https://backward.bol.wo.cn/prod-api/promotion/home/raffleActivity/grantPrize?yGdtco4r=01L2CxGEqWHHozTGSIbfqETYzeEvoJwXCjqIoMqKNqnxm1fYjlXF_myIoOZWoNusng0bhfGbtR3mG6baLTYVCTdv02fcLKgaWCCIkJnKHsA6bXUr4g6Gl_jQqFG30brnzkodHm_sw5ijbgKuIWzpVWr1QV.l.ToZ4v.ejQg3U7xPvTY1aaibVPseA2Fa.UpRMtLQtE7EOwnpE_c8R3tlCU0UznOpOp6NNk_Pc5NizBulDy1ylukICTF2kNg0uU9uWmf7GtLHGscrJHLGkOuW4DO8oA0y6dSQMm4494rlT8vXXqUzEWIU6SaAajMowecGJhNveg9QYU4dC6BmDDgsoO33kCVY4WHPNPIjGAXRbZz2yHDNNLBY7HP0S.1jNlUyiLa88BFbU8eNGzhgdzv_iopQKiR4Dx1X4ZLIw7mvxwR2orKhHh0jHdQPsbiBg1pJETJC5L5zOOzEOYCHbaZaN_S8QsqzzKGJw.uuznMy09cEv0Xhkh0a_Se_6wUAUjEmodHuvd.hWbGUXdY0wFQm9HMAR5J5SZ9zckG" | jq '.msg'))"
fi
sleep $((2 + RANDOM % 2))
let count++
done
curl -sk -X POST -H "Host: backward.bol.wo.cn" -H "Content-type: application/json" -H "Authorization: Bearer ${qycstoken[$s]}" -d "{}" "https://backward.bol.wo.cn/prod-api/promotion/activityTaskShare/checkWatering?yGdtco4r=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9._-' | fold -w 547 | head -n 1)" | jq '.msg'
done
}
appqd(){
for s in "${!tokens[@]}"; do
IFS='@' read -r mobile pass token <<< "${tokens[$s]}"
sign=$(curl -sk -X POST -H "Host: activity.10010.com" -H "Content-Type: application/x-www-form-urlencoded" -H "User-Agent: Mozilla/5.0 (Linux; Android 13; M2102J2SC Build/TKQ1.221114.001; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/116.0.0.0 Mobile Safari/537.36; unicom{version:android@12.0601,desmobile:0};devicetype{deviceBrand:Xiaomi,deviceModel:M2102J2SC};OSVersion/13;ltst;" -H "Cookie: ecs_token=$token" -d "shareCl=&shareCode=" "https://activity.10010.com/sixPalaceGridTurntableLottery/signin/daySign" | jq -r '.data.redSignMessage')
if [ "$sign" = "null" ]; then
login
else
echo "签到$sign"
fi
done
}
if [ -f "zglt" ]; then
appqd
cj
else
all=1
for s in "${!zh[@]}"; do
IFS='@' read -r mobile pass <<< "${zh[$s]}"
login
done
appqd
cj
fi
rush
