// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PeerToPeerLending {
    struct Loan {
        address lender;
        address borrower;
        uint amount;
        uint interest;
        uint dueDate;
        bool repaid;
    }

    uint public loanIdCounter;
    mapping(uint => Loan) public loans;

    event LoanIssued(uint loanId, address indexed lender, address indexed borrower, uint amount, uint dueDate);
    event LoanRepaid(uint loanId, address indexed borrower);

    function issueLoan(address _borrower, uint _amount, uint _interest, uint _dueDate) public payable {
        require(msg.value == _amount, "Incorrect loan amount");
        
        loans[loanIdCounter] = Loan({
            lender: msg.sender,
            borrower: _borrower,
            amount: _amount,
            interest: _interest,
            dueDate: _dueDate,
            repaid: false
        });

        payable(_borrower).transfer(_amount);
        emit LoanIssued(loanIdCounter, msg.sender, _borrower, _amount, _dueDate);
        loanIdCounter++;
    }

    function repayLoan(uint _loanId) public payable {
        Loan storage loan = loans[_loanId];
        require(msg.sender == loan.borrower, "Only borrower can repay");
        require(!loan.repaid, "Loan already repaid");
        require(msg.value == loan.amount + loan.interest, "Incorrect repayment amount");

        payable(loan.lender).transfer(msg.value);
        loan.repaid = true;
        emit LoanRepaid(_loanId, msg.sender);
    }
}
