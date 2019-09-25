pragma solidity 0.5.11;
import './Holon.sol';

contract HolonConsumer is Holon {
    
    function askPersonaField(address personaAddress, 
                             string memory fieldName) 
                             validPersona(personaAddress)
                             fieldExists(personaAddress, fieldName) {
        

    }
}