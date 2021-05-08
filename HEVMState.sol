interface Hevm {
    function warp(uint) external;
    function roll(uint) external;
    function store(address,bytes32,bytes32) external;
    function load(address,bytes32) external returns (bytes32);
}

contract HEVMState {
    bytes20 constant CHEAT_CODE =
        bytes20(uint160(uint(keccak256('hevm cheat code'))));
    Hevm hevm = Hevm(address(CHEAT_CODE));

    address me = address(this);

    mapping (address => mapping(bytes4 => uint256)) public slots;
    mapping (address => mapping(bytes4 => bool)) public finds;
}