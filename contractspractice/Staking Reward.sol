// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./ERC20.sol";
contract StakingReward{
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardToken;
    address public owner;

    uint public duration;
    uint public finishAt;
    uint public updateAt;
    uint public rewardRate;
    uint public rewardPerTokenStored;
    mapping (address => uint) public userRewardPerTokenPaid;
    mapping (address => uint) public rewards;
    uint public totalSupply;
    mapping (address => uint) public balanceOf;
    modifier OnlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }
    constructor(address _stakingToken , address _rewardToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }
    function setRewardDuration(uint _duration) external OnlyOwner  {
        duration = _duration;
        require(finishAt < block.timestamp, "reward duration not finished");
    }
    function notifyRewardAmount(uint _amount) external OnlyOwner  {
        if(block.timestamp > finishAt){
        rewardRate = _amount/ duration;
        }
        else {
        uint RemainingRewards = rewardRate * (finishAt - block.timestamp);
        rewardRate = (RemainingRewards + _amount)/ duration;
        }
        require(rewardRate > 0, "reward Rate = 0");
        require(
                rewardRate * duration <= rewardToken.balanceOf(address(this)),
                "reward amt >  balance"
               );
    }
    function stake(uint _amount) external  {
        require(_amount > 0, "amount = 0");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        balanceOf[msg.sender] += _amount;
        totalSupply += _amount;

    }
    function withdraw(uint _amount) external  {
        require(_amount > 0, "amount = 0");
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        stakingToken.transfer(msg.sender, _amount);

    }
    function rewardPerToken(uint _amount) public returns (uint)  {
        if(totalSupply == 0){
        return rewardPerTokenStored;
        }
        return rewardPerTokenStored + (rewardRate * (min(block.timestamp,finishAt) - updateAt) * 1e18
        ) /totalSupply;
        
    }
    function earn(uint _account) external view returns (uint) {
        return (balanceOf[_account] * ((rewardPerToken() - userRewardPerTokenPaid[_account]) /1e18
        ) + rewards[_account];
    }
    function getreward (uint _account) external view  {
        
    }


}
