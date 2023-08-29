// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MasterEscrow {
    enum State { Created, Locked, Released, Inactive }

    struct Transaction {
        State state;
        address payable buyer;
        address payable seller;
        uint256 price;
        string name;
    }

    mapping(uint256 => Transaction) public transactions;

    event TransactionCreated(uint256 txId);
    event TransactionLocked(uint256 txId);
    event TransactionReleased(uint256 txId);
    event TransactionCancelled(uint256 txId);

    function createTransaction(uint256 txId, address payable _buyer, uint256 _price, string memory _name) public {
        transactions[txId] = Transaction({
            state: State.Created,
            buyer: _buyer,
            seller: payable(msg.sender),
            price: _price,
            name: _name
        });
        emit TransactionCreated(txId);
    }

    function confirmPurchase(uint256 txId) public payable {
        Transaction storage tx = transactions[txId];
        require(tx.state == State.Created, "Invalid state");
        require(msg.value == tx.price, "Invalid amount sent");
        require(msg.sender == tx.buyer, "Only the buyer can confirm");

        tx.state = State.Locked;
        emit TransactionLocked(txId);
    }

    function confirmReceived(uint256 txId) public {
        Transaction storage tx = transactions[txId];
        require(tx.state == State.Locked, "Invalid state");
        require(msg.sender == tx.buyer, "Only the buyer can confirm");

        tx.state = State.Released;
        tx.seller.transfer(tx.price);
        emit TransactionReleased(txId);
    }

    function cancelTransaction(uint256 txId) public {
        Transaction storage tx = transactions[txId];
        require(msg.sender == tx.seller || msg.sender == tx.buyer, "Only the buyer or seller can cancel");
        require(tx.state == State.Created, "Cannot cancel at this stage");

        tx.state = State.Inactive;
        if (msg.sender == tx.buyer) {
            payable(tx.buyer).transfer(tx.price);  // Refund the buyer
        }
        emit TransactionCancelled(txId);
    }

    function getTransactionName(uint256 txId) public view returns (string memory) {
        return transactions[txId].name;
    }
}
