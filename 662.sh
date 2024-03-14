#!/bin/bash
#澳门新葡京，每天三场红包，每场1-2元，变量名xpjck，值_U=
# new Env('新葡京');
#by:莫老师 https://6623335.com/#/?c=msls
#需要安装python依赖pycryptodomex，pycryptodome
#cron:0 11,16,20 * * *
ck=($(echo $xpjck | sed 's/&/ /g'))
characters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
id=$(python -c "from Crypto.Cipher import AES; import base64; key = 'nzbhuBzAjw8SLEJRDIMUA9fu'; iv = '12345678ABCDEFGH'; ciphertext = '$(curl -sk -X POST -H "rType: 3" -H "Content-Type: application/json; charset=utf-8" -H "Host: zhj.lhhsgjjz.com:8443" -H "Cookie: _U=$ck" -d '{"s":"2e45ab9bc59eda299731559480979896aa902788","t":1701523587552,"d":"k+pX/GwcWmXrdBeAWuydvQ==","k":"gsLbZyQo6pctQxX23SAQ6UKIY68qH8FA0IRS4///xWZ3qeAGIJO3nSzSgxLJEDmMepqihYpHdShzdLQ2QL38KVYruxYl4z5+CiwVPDULY9sZLH+L2TN09lF0lvswCk4w51iuJVqjdJ79DknAJWtKH51PrgK0s2Ix/y/j/7IZIjs="}' "https://zhj.lhhsgjjz.com/luckymoney/luckymoney/get-info" | jq -r '.d')'; aes = AES.new(key.encode('utf-8'), AES.MODE_CBC, iv.encode('utf-8')); decrypted_text = aes.decrypt(base64.b64decode(ciphertext)).decode('utf-8'); print(decrypted_text)" | jq -r '.data.id')
sleep $((RANDOM % 178))
for c in $(seq 24)
do
for s in $(seq 0 1 $((${#ck[@]}-1)))
do
my=$(cat /dev/urandom | tr -dc "$characters" | fold -w 24 | head -n 1)
time=$(date '+%s%3N')
tmp=$(curl -sk -X POST -H "rType: 3" -H "Content-Type: application/json; charset=utf-8" -H "Host: zhj.lhhsgjjz.com:8443" -H "Cookie: _U=${ck[$s]}" -d '{"s":"'$(echo -n "lm_id%3D$id%26sign_aeskey%3D$my%26sign_timestamp%3D$time%26sign_uri%3D%2Fluckymoney%2Fluckymoney%2Fstart%26token%3D%26type%3D4" | openssl dgst -sha1 | awk '{print $2}')'","t":'$time',"d":"'$(python -c "from Crypto.Cipher import AES; import base64; from Crypto.Util.Padding import pad; plaintext = b'{\"type\":\"4\",\"lm_id\":\"$id\",\"token\":\"\"}'; iv = b'12345678ABCDEFGH'; key = b'$my'; padded_plaintext = pad(plaintext, AES.block_size); cipher = AES.new(key, AES.MODE_CBC, iv); ciphertext = cipher.encrypt(padded_plaintext); encoded_ciphertext = base64.b64encode(ciphertext); print(encoded_ciphertext.decode())")'","k":"'$(python -c "import base64; from Cryptodome.PublicKey import RSA; from Cryptodome.Cipher import PKCS1_v1_5; text = '$my'.encode('utf-8'); public_key = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRP4uMJa/tCV1MvZNKt2HogSPIzeLxCLY9MMq5PGUOjdaY3okDpzWmvR0jYtdJf77cC/Xt/Yped/ZTeRP7ILULBnYrTUCkLq7lkoPM7v0kUDqd4xnyP4pNCTPN/jDN2DH6mpEq46Cj/mhakHCg8Ei0ZCrVOWi4VdOfnPf/cJO9RQIDAQAB'; public_key = base64.b64decode(public_key); rsa_key = RSA.importKey(public_key); cipher = PKCS1_v1_5.new(rsa_key); ciphertext = cipher.encrypt(text); result = base64.b64encode(ciphertext); print(result.decode('utf-8'))")'"}' "https://zhj.lhhsgjjz.com/luckymoney/luckymoney/start")
msg=$(echo -e "$tmp" | jq -r '.errmsg')
if [ "$msg" = null ]; then
msg=$(python -c "from Crypto.Cipher import AES; import base64; key = '$my'; iv = '12345678ABCDEFGH'; ciphertext = '$(echo -e "$tmp" | jq -r '.d')'; aes = AES.new(key.encode('utf-8'), AES.MODE_CBC, iv.encode('utf-8')); decrypted_text = aes.decrypt(base64.b64decode(ciphertext)).decode('utf-8'); print(decrypted_text)" | jq -r '.data.get_amount')
echo "账号$s本次抢到$msg元"
exit
else
if echo "$msg" | grep -q "超时"; then
curl -sk -X POST -H "Host: wxpusher.zjiecode.com" -H "Content-Type: application/json" -d '{"appToken":"'$apptoken'","content":"新葡京账号'$s'可能已失效，请重新抓包","contentType":1,"topicIds":['$topicId'], "url":"https://wxpusher.zjiecode.com","verifyPay":false}' "https://wxpusher.zjiecode.com/api/send/message"| jq -r '.msg'
exit
else
echo $msg
sleep 5s
fi
fi
done
wait
done
