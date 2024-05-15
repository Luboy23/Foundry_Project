# 使用 Foundry 编写的筹集资金合约

## 前言
1. 本教程为 @Cyfrin 审计公司制作的以 Solidity 为基础的 Foundry 框架开发智能合约的初级课程，由 Patrcik Collins 老师主讲，全课程总时长为 21 小时
2. 课程中涵盖了 DeFi、NFT、StableCoin、合约安全等一系列的相关的课程介绍
3. 其课程由我 @lllu_23 进行中文精译后并上传到 B 站
4. 课程链接：
   1. [第 1-12 课](https://www.bilibili.com/video/BV13a4y1F7V3/)
   2. [第 13-15 课](https://www.bilibili.com/video/BV1u8411k7Z7)
5. 任何问题都欢迎 vx(lllu_23) 或者邮件(lllu2387443867@gmail.com)与我进行交流

## 合约部分

这个合约是一个简单的包含提款与取款功能的 Fund 合约
其中主要包含一个`fund`函数以及两个`withdraw`函数,其中`cheaperWithdraw`函数会花费更便宜的 gas

## 测试部分

其中包含了`单元测试`以及`集成测试`

# 快速启动

## 配置需求

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

   - 如果你可以运行 `git --version` 并看到类似 `git version x.x.x` 的响应，则表示你已经正确安装了git

- [foundry](https://getfoundry.sh/)

   - 如果你可以运行 `forge --version`并看到类似 `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)` 的响应，则表示你已经正确安装了foundry

## 快速启动

`git clone https://github.com/Luboy23/Foundry_Project`
`cd Foundry_Project`
`forge build`

# 使用方法

## 部署:

```forge script script/DeployFundMe.s.sol```

## 测试

```forge test```

或者 运行与指定正则模式匹配的测试函数

```forge test -m testFunctionName``` 已经被弃用，请使用 ```forge test --match-test testFunctionName```,这一点我在B站视频的评论区也提到了

或者

```forge test --fork-url $SEPOLIA_RPC_URL```

### 测试覆盖率

```forge coverage```

# 部署到测试网或主网

1. 设置环境变量

你需要设置你的 `SEPOLIA_RPC_URL` 和 `PRIVATE_KEY` 作为环境变量你可以将它们添加到一个 `.env` 文件中，类似于你在 `.env.example` 中看到的内容

- `PRIVATE_KEY`: 账户的私钥 注意：对于开发，请使用不关联任何真实资金的密钥
- `SEPOLIA_RPC_URL`: 这是你正在使用的 `Sepolia` 测试网络节点的 `url`

如果你希望在 [Etherscan](https://etherscan.io/).上验证你的合约，则可以选择添加你的 `ETHERSCAN_API_KEY`

2. 获取测试网ETH
前往 [faucets.chain.link](https://faucets.chain.link/) 并获取一些测试网 `ETH`

3. 部署

```sh {"id":"01HR4B1ZG67TXSXC15DX8NP3CS"}
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## 脚本

在部署到测试网或本地网络后，可以运行脚本

使用在本地部署的 `cast` 示例：
```cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>```

或者

```forge script script/Interactions.s.sol --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast```

### 提款

```cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()"  --private-key <PRIVATE_KEY>```

## 估算 gas

你可以通过运行以下命令来估算交易的燃气成本：

```forge snapshot```

然后你会看到一个名为 `.gas-snapshot` 的输出文件

# 格式化

运行代码进行格式化：

```forge fmt```

# 感谢观看!

Copyright @lllu_23


