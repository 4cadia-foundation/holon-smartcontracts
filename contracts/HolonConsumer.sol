pragma solidity 0.5.11;
import './Holon.sol';

contract HolonConsumer is Holon {
    
    function askPersonaField(address personaAddress, 
                             string memory fieldName) 
                             validPersona(personaAddress)
                             fieldExists(personaAddress, fieldName)
                             public {
        _holonStorage.askPersonaField(personaAddress, fieldName);
    }

    //linkedin
    function isPersonaFieldAllowed(type name) returns (bool) {
        
    }
    
    function getPersonaField(type name) public payable returns (string) {
        //apenas 1 vez
        //allowed false
    }
}