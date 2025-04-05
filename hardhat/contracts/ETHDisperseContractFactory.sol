// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./ETHDisperseContract.sol";

/**
 * A simple contract factory that creates instances of MyContract.
 * Under the hood, this will use the create and create2 functions on the ContractDeployer system contract.
 * 
 * When you call create or create2 like the functions below, the zksolc compiler automatically 
 *  detects that the contract is capable of creating instances of MyContract.
 * 
 * Therefore, when you compile using zksolc, the factoryDeps field includes a reference to MyContract.
 *  See the "factoryDeps" field in the /artifacts-zk/contracts/ETHDisperseContractFactory.json file after compiling.
 */
contract ETHDisperseContractFactory {
    event MyContractCreated(address myContractAddress);

    // create
    function createMyContract() public {
        Disperse myContract = new Disperse();
        emit MyContractCreated(address(myContract));
    }

    // create2 - deterministic address
    function create2MyContract(bytes32 salt) public {
        Disperse myContract = new Disperse{salt: salt}();
        emit MyContractCreated(address(myContract));
    }

    // create (using assembly)
    function createMyContractAssembly() public {
        bytes memory bytecode = type(Disperse).creationCode;
        address myContract;
        assembly {
            myContract := create(0, add(bytecode, 32), mload(bytecode))
        }

        emit MyContractCreated(address(myContract));
    }

    // create2 (using assembly)
//     function create2MyContractAssembly(bytes32 salt) public {
//         bytes memory bytecode = type(Disperse).creationCode;
//         address myContract;
//         assembly {
//             myContract := create2(0, add(bytecode, 32), mload(bytecode), salt)
//         }

//         emit MyContractCreated(address(myContract));
//     }
}