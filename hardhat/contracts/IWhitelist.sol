// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// How is the Whitelist contract imported?
interface IWhitelist {
    function whitelistedAddresses(address) external view returns (bool);
}
