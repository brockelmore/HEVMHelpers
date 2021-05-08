import "./HEVMHelpers.sol";
import "./HEVMState.sol";
import "./extensions/Governance.sol";
import "./extensions/Time.sol";
import "./extensions/Tokens.sol";


interface Hevm {
    function warp(uint) external;
    function roll(uint) external;
    function store(address,bytes32,bytes32) external;
    function load(address,bytes32) external;
}

// example usage
// 		contract TestMyContract is TestHelper {
//			function test_mytestfunction() public {...}
//      }
//
contract TestHelper is TimeExtensions, GovernanceExtensions, TokenExtensions, HEVMHelpers, HEVMState {


	// In a passing test, expect a revert with a string (takes a function signature and args and nonpayable)
	function expect_revert_with(
        address who,
        string memory sig,
        bytes memory args,
        string memory revert_string
    )
        public
    {
        bytes memory calld = abi.encodePacked(helper.sigs(sig), args);
        (bool success, bytes memory ret) = who.call(calld);
        assertTrue(!success);
        string memory ret_revert_string = abi.decode(slice(5, ret.length, ret), (string));
        assertEq(ret_revert_string, revert_string);
    }

    // In a passing test, expect a revert with a string (takes a function signature and args and *is* payable)
    function expect_revert_with(
        address who,
        string memory sig,
        bytes memory args,
        uint256 value,
        string memory revert_string
    )
        public
    {
        bytes memory calld = abi.encodePacked(helper.sigs(sig), args);
        (bool success, bytes memory ret) = who.call.value(value)(calld);
        assertTrue(!success);
        string memory ret_revert_string = abi.decode(slice(5, ret.length, ret), (string));
        assertEq(ret_revert_string, revert_string);
    }

    // pass as a 4byte function signature instead
    function expect_revert_with(
        address who,
        bytes4 sig,
        bytes memory args,
        string memory revert_string
    )
        public
    {
        bytes memory calld = abi.encodePacked(sig, args);
        (bool success, bytes memory ret) = who.call(calld);
        assertTrue(!success);
        string memory ret_revert_string = abi.decode(slice(5, ret.length, ret), (string));
        assertEq(ret_revert_string, revert_string);
    }
}