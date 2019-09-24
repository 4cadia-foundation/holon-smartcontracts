pragma solidity 0.5.11;

contract HolonStorage {

    //enums
    enum ValidationCostStrategy { 
        ForFree, 
        Charged, 
        Rebate 
    }

    //structs
    struct FieldInfo {
        string data;
        uint price;
        string category;
        string subCategory;
        bool exists;
    }

    struct Persona {
        bool exists;
        mapping(string => FieldInfo) fieldInfo;
    }

    struct Validator {
        ValidationCostStrategy strategy;
        uint price;
        bool exists;
    }

    //mappings
    mapping (address => Persona) public _personas;
    mapping(address => Validator) public _validators;

    //public functions
    function isPersona(address personaAddress) public view returns (bool) {
        Persona storage persona = _personas[personaAddress];
        return persona.exists;
    }

    function personaFieldExists(address personaAddress, string memory fieldName) public view returns (bool) {
        Persona storage persona = _personas[personaAddress];
        return persona.fieldInfo[fieldName].exists;
    }

    function isValidator(address validatorAddress) public view returns (bool) {
        Validator storage validator = _validators[validatorAddress];
        return validator.exists;
    }

    function addPersona(string memory name, uint price) public {
        FieldInfo memory nameField = FieldInfo(name, price, "Plain text", "Personal info", true);
        Persona storage newPersona = _personas[msg.sender];
        newPersona.fieldInfo["name"] = nameField;
    }

    function addPersonaField(string memory fieldName, 
                             string memory fieldData,
                             uint fieldPrice,
                             string memory category,
                             string memory subCategory) public {
        Persona storage persona = _personas[msg.sender];
        persona.fieldInfo[fieldName] = FieldInfo(fieldData, fieldPrice, category, subCategory, true);                                    
    }

    function addValidator(ValidationCostStrategy _strategy, uint _price) public {
        _validators[msg.sender] = Validator(_strategy, _price, true);
    }

    function getValidatorPrice(address validatorAddress) public view returns (uint) {
         Validator storage validator = _validators[validatorAddress];
         return validator.price;
    }
    
    function getValidatorCostStrategy(address validatorAddress) public view returns (ValidationCostStrategy) {
         Validator storage validator = _validators[validatorAddress];
         return validator.strategy;
    }
    
    function askToValidate(address validator,
                           string memory field,
                           string memory proofUrl) public {


    }
}