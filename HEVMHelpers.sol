pragma solidity 0.5.15;

import { DSTest } from "./test.sol";
import { IERC20 } from "./IERC20.sol";

interface Hevm {
    function warp(uint) external;
    function roll(uint) external;
    function store(address,bytes32,bytes32) external;
    function load(address,bytes32) external returns (bytes32);
}

contract HEVMHelpers is DSTest {

    event Debug(uint, bytes32);
    event Logger(uint, bytes);

    bytes20 constant CHEAT_CODE =
        bytes20(uint160(uint(keccak256('hevm cheat code'))));

    mapping (address => mapping(bytes4 => uint256)) public slots;
    mapping (address => mapping(bytes4 => bool)) public finds;

    function sigs(
        string memory sig
    )
        public
        pure
        returns (bytes4)
    {
        return bytes4(keccak256(bytes(sig)));
    }

    /// @notice find an arbitrary storage slot given a function sig, input data, address of the contract and a value to check against
    // slot complexity:
    //  if flat, will be bytes32(uint256(uint));
    //  if map, will be keccak256(abi.encode(key, uint(slot)));
    //  if deep map, will be keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))));
    //  if map struct, will be bytes32(uint256(keccak256(abi.encode(key1, keccak256(abi.encode(key0, uint(slot)))))) + structFieldDepth);
    function find(
        string memory sig, // signature to check agains
        bytes32[] memory ins, // see slot complexity
        address who, // contract
        bytes32 set
    ) public {
        Hevm hevm = Hevm(address(CHEAT_CODE));
        // calldata to test against
        bytes4 fsig = bytes4(keccak256(bytes(sig)));
        bytes memory dat = flatten(ins);
        bytes memory cald = abi.encodePacked(fsig, dat);

        // iterate thru slots
        for (uint256 i = 0; i < 30; i++) {
            bytes32 slot;
            if (ins.length > 0) {
                for (uint256 j = 0; j < ins.length; j++) {
                    if (j != 0) {
                        slot = keccak256(abi.encode(ins[j], slot));
                    } else {
                        slot = keccak256(abi.encode(ins[j], uint(i)));
                    }
                }
            } else {
                // no ins, so should be flat
                slot = bytes32(i);
            }
            // load slot
            bytes32 prev = hevm.load(who, slot);
            // store
            hevm.store(who, slot, set);
            // call
            (bool pass, bytes memory rdat) = who.call(cald);
            bytes32 fdat = bytesToBytes32(rdat, 0);
            // check if good
            if (fdat == set) {
                slots[who][fsig] = i;
                finds[who][fsig] = true;
                break;
            }
            // reset storage
            hevm.store(who, slot, prev);
        }

        require(finds[who][fsig], "!found");
    }

    /// @notice write to an arbitrary slot given a function signature
    function writ(
        string memory sig, // signature to check agains
        bytes32[] memory ins, // see slot complexity
        uint256 depth, // see slot complexity
        address who, // contract
        bytes32 set // value to set storage as
    ) public {
        Hevm hevm = Hevm(address(CHEAT_CODE));

        bytes4 fsig = sigs(sig);

        require(finds[who][fsig], "!found");
        bytes32 slot;
        if (ins.length > 0) {
            for (uint256 j = 0; j < ins.length; j++) {
                if (j != 0) {
                    slot = keccak256(abi.encode(ins[j], slot));
                } else {
                    slot = keccak256(abi.encode(ins[j], slots[who][fsig]));
                }
            }
        } else {
            // no ins, so should be flat
            slot = bytes32(slots[who][fsig]);
        }
        // add depth -- noop if 0
        slot = bytes32(uint256(slot) + depth);
        // set storage
        hevm.store(who, slot, set);
    }

    function write_flat(address who, string memory sig, uint256 value) public {
        bytes32[] memory ins = new bytes32[](0);
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                ins,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            ins,
            0,
            who,
            bytes32(value)
        );
    }

    function write_flat(address who, string memory sig, address value) public {
        bytes32[] memory ins = new bytes32[](0);
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                ins,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            ins,
            0,
            who,
            bytes32(uint256(value))
        );
    }

    function write_map(address who, string memory sig, uint256 key, uint256 value) public {
        bytes32[] memory keys = new bytes32[](1);
        keys[0] = bytes32(uint256(key));
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                keys,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            keys,
            0,
            who,
            bytes32(value)
        );
    }

    function write_map(address who, string memory sig, uint256 key, address value) public {
        bytes32[] memory keys = new bytes32[](1);
        keys[0] = bytes32(uint256(key));
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                keys,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            keys,
            0,
            who,
            bytes32(uint256(value))
        );
    }


    function write_map(address who, string memory sig, address key, uint256 value) public {
        bytes32[] memory keys = new bytes32[](1);
        keys[0] = bytes32(uint256(key));
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                keys,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            keys,
            0,
            who,
            bytes32(value)
        );
    }

    function write_map(address who, string memory sig, address key, address value) public {
        bytes32[] memory keys = new bytes32[](1);
        keys[0] = bytes32(uint256(key));
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                keys,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            keys,
            0,
            who,
            bytes32(uint256(value))
        );
    }

    function write_deep_map(address who, string memory sig, bytes32[] memory keys, uint256 value) public {
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                keys,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            keys,
            0,
            who,
            bytes32(value)
        );
    }

    function write_deep_map(address who, string memory sig, bytes32[] memory keys, address value) public {
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                keys,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            keys,
            0,
            who,
            bytes32(uint256(value))
        );
    }

    function write_deep_map_struct(address who, string memory sig, bytes32[] memory keys, uint256 value, uint256 depth) public {
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                keys,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            keys,
            depth,
            who,
            bytes32(value)
        );
    }

    function write_deep_map_struct(address who, string memory sig, bytes32[] memory keys, address value, uint256 depth) public {
        if (!finds[who][sigs(sig)]) {
            find(
                sig,
                keys,
                who,
                bytes32(uint256(13371337))
            );
        }
        writ(
            sig,
            keys,
            depth,
            who,
            bytes32(uint256(value))
        );
    }

    function bytesToBytes32(bytes memory b, uint offset) private pure returns (bytes32) {
        bytes32 out;

        for (uint i = 0; i < 32; i++) {
            out |= bytes32(b[offset + i] & 0xFF) >> (i * 8);
        }
        return out;
    }

    function flatten(bytes32[] memory b) pure internal returns (bytes memory)
    {
        bytes memory result = new bytes(b.length * 32);
        for (uint256 i = 0; i < b.length; i++) {
            bytes32 k = b[i];
            assembly {
                mstore(add(result, add(32, mul(32, i))), k)
            }
        }

        return result;
    }

}
