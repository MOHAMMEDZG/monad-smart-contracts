// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloMonad {
    string public message = "Hello Monad!";

    function setMessage(string calldata newMessage) public {
        message = newMessage;
    }
}
