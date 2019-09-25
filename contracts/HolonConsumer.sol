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
                             validPersona(personaAddress)
                             fieldExists(personaAddress, fieldName)
                             public {
        _holonStorage.askPersonaField(personaAddress, fieldName);
    }

    //linkedin
    function isPersonaFieldAllowed(address personaAddress)
             validPersona(personaAddress)
             public 
             returns (bool) {

        //_holonStorage.isPersonaFieldAllowed
    }
    
    function getPersonaField(address personaAddress,
                             string memory fieldName)
                             validPersona(personaAddress)
                             isAllowedField(personaAddress, fieldName)
                             fieldExists(personaAddress, fieldName)
                             public payable 
                             returns (string) {
        //apenas 1 vez
        //allowed false
    }
}