// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7; 

contract Salary {

    address owner;
    mapping (address=>bool) public isEmployee;
    mapping (address => Employee) employees; 
    address[] public allEmployees;

    address[] interns;
    address[] juniors;
    address[] seniors;

    enum Position {Intern, Junior, Senior}

    struct Employee {
        address empAddress;
        Position empPosition;
        uint salary;
    }

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }
    
    function addEmployee(address payable empAddress, Position _position) public onlyOwner{
        isEmployee[empAddress] = true;

        uint pay;

        if (_position == Position.Intern) {
            interns.push(empAddress);
            pay = 1 ether;
        } 
        else if (_position == Position.Junior) {
            juniors.push(empAddress);
            pay = 2 ether;
        } 
        else if (_position == Position.Senior) {
            seniors.push(empAddress);
            pay = 3 ether;
        }

        Employee memory newEmployee = Employee(empAddress,_position, pay);
        employees[empAddress] = newEmployee;
        allEmployees.push(empAddress);

    }

    function getAllEmployees() public view returns (address[] memory, address[] memory, address[] memory) {
        return (interns, juniors, seniors);
    }


    function payEmployees() public payable onlyOwner{
        for (uint i = 0; i < allEmployees.length; i++) {
            payable(allEmployees[i]).transfer(employees[allEmployees[i]].salary);
        }
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function acceptPayment() public payable {

    }
}
