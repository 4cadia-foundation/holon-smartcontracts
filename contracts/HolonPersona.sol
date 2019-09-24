pragma solidity 0.5.11;
import './Holon.sol';

contract HolonPersona is Holon {

    //modifiers
    modifier fieldNotExists(string memory fieldName){
        require(!_holonStorage.personaFieldExists(msg.sender, fieldName), "Field already added!");
        _; 
    }

    modifier fieldExists(string memory fieldName){
        require(_holonStorage.personaFieldExists(msg.sender, fieldName), "Field not exists!");
        _; 
    }
    
    //public functions
    function addPersona(string memory name, uint price) public isNotPersona {
        _holonStorage.addPersona(name, price);
    }

    function addPersonaField(string memory fieldName, 
                             string memory fieldData,
                             uint fieldPrice,
                             string memory category,
                             string memory subCategory) 
    public isPersona fieldNotExists(fieldName) {
        _holonStorage.addPersonaField(fieldName, fieldData, fieldPrice, category, subCategory);
    }

    function askToValidate(address validator,
                           string memory field,
                           string memory proofUrl)
    public isPersona fieldExists(field) {
        
    }
}