pragma solidity 0.5.11;
import './HolonStorage.sol';

contract Holon {

    //property
    HolonStorage public _holonStorage;
    address public _owner;

    //constructor
    constructor() public {
        _owner == msg.sender;
    }

    //modifiers
    modifier isPersona {
        require(_holonStorage.isPersona(msg.sender), "Persona not exists!");
        _;
    }

    modifier validPersona(address personaAddress) {
        require(_holonStorage.isPersona(personaAddress), "Persona not exists!");
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

    modifier isValidator {
        require(_holonStorage.isValidator(msg.sender), "Validator not exists!");
        _;
    }

    modifier validValidator(address validatorAddress) {
        require(_holonStorage.isValidator(validatorAddress), "Validator not exists!");
        _;
    }

    modifier isOwner {
        require(_owner == msg.sender, "Only owner can access!");
        _;
    }

    modifier fieldExists(address persona, string memory fieldName) {
        require(_holonStorage.personaFieldExists(persona, fieldName), "Field not exists!");
        _;
    }

    function BuildHolonStorage(address storageSmAddress) public {
        //todo: ver um jeito melhor se possivel
        _holonStorage = HolonStorage(storageSmAddress);
    }
}