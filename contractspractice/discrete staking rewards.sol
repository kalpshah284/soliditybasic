// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "./ERC20.sol";
contract  discretestakingrewards {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardingToken;
    mapping (address => uint) public balanceOf;
    uint public totalSuppy;
    uint private rewardIndex;
    mapping (address => uint) private rewardIdexOf;
    mapping (address => uint) private earned;
    uint private constant MULTPLIER = 1e18;

    constructor (address _stakingToken, address _rewardingToken){
        stakingToken = IERC20(_stakingToken);
        rewardingToken = IERC20(_rewardingToken);
    }
    function updateRewardIdex(uint reward) external  {
        rewardingToken.transferFrom(msg.sender, address(this), reward); 
        rewardIndex += (reward * MULTPLIER) / totalSuppy;
    }
    function _calculatReward(address account) private view returns(uint) {
        uint shares = balanceOf[account];
        return (shares * (rewardIndex - rewardIdexOf[account])) / MULTPLIER;
    }
    function calculateRewardsEarned(address account) external view returns(uint) {
        return earned[account] + _calculatReward(account);
    }
    function updateReward(address account) private {
        earned[account] += _calculatReward(account);
        rewardIdexOf[account]  = rewardIndex; 
    }
    function stake(uint amount) external  {
        updateReward(msg.sender);
        balanceOf[msg.sender] += amount;
        totalSuppy += amount;
        stakingToken.transferFrom(msg.sender,address(this),amount);
    }
    function unstake(uint amount) external {
        updateReward(msg.sender);
        balanceOf[msg.sender] -= amount;
        totalSuppy -= amount;
        stakingToken.transfer(msg.sender,amount);
    }
    function claim() external returns (uint)  {
        updateReward(msg.sender);
        uint reward = earned[msg.sender];
        if(reward > 0){
            earned[msg.sender] = 0;
            rewardingToken.transfer(msg.sender,reward);
        }
        return reward;
    } 

} 