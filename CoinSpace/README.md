# Coin
Coin Digital currency wallet

Coin - A human-friendly digital currency wallet for multiple platforms | Bitcoin Wallet | Litecoin Wallet | Ethereum Wallet | Ripple Wallet | Stellar Wallet



start project 

1 安装mongodb
sudo apt-get install mongodb
安装完应该自动启动。如果需要手动启动，输入
sudo service mongodb start

2 安装依赖
cd CoinSpace/
npm install

3 修改配置文件
.env.example .env.loc
要在根目录下新建一个文件.env.loc
修改为如下内容：
DB_CONNECT=mongodb://localhost:27017
DB_NAME=coinSpace
COOKIE_SALT=1234
USERNAME_SALT=1234
NODE_ENV=development
PORT=8080
SITE_URL=http://localhost:8000/api/v1/
API_BTC_URL=https://btc.coin.space/api/
API_BCH_URL=https://bch.coin.space/api/
API_LTC_URL=https://ltc.coin.space/api/
API_ETH_URL=https://eth.coin.space/api/v1/
API_XRP_URL=https://xrp.coin.space/api/v1/
API_XLM_URL=https://xlm.coin.space/api/v1/
IOS_APP_ID=1234
SHAPESHIFT_API_KEY=‘’
ANDROID_BILLING_KEY=1234
GOOGLE_GTM=1234
IAP_APPLE_PASSWORD=1234
IAP_GOOGLE_PUBLIC_KEY=1234
保存退出

4 启动server
npm run server:watch

5 启动webpack
新建一个终端，输入 
npm run client:watch

6 浏览器输入
http://localhost:8000/