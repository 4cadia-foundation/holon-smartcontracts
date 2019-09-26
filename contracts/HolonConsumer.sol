pragma solidity 0.5.11;
import './Holon.sol';

contract HolonConsumer is Holon {
    //modifiers
    modifier isAllowedField(address personaAddress, string memory fieldName) {
        require(_holonStorage.isAllowedField(personaAddress, fieldName), "Field not allowed!");
        _;
    }


    function askPersonaField(address personaAddress,
                             string memory fieldName)
                             public
                             validPersona(personaAddress)
                             fieldExists(personaAddress, fieldName) {
        _holonStorage.askPersonaField(personaAddress, fieldName);
    }

    //linkedin
    function isPersonaFieldAllowed(address personaAddress)
             public
             validPersona(personaAddress)
             returns (bool) {
        //_holonStorage.isPersonaFieldAllowed
    }

    function getPersonaField(address personaAddress,
                             string memory fieldName)
                             public
                             validPersona(personaAddress)
                             isAllowedField(personaAddress, fieldName)
                             fieldExists(personaAddress, fieldName)
                             payable
                             returns (string memory) {
        //apenas 1 vez
        //allowed false
    }
}