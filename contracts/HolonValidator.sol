pragma solidity 0.5.11;
import './Holon.sol';

contract HolonValidator is Holon {

    //private fields
    uint _validatorStake;
    address _owner;

    //modifiers
    modifier isOwner {
        require(_owner == msg.sender, "Only owner can access!");
        _;
    }

    modifier hasValidStake {
        require(msg.value >= _validatorStake, "Sent stake less than minimum stake accepted");
        _;
    }

    //constructor
    constructor(address storageSmAddress) public {
        _owner = msg.sender;
        _holonStorage = HolonStorage(storageSmAddress);
    }

    //public functions
    function setStake(uint stake) public isOwner {
        _validatorStake = stake;
    }

    function addValidator(HolonStorage.ValidationCostStrategy strategy, uint price) public payable hasValidStake isPersona {
        _holonStorage.addValidator(strategy, price);
    }
}