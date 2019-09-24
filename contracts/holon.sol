pragma solidity 0.5.11;
import './HolonStorage.sol';

contract Holon {
    
    //property
    HolonStorage public _holonStorage;

    //constructor
    constructor(address storageSmAddress) public {
        _holonStorage = HolonStorage(storageSmAddress);
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
}