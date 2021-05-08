

// Currently not working cuz i need to import the correct stuff
contract UniswapExtensions is TokenExtensions {
    // set the uniswap price relative to another
    // function set_two_hop_uni_price(
    //     address main_uni_pair,
    //     address secondary_uni_pair,
    //     address who,
    //     uint256 quote_price
    // )
    //     public
    // {
    //     UniswapPair secondary_pair = UniswapPair(secondary_uni_pair);
    //     UniswapPair pair = UniswapPair(main_uni_pair);
    //     (uint256 token0Reserves2, uint256 token1Reserves2, ) = secondary_pair.getReserves();

    //     address token02 = secondary_pair.token0();
    //     address token12 = secondary_pair.token1();

    //     if (token02 == pair.token0() || token02 == pair.token1()) {
    //         // get quote in terms of token02
    //         uint256 quote = uniRouter.quote(
    //             10**ExpandedERC20(token02).decimals(),
    //             token0Reserves2,
    //             token1Reserves2
    //         );
    //         // get inverse
    //         quote = quote_price.mul(10**ExpandedERC20(token12).decimals()).div(quote);
    //         set_uni_price(main_uni_pair, who, quote);
    //     } else if (token12 == pair.token0() || token12 == pair.token1()) {
    //         // get quote in terms of token12
    //         uint256 quote = uniRouter.quote(
    //             10**ExpandedERC20(token12).decimals(),
    //             token1Reserves2,
    //             token0Reserves2
    //         );
    //         // get inverse
    //         quote = quote_price.mul(10**ExpandedERC20(token02).decimals()).div(quote);
    //         set_uni_price(main_uni_pair, who, quote);
    //     } else {
    //         require( false, "!pair_two_hop");
    //     }
    // }

    // // set the current uniswap price of a pair
    // function set_uni_price(
    //     address uni_pair,
    //     address who,
    //     uint256 quote_price
    // )
    //     public
    // {
    //     // adjusts the price by minimally changing token balances in uniswap pair
    //     UniswapPair pair = UniswapPair(uni_pair);
    //     (uint256 token0Reserves, uint256 token1Reserves, ) = pair.getReserves();
    //     uint256 quote;
    //     if ( pair.token0() == who ) {
    //         quote = uniRouter.quote(10**ExpandedERC20(who).decimals(), token0Reserves, token1Reserves);
    //     } else if ( pair.token1() == who ) {
    //         quote = uniRouter.quote(10**ExpandedERC20(who).decimals(), token1Reserves, token0Reserves);
    //     } else {
    //         require( false, "!pair" );
    //     }

    //     /* assertEq(quote, quote_price); */
    //     uint256 offPerc;
    //     if (quote > quote_price) {
    //         // price too high, increase reserves by off %
    //         offPerc = quote.sub(quote_price).mul(BASE).div(quote_price);
    //         /* assertEq(offPerc, 440); */
    //         uint256 new_bal = IERC20(who).balanceOf(uni_pair).mul(BASE.add(offPerc)).div(BASE);
    //         yamhelper.write_balanceOf(who, uni_pair, new_bal);
    //         pair.sync();
    //     } else {
    //         // price too low, decrease reserves by off %
    //         offPerc = quote_price.sub(quote).mul(BASE).div(quote_price);
    //         /* assertEq(offPerc, 441); */
    //         uint256 new_bal = IERC20(who).balanceOf(uni_pair).mul(BASE.sub(offPerc)).div(BASE);
    //         yamhelper.write_balanceOf(who, uni_pair, new_bal);
    //         pair.sync();
    //     }
    // }


    // function increase_liquidity(address uni_pair, uint256 scale) public {
    //     UniswapPair pair = UniswapPair(uni_pair);
    //     (uint256 token0Reserves, uint256 token1Reserves, ) = pair.getReserves();
    //     if (pair.token0() == WETH) {
    //         yamhelper.write_map(pair.token0(), "balanceOf(address)", uni_pair, token0Reserves * scale);
    //     } else {
    //         yamhelper.write_balanceOf(pair.token0(), uni_pair, token0Reserves * scale);
    //     }
    //     if (pair.token1() == WETH) {
    //         yamhelper.write_map(pair.token1(), "balanceOf(address)", uni_pair, token1Reserves * scale);
    //     } else {
    //         yamhelper.write_balanceOf(pair.token1(), uni_pair, token1Reserves * scale);
    //     }
    //     pair.sync();
    // }
}