// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface tokenRecipient {
    function receiveApproval(
        address _from,
        uint256 _value,
        address _token,
        bytes calldata _extraData
    ) external;
}

contract ManualToken {
    error ManualToken__TransferFailed();

    /** 代币的状态变量 */
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    /** 余额的映射 */
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /** 事件 */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    event Burn(address indexed from, uint256 value);

    /**
     * 构造函数
     *
     * 初始化代币名称、符号、初始值
     */
    constructor(
        uint256 initialSupply,
        string memory _name,
        string memory _symbol
    ) {
        // 更新代币总额
        totalSupply = initialSupply * 10 ** uint256(decimals); 
        // 将所有代币都给到合约创建者
        balanceOf[msg.sender] = totalSupply; 
        name = _name; 
        symbol = _symbol;
    }

    /**
     *  内部函数
     */
    function _transfer(address _from, address _to, uint256 _value) internal {
        //  检查合约是不是零地址
        require(_to != address(0x0));
        //  检查交易发送方是否有足够代币余额
        require(balanceOf[_from] >= _value);
        // 检查有否会有溢出
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        
        uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        //  触发事件
        emit Transfer(_from, _to, _value);
        
        if(balanceOf[_from] + balanceOf[_to] != previousBalances){
            revert ManualToken__TransferFailed();
        }
    }

    /**
     * 代币转移
     *
     * 从自己账户转移代币到交易接受方账户
     *
     * @param _to 交易接收方的地址
     * @param _value 交易的代币数量
     */
    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * 从其他地址转移代币
     *
     * 从发送方账户转移代币到交易接受方账户
     *
     * @param _from 交易发送方的地址
     * @param _to 交易接收方的地址
     * @param _value 交易的代币数量
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // 检查是否有权限
        require(_value <= allowance[_from][msg.sender]); 
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * 为其他地址设置转账权限
     *
     * 允许 _spender 花费不超过 _value 数量的代币
     *
     * @param _spender 授权花费的地址
     * @param _value 可以花费的最大代币金额
     */
    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * 设置其他地址的权限并进行通知
     *
     * 允许 _spender 花费不超过 _value 数量的代币，并在合约中 ping 出来
     *
     * @param _spender 授权花费的地址
     * @param _value 可以花费的最大代币金额
     * @param _extraData 发送到已批准合约的一些额外信息
     */
    function approveAndCall(
        address _spender,
        uint256 _value,
        bytes memory _extraData
    ) public returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(
                msg.sender,
                _value,
                address(this),
                _extraData
            );
            return true;
        }
    }

    /**
     * 销毁代币
     *
     * 从协议中不可逆地删除 _value 数量的代币
     *
     * @param _value 想要销毁的代币数量
     */
    function burn(uint256 _value) public returns (bool success) {
        //  检查函数调用者是否有足够数量的代币
        require(balanceOf[msg.sender] >= _value); 

        balanceOf[msg.sender] -= _value; 
        totalSupply -= _value; 
        emit Burn(msg.sender, _value);
        return true;
    }

    /**
     * 销毁其他账户的代币
     *
     * 从协议中不可逆地删除 _from 账户中 _value 数量的代币
     *
     * @param _from  想要进行代币销毁的目标账户地址
     * @param _value 想要销毁的代币数量
     */
    function burnFrom(
        address _from,
        uint256 _value
    ) public returns (bool success) {
        // 检查目标账户是否有足够余额
        require(balanceOf[_from] >= _value); 

        //  检查权限
        require(_value <= allowance[_from][msg.sender]); 

        balanceOf[_from] -= _value; 
        allowance[_from][msg.sender] -= _value; 
        totalSupply -= _value; 
        emit Burn(_from, _value);
        return true;
    } 

    function getBalance(address _to) public view returns(uint256) {
        return balanceOf[_to];
    }

    function getName() public view returns(string memory){
        return name;
    }

    function getSymbol() public view returns(string memory){
        return symbol;
    }

    function getAllowance(address _from, address _to) public view returns( uint256 ){
        return allowance[_from][_to]
    }
}