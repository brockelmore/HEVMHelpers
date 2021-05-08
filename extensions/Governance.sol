import "../HEVMState.sol";
import "./Tokens.sol";

interface IGovernorAlpha {
	enum ProposalState {
	    Pending,
	    Active,
	    Canceled,
	    Defeated,
	    Succeeded,
	    Queued,
	    Expired,
	    Executed
	}
  function BALLOT_TYPEHASH (  ) external view returns ( bytes32 );
  function DOMAIN_TYPEHASH (  ) external view returns ( bytes32 );
  function __abdicate (  ) external;
  function __acceptAdmin (  ) external;
  function __executeSetTimelockPendingAdmin ( address newPendingAdmin, uint256 eta ) external;
  function __queueSetTimelockPendingAdmin ( address newPendingAdmin, uint256 eta ) external;
  function cancel ( uint256 proposalId ) external;
  function castVote ( uint256 proposalId, bool support ) external;
  function castVoteBySig ( uint256 proposalId, bool support, uint8 v, bytes32 r, bytes32 s ) external;
  function comp (  ) external view returns ( address );
  function execute ( uint256 proposalId ) external payable;
  function getActions ( uint256 proposalId ) external view returns ( address[] memory targets, uint256[] memory values, string[] memory signatures, bytes[] memory calldatas );
  function getReceipt ( uint256 proposalId, address voter ) external view returns ( tuple );
  function guardian (  ) external view returns ( address );
  function latestProposalIds ( address ) external view returns ( uint256 );
  function name (  ) external view returns ( string memory );
  function proposalCount (  ) external view returns ( uint256 );
  function proposalMaxOperations (  ) external pure returns ( uint256 );
  function proposalThreshold (  ) external pure returns ( uint256 );
  function proposals ( uint256 ) external view returns ( uint256 id, address proposer, uint256 eta, uint256 startBlock, uint256 endBlock, uint256 forVotes, uint256 againstVotes, bool canceled, bool executed );
  function propose ( address[] calldata targets, uint256[] calldata values, string[] calldata signatures, bytes[] calldata calldatas, string calldata description ) external returns ( uint256 );
  function queue ( uint256 proposalId ) external;
  function quorumVotes (  ) external pure returns ( uint256 );
  function state ( uint256 proposalId ) external view returns ( uint8 );
  function timelock (  ) external view returns ( address );
  function votingDelay (  ) external pure returns ( uint256 );
  function votingPeriod (  ) external pure returns ( uint256 );
}


interface CompLike {
  function DELEGATION_TYPEHASH (  ) external view returns ( bytes32 );
  function DOMAIN_TYPEHASH (  ) external view returns ( bytes32 );
  function allowance ( address account, address spender ) external view returns ( uint256 );
  function approve ( address spender, uint256 rawAmount ) external returns ( bool );
  function balanceOf ( address account ) external view returns ( uint256 );
  function checkpoints ( address, uint32 ) external view returns ( uint32 fromBlock, uint96 votes );
  function decimals (  ) external view returns ( uint8 );
  function delegate ( address delegatee ) external;
  function delegateBySig ( address delegatee, uint256 nonce, uint256 expiry, uint8 v, bytes32 r, bytes32 s ) external;
  function delegates ( address ) external view returns ( address );
  function getCurrentVotes ( address account ) external view returns ( uint96 );
  function getPriorVotes ( address account, uint256 blockNumber ) external view returns ( uint96 );
  function name (  ) external view returns ( string memory );
  function nonces ( address ) external view returns ( uint256 );
  function numCheckpoints ( address ) external view returns ( uint32 );
  function symbol (  ) external view returns ( string memory );
  function totalSupply (  ) external view returns ( uint256 );
  function transfer ( address dst, uint256 rawAmount ) external returns ( bool );
  function transferFrom ( address src, address dst, uint256 rawAmount ) external returns ( bool );
}

interface Governed {
	function gov() external returns (address);
}


interface Timelock {
  function executeTransaction ( address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta ) external payable returns ( bytes );
  function acceptAdmin (  ) external;
  function pendingAdmin (  ) external view returns ( address );
  function queueTransaction ( address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta ) external returns ( bytes32 );
  function setPendingAdmin ( address pendingAdmin_ ) external;
  function cancelTransaction ( address target, uint256 value, string calldata signature, bytes calldata data, uint256 eta ) external;
  function delay (  ) external view returns ( uint256 );
  function MAXIMUM_DELAY (  ) external view returns ( uint256 );
  function MINIMUM_DELAY (  ) external view returns ( uint256 );
  function GRACE_PERIOD (  ) external view returns ( uint256 );
  function setDelay ( uint256 delay_ ) external;
  function queuedTransactions ( bytes32 ) external view returns ( bool );
  function admin (  ) external view returns ( address );
}


// Example usage
// https://github.com/yam-finance/yamV3/blob/master/contracts/tests/proposal_round_13/proposal.t.sol
//
//
// function test_onchain_prop_13() public {
//     // assertTrue(false); // force verbose from $ dapp test --rpc-url "https://<nodeUrl>" -v --match test_onchain_prop_13
//     address[] memory targets = new address[](4);
//     uint256[] memory values = new uint256[](4);
//     string[] memory signatures = new string[](4);
//     bytes[] memory calldatas = new bytes[](4);

//     string memory description =
//         "Approve StreamManager for VestingPool, approve StreamManager for MonthlyAllowance, transfer UMA to umaDistributor, send YAM to yamDistributor";

//     targets[0] = address(vestingPool);
//     values[0] = 0;
//     signatures[0] = "setSubGov(address,bool)";
//     calldatas[0] = abi.encode(streamManager, true);

//     targets[1] = address(monthlyAllowance);
//     values[1] = 0;
//     signatures[1] = "setIsSubGov(address,bool)";
//     calldatas[1] = abi.encode(streamManager, true);

//     targets[2] = address(reserves);
//     values[2] = 0;
//     signatures[2] = "oneTimeTransfers(address[],uint256[],address[])";
//     address[] memory umaWhos = new address[](1);
//     umaWhos[0] = address(umaDistributor);
//     uint256[] memory umaAmounts = new uint256[](1);
//     umaAmounts[0] = 29673727930140068584843;
//     address[] memory umaTokens = new address[](1);
//     umaTokens[0] = 0x04Fa0d235C4abf4BcF4787aF4CF447DE572eF828;
//     calldatas[2] = abi.encode(umaWhos, umaAmounts, umaTokens);

//     targets[3] = address(yamV3);
//     values[3] = 0;
//     signatures[3] = "mint(address,uint256)";
//     calldatas[3] = abi.encode(address(yamDistributor), 36102006063173137830825);
//
//	   // get quorum
//     getQuorumBalance(yamV3, me); <<<<<<<<<<<<<<<<< library usage
//     bing(); <<<<<<<<<<<<<<<<<<<<

//     // roll the proposal thru governance
//     roll_prop(governor, targets, values, signatures, calldatas, description); <<<<<<<<<

//	   // check output
//     uint256 remainingGas1 = gasleft();
//     streamManager.execute();
//     emit GAS_USAGE(remainingGas1 - gasleft());
//     remainingGas1 = gasleft();
//     umaDistributor.execute();
//     emit GAS_USAGE(remainingGas1 - gasleft());
//     remainingGas1 = gasleft();
//     yamDistributor.execute();
//     emit GAS_USAGE(remainingGas1 - gasleft());
// }
//
//
//

contract GovernanceExtensions is HEVMHelpers, TokenExtensions {
	function getProposalBalance(address governorAlpha, address govToken, address account) public {
		uint256 threshold = IGovernorAlpha(governorAlpha).proposalThreshold();
        write_balanceOf(govToken, account, threshold);
    }

	function getQuorumBalance(address governorAlpha, address govToken, address account) public {
		uint256 quorumVotes = IGovernorAlpha(governorAlpha).quorumVotes();
        write_balanceOf(govToken, account, quorumVotes);
    }

    function becomePendingGov(address who, address account) public {
		write_flat(who, "pendingGov()", account);
    }

    function becomeGov(address who, address account) public {
		write_flat(who, "gov()", account);
    }

    function becomeAdmin(address who, address account) public {
		write_flat(who, "admin()", account);
    }

    // Vote for the latest proposal, rolls block forward 10 blocks to ensure votable if too soon
    function vote_pos_latest(address governor) public {
        hevm.roll(block.number + 10);
        YamGovernorAlpha curr_gov = IGovernorAlpha(timelock.admin());
        uint256 id = curr_gov.latestProposalIds(me);
        curr_gov.castVote(id, true);
    }

    // Vote for the latest proposal submitted in the test given a timelock address
    function vote_pos_latest_timelock(address timelock) public {
        hevm.roll(block.number + 10);
        IGovernorAlpha curr_gov = IGovernorAlpha(Timelock(timelock).admin());
        uint256 id = curr_gov.latestProposalIds(me);
        curr_gov.castVote(id, true);
    }

    function timelock_accept_gov(address govtoken, address governor, address accepting_gov) public {
    	getQuorumBalance(governor, govToken, address(this));
        address[] memory targets = new address[](1);
        targets[0] = accepting_gov;
        uint256[] memory values = new uint256[](1);
        values[0] = 0; // dont send eth
        string[] memory signatures = new string[](1);
        signatures[0] = "_acceptGov()"; //function to call
        bytes[] memory calldatas = new bytes[](1);
        calldatas[0] = "";
        string memory description = "timelock accept gov";
        roll_prop(
          	governor,
          	timelock
			targets,
			values,
			signatures,
			calldatas,
			description
        );
    }

    function roll_prop(
    	address gov,
        address[] memory targets,
        uint256[] memory values,
        string[] memory signatures,
        bytes[] memory calldatas,
        string memory description
    )
        public
    {
        IGovernorAlpha gov = IGovernorAlpha(gov);
        gov.propose(
            targets,
            values,
            signatures,
            calldatas,
            description
        );

        uint256 id = gov.latestProposalIds(me);

        vote_pos_latest(address(gov));

        uint256 votingPeriod = gov.votingPeriod();
        hevm.roll(block.number +  votingPeriod + 1);

        IGovernorAlpha.ProposalState state = IGovernorAlpha.ProposalState(gov.state(id));
        assertTrue(state == IGovernorAlpha.ProposalState.Succeeded);

        // queue
        gov.queue(id);

        // fast forward the timelock delay
        hevm.warp(now + gov.timelock().delay());

        // execute
        gov.execute(id);
    }


    // atomically become the governor of an address to execute a function then return to the original owner
    function atomicGovCore(address has_gov, string[] memory sigs, bytes32[][] memory ins) public {
        // become the 
        address prevGov = Governed(address(uint160(has_gov))).gov();

        becomeGov(has_gov, address(this));
        Governed(address(uint160(has_gov)))._acceptGov();

        for (uint256 i = 0; i < sigs.length; i++) {
            bytes4 fsig = bytes4(keccak256(bytes(sigs[i])));
            bytes memory dat = flatten(ins[i]);
            bytes memory cald = abi.encodePacked(fsig, dat);
            (bool success, bytes memory rdat) = has_gov.call(cald);
            success; rdat; // ssh
        }

        becomeGov(has_gov, prevGov);
    }

    // atomically call a function as a contract's governor
    function atomicGov(address has_gov, string memory sig, address acct) public {
        bytes32[][] memory ins = new bytes32[][](1);
        ins[0] = new bytes32[](1);
        ins[0][0] = bytes32(uint256(acct));
        string[] memory sigs = new string[](1);
        sigs[0] = sig;
        atomicGovCore(has_gov, sigs, ins);
    }

    // atomically call a function as a contract's governor
    function atomicGov(address has_gov, string memory sig, uint val) public {
        bytes32[][] memory ins = new bytes32[][](1);
        ins[0] = new bytes32[](1);
        ins[0][0] = bytes32(val);
        string[] memory sigs = new string[](1);
        sigs[0] = sig;
        atomicGovCore(has_gov, sigs, ins);
    }
}