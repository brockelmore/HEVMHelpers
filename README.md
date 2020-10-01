# HEVM Helpers

This library is intended for use with HEVM from dapphub. It enables writing to arbitrary contract's storage, targeted by a specific function.

Effectively: this allows you to set an arbitrary value like `balanceOf` of any contract, without knowing storage layout. i.e.:
```
 function write_balanceOf(address who, address acct, uint256 value) public {
    write_map(who, "balanceOf(address)", acct, value);
 }
 function write_balanceOfUnderlying(address who, address acct, uint256 value) public {
    write_map(who, "balanceOfUnderlying(address)", acct, value);
 }
 function write_totalSupply(address who, uint256 value) public {
    write_flat(who, "totalSupply()", value);
 }
```

It supports multi-key `mapping` via: ```write_deep_map(address who, string memory sig, bytes32[] memory keys, address value)```. It has some limitations around structs.
