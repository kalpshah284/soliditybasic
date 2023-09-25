// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "./ERC20.sol";
contract CSAMM {
    IERC20 public immutable token0;
    IERC20 public immutable token1;
    uint public reserve0;
    uint public reserve1;
    uint public totalsupply;
    mapping (address => uint) public balanceOf;
    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);

    }
    function _min(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalsupply += _amount;
    }
    function _burn(address _from,uint _amount) private {
        balanceOf[_from] -= _amount;
        totalsupply -= _amount;
    }
    function _update(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }
    function swap(address _tokenIn, uint _amountIn) external returns (uint amountOut) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "invalid token"
        );
        require(_amountIn > 0, "amount in = 0");
        bool isToken0 = _tokenIn == address(token0);
       (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn, uint reserveOut) = isToken0
       ?(token0,token1,reserve0,reserve1)
       :(token1,token0,reserve1,reserve0);
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountInWithFee = (_amountIn * 997) / 1000;
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);

        tokenOut.transfer(msg.sender, amountOut);

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));


        
    }
    function addLiqudity(uint _amount0, uint _amount1) external returns (uint shares){
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));
        uint d0 = bal0 - reserve0;
        uint d1 = bal1 - reserve1;
        if(totalsupply == 0){
            shares = d0+d1;
        }
        else{
             shares =((d0 + d1) * totalsupply / reserve0 + reserve1);
        }
        require(shares > 0, "share = 0"); 
        _min(msg.sender, shares);  
        _update(bal0, bal1);  
    }
    function removeLiqudity(uint _shares) external returns (uint d0,uint d1) {
        d0 = (reserve0 / _shares) / totalsupply;
        d1 = (reserve1 / _shares) / totalsupply;
        _burn(msg.sender, _shares);
        _update(reserve0 - d0, reserve1 - d1);
        if (d0 > 0)token0.transfer(msg.sender, d0);
        if (d1 > 0)token1.transfer(msg.sender, d1);
    }   
    }
   
  


   
    