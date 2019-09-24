pragma solidity 0.5.11;
import './HolonStorage.sol';

contract Holon {
    
    //property
    HolonStorage public _holonStorage;
    address public _owner;

    //constructor
    constructor(address storageSmAddress) public {
        _holonStorage = HolonStorage(storageSmAddress);
        _owner == msg.sender;
    }

    //modifiers
    modifier isPersona {
        require(_holonStorage.isPersona(msg.sender), "Persona not exists!");
        _; 
    }

    modifier isNotPersona {
        require(!_holonStorage.isPersona(msg.sender), "Persona already added!");
        _;
    }

    modifier isNotValidator {
        require(!_holonStorage.isValidator(msg.sender), "Validator already exists!");
        _;
    }
    
    modifier isValidator(address validatorAddress) {
        require(_holonStorage.isValidator(validatorAddress), "Validator not exists!");
        _;
    }

    modifier isOwner {
        require(_owner == msg.sender, "Only owner can access!");
        _;
    }
}