# Trias Web Wallet
Trias Web Wallet is an open-source, easy-to-use and secure client-side wallet for easily & securely interacting with the Ethereum and Trias network.

## Features
- Create new wallets completely client side.
- Access your wallet via unencrypted private key, encrypted private key, keystore files, mnemonics, or Digital Bitbox, Ledger Nano S or TREZOR hardware wallet.
- Easily send TRY, ETH and *any* ERC-20 Standard Token. 
- Generate, sign & send transactions offline, ensuring your private keys never touch an internet-connected device.
- Securely access your ETH & Tokens on your [Digital Bitbox, Ledger or TREZOR Hardware Wallet](https://myetherwallet.groovehq.com/knowledge_base/topics/hardware-wallet-recommends) via the Trias Web Wallet interface (Chrome & Opera natively, Firefox w/ [add-on](https://addons.mozilla.org/en-US/firefox/addon/u2f-support-add-on/))
- Never save, store, or transmit secret info, like passwords or keys.
- No tracking of private info like email or name.

## Developers
If you want to help contribute, here's what you need to know to get it up and running and compiling.

- The mercury branch is currently the active development branch.
- Both the Chrome Extension and the wallet.trias.one are compiling from the same codebase. This code is found in the `app` folder. Don't touch the `dist` or `chrome-extension` folders.
- We use angular and bootstrap. We used to use jQuery and Bootstrap until it was converted in April 2016. If you wonder why some things are set up funky, that's why.
- We use npm / gulp for compiling. There is a lot of stuff happening in the compilation.

### Getting Started

- Start by running `npm install`.
- Run `npm run dev`. Gulp will then watch & compile everything and then watch for changes to the HTML, JS, or CSS.
- For distribution, run `npm run dist`.

### Folder Structure
- `fonts` and `images` get moved into their respective folders. This isn't watched via gulp so if you add an image or font, you need to run `gulp` again.
- `includes` are the pieces of the pages / the pages themselves. These are pretty self-explanatory and where you will make most frontend changes.
- `layouts` are the pages themselves. These basically take all the pieces of the pages and compile into one massive page. The navigation is also found here...sort of.
    * `index.html` is for wallet.trias.one.
    * `cx-wallet.html` is the main page for the Chrome Extension.

- You can control what shows up on wallet.trias.one vs the Chrome Extension by using: `@@if (site === 'cx' )  {  ...  }` and `@@if (site === 'mew' ) { ... }`. Check out `sendTransaction.tpl` to see it in action. The former will only compile for the Chrome Extension. The latter only to wallet.trias.one.
- The wallet decrypt directives are at `scripts/directives/walletDecryptDrtv.js`. These show up on a lot of pages.
- The navigation is in `scripts/services/globalServices.js`. Again, we control which navigation items show up in which version of the site in this single file.
- As of September 2016, almost all the copy in the .tpl files are only there as placeholders. It all gets replaced via angular-translate. If you want to change some copy you need to do so in `scripts/translations/en.js` folder. You should also make a note about what you changed and move it to the top of the file so that we can make sure it gets translated if necessary.
- `styles` is all the less. It's a couple custom folders and bootstrap. This badly needs to be redone. Ugh.

### Backend
Backend provide tri(v1) rpc call and tri(v1)/eth swap function.
- Run `pip3 install -r requirements.txt` to install dependencies.
- Next, run `python3 manage.py runserver` to start the django server.

#### Requirements
 - python: 3.4 or later.
 - Django: 1.9.7 or later.
 - requests
 - pycrypto
 - eth_account
 - mysqlclient

#### log files
 - sudo mkdir /var/log/trias
 - sudo touch /var/log/trias/wallet.log
 - sudo touch /var/log/trias/wallet_request.log
 - sudo chmod 777 /var/log/trias/wallet.log
 - sudo chmod 777 /var/log/trias/wallet_request.log

#### change config file
config file path is conf/conf.json
 - replace eth_ip value with trias public chain node's ip. for example "192.168.1.1"
 - replace eth_port value with trias public chain node's rpc port number. for example "8545"
 - replace mysql_ip value with your mysql database server's ip. for example "192.168.1.1"
 - replace mysql_port value with your mysql database server's port number. for example "3306"
 - replace mysql_user value with your mysql user name. for example "user"
 - replace mysql_password value with your mysql user password. for example "pass"
 - replace mysql_database value with your mysql database name. for example "db"
 - replace request_interval value with your rpc request interval seconds. for example "5"
 - replace private_key_encrypt_pass value with private key aes encrypt passwod. for example "password"
 - replace etherscan_key value with your etherscan api key. please refer to https://etherscan.io/apis

## A Note on Production Readiness

While Trias is being used in production in private, permissioned
environments, we are still working actively to harden and audit it in preparation
for use in public blockchains.
We are also still making breaking changes to the protocol and the APIs.
Thus, we tag the releases as _alpha software_.

In any case, if you intend to run Trias in production,
please [contact us](mailto:contact@trias.one) and [join the chat](https://www.trias.one).

## Security

To report a security vulnerability, [bug report](mailto:contact@trias.one).

## Contributing

All code contributions and document maintenance are temporarily responsible for TriasLab.

Trias are now developing at a high speed and we are looking forward to working with quality partners who are interested in Trias. If you want to join，please contact us:

- [Telegram](https://t.me/triaslab)
- [Medium](https://medium.com/@Triaslab)
- [BiYong](https://0.plus/#/triaslab)
- [Twitter](https://twitter.com/triaslab)
- [Gitbub](https://github.com/trias-lab/Documentation)
- [Reddit](https://www.reddit.com/r/Trias_Lab)
- [More](https://www.trias.one/)
- [Email](mailto:contact@trias.one)

### Upgrades

Trias is responsible for the code and documentation upgrades for all Trias modules. In an effort to avoid accumulating technical debt prior to Beta, we do not guarantee that data breaking changes (ie. bumps in the MINOR version) will work with existing Trias blockchains. In these cases you will have to start a new blockchain, or write something custom to get the old data into the new chain.

## Resources

### Research

- [The latest paper](https://www.contact@trias.one/attachment/Trias-whitepaper%20attachments.zip)
- [Project process](https://trias.one/updates/project)
- [Original Whitepaper](https://trias.one/whitepaper)
- [News room](https://trias.one/updates/recent)