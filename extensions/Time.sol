
import "../HEVMState.sol";

contract TimeExtensions is HEVMHelpers {
    // increase block number by 1
    function bing() public {
        hevm.roll(block.number + 1);
    }
    
	// decrease block number by x
    function back() public {
        hevm.roll(block.number - 1);
    }

    // increase block number by x
    function bong(uint256 x) public {
        hevm.roll(block.number + x);
    }

    // decrease block number by x
    function blat(uint256 x) public {
        hevm.roll(block.number - x);
    }

    // increase block timestamp by x
    function ff(uint256 x) public {
        hevm.warp(block.timestamp + x);
    }

    // increase block timestamp by x
    function rev(uint256 x) public {
        hevm.warp(block.timestamp - x);
    }
}