# 使用 Foundry 框架编写的稳定币合约

## 该项目旨在设计一种稳定币，用户可以存入 WETH 和 WBTC 以换取与美元挂钩的代币。
1. 这个 DSC 系统应该永远是过度抵押的，所有的抵押品价值都不应该小于等于其 DSC 的价值
2. 类似于没有治理的 DAI  只支持 WBTC 和 WETH
3. 此合约受到了 MakerDAO 的 DAI 的启发

## 前言
1. 本教程为 @Cyfrin 审计公司制作的以 Solidity 为基础的 Foundry 框架开发智能合约的初级课程，由 Patrcik Collins 老师主讲，全课程总时长为 21 小时
2. 课程中涵盖了 DeFi、NFT、StableCoin、合约安全等一系列的相关的课程介绍
3. 其课程由我 @lllu_23 进行中文精译后并上传到 B 站
4. 课程链接：
   1. [第 1-12 课](https://www.bilibili.com/video/BV13a4y1F7V3/)
   2. [第 13-15 课](https://www.bilibili.com/video/BV1u8411k7Z7)
5. 任何问题都欢迎 vx(lllu_23) 或者邮件(lllu2387443867@gmail.com)与我进行交流

# 开始步骤

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

Head over to [faucets.chain.link]and get some testnet ETH. You should see the ETH show up in your metamask.
前往 [faucets.chain.link](https://faucets.chain.link/) 并获取一些测试网 `ETH`

3. 部署

`make deploy ARGS="--network sepolia"`

## 脚本

除了脚本之外，我们还可以使用`cast`命令

例如在 Sepolia 测试网上:

1. 获取一些 WETH
```cast send 0xdd13E55209Fd76AfE204dBda4007C227904f0a81 "deposit()" --value 0.1ether --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY```

2. 授权 WETH
```cast send 0xdd13E55209Fd76AfE204dBda4007C227904f0a81 "approve(address,uint256)" 0x091EA0838eBD5b7ddA2F2A641B068d6D59639b98 1000000000000000000 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY```

3. 存入和铸造 DSC 代币
```cast send 0x091EA0838eBD5b7ddA2F2A641B068d6D59639b98 "depositCollateralAndMintDsc(address,uint256,uint256)" 0xdd13E55209Fd76AfE204dBda4007C227904f0a81 100000000000000000 10000000000000000 --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY```


## 估算 gas

你可以通过运行以下命令来估算交易的燃气成本：

```forge snapshot```

然后你会看到一个名为 `.gas-snapshot` 的输出文件

# 格式化

运行代码进行格式化：

```forge fmt```

# Slither
```slither :; slither . --config-file slither.config.json```

# 感谢观看!

Copyright @lllu_23

