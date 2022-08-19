// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.16;

contract RockPaperScissors {
    enum ActionChoices { None, Rock, Paper, Scissors }
    mapping(address => ActionChoices) public usersAction;
    mapping(ActionChoices => address[]) public actionUsers;
    address[] public users;
    uint256 public found;
    address payable owner;
    
    function myChoice(uint256 _choice) public payable{
        uint256 value = msg.value;
        require(value != 0, "Bid something?");
        require(_choice > 0 && _choice <= 3, "Need a choice which is not None(0). Rock(1), Paper(2), Scissors(3)");
        address sender = msg.sender;
        
        ActionChoices choice = ActionChoices(_choice);
        
        require(usersAction[sender] == ActionChoices.None, "You only have one chance.");

        actionUsers[choice].push(sender);
        users.push(sender);
        usersAction[sender] = choice;
        found += value;
    }
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    function judgeAndSettlement() public payable {
        address[] memory toRefound = judge();
        uint256 len = toRefound.length;
        if (len == 0) {
            return;
        }
        uint256 value2Refound = found/len;
        for (uint256 i = 0; i < len; i++) {
            payable(toRefound[i]).transfer(value2Refound);
        }
        owner.transfer(address(this).balance);
        reset();
    }
    
    function reset() internal {
        delete found;
        delete actionUsers[ActionChoices.Rock];
        delete actionUsers[ActionChoices.Paper];
        delete actionUsers[ActionChoices.Scissors];
        for(uint i = 0; i < users.length; i++) {
            delete usersAction[users[i]];
        }
        delete users;
    }
    
    function judge() public view returns (address[] memory winers) {
        uint numberOfRock = actionUsers[ActionChoices.Rock].length;
        uint numberOfPaper = actionUsers[ActionChoices.Paper].length;
        uint numberOfScissors = actionUsers[ActionChoices.Scissors].length;
        if (numberOfRock == 0 && numberOfPaper == 0 && numberOfScissors == 0) {
            address[] memory empty;
            return empty;
        }
        if (numberOfRock != 0 && numberOfPaper != 0 && numberOfScissors != 0) {
            address[] memory empty;
            return empty;
        }
        if (numberOfRock != 0 && numberOfPaper == 0 && numberOfScissors == 0) {
            return actionUsers[ActionChoices.Rock];
        }
        if (numberOfRock == 0 && numberOfPaper != 0 && numberOfScissors == 0) {
            return actionUsers[ActionChoices.Paper];
        }
        if (numberOfRock == 0 && numberOfPaper == 0 && numberOfScissors != 0) {
            return actionUsers[ActionChoices.Scissors];
        }
        if (numberOfRock != 0 && numberOfPaper != 0 && numberOfScissors == 0) {
            return actionUsers[ActionChoices.Paper];
        }
        if (numberOfRock == 0 && numberOfPaper != 0 && numberOfScissors != 0) {
            return actionUsers[ActionChoices.Scissors];
        }
        if (numberOfRock != 0 && numberOfPaper == 0 && numberOfScissors != 0) {
            return actionUsers[ActionChoices.Rock];
        }
    }
}