pragma solidity 0.5.11;
import './Holon.sol';

contract HolonConsumer is Holon {
    //modifiers
    modifier isAllowedField(address personaAddress, string memory fieldName) {
        require(_holonStorage.isAllowedField(msg.sender, personaAddress, fieldName), "Field not allowed!");
        _;
    }

    //constructor
    constructor(address storageSmAddress) public {
        BuildHolonStorage(storageSmAddress);
    }

    function askPersonaField(address personaAddress,
                             string memory fieldName)
                             public
                             validPersona(personaAddress)
                             fieldExists(personaAddress, fieldName) {
        _holonStorage.askPersonaField(msg.sender, personaAddress, fieldName);
    }

    function isPersonaFieldAllowed(address personaAddress,
                                   string memory fieldName)
                                   public view
                                   validPersona(personaAddress)
                                   fieldExists(personaAddress, fieldName)
                                   returns (bool) {
        return _holonStorage.isAllowedField(msg.sender, personaAddress, fieldName);
    }

    function getPersonaField(address personaAddress,
                             string memory fieldName)
                             public
                             validPersona(personaAddress)
                             isAllowedField(personaAddress, fieldName)
                             fieldExists(personaAddress, fieldName)
                             payable
                             returns (string memory) {
        uint fieldPrice = _holonStorage.getPersonaFieldPrice(personaAddress, fieldName);
        if(fieldPrice > 0) {
            require(msg.value >= fieldPrice, "Invalid persona payment price!");
            address payable payablePersona = address(uint160(personaAddress));
            payablePersona.transfer(msg.value);
        }
        return _holonStorage.getPersonaField(msg.sender, personaAddress, fieldName);
    }
}