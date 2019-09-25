pragma solidity 0.5.11;

contract HolonStorage {

    //enums
    enum ValidationCostStrategy { 
        ForFree, 
        Charged, 
        Rebate 
    }

    enum ValidationStatus { 
        PendingValidation,
        Validated, 
        NotValidated, 
        CannotEvaluate
    }

    //structs
    struct FieldInfo {
        string data;
        uint price;
        string category;
        string subCategory;
        bool exists;
        ValidationStatus lastStatus;
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

    struct PendingValidation {
        address personaAddress;
        string field;
        string proofUrl;
    }

    //mappings
    mapping (address => Persona) _personas;
    mapping (address => Validator)  _validators;
    mapping (address => PendingValidation[]) _validatorPendingValidation;

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
        FieldInfo memory nameField = FieldInfo(name, price, "Plain text", "Personal info", true, ValidationStatus.NotValidated);
        Persona storage newPersona = _personas[msg.sender];
        newPersona.fieldInfo["name"] = nameField;
    }

    function addPersonaField(string memory fieldName, 
                             string memory fieldData,
                             uint fieldPrice,
                             string memory category,
                             string memory subCategory) public {
        Persona storage persona = _personas[msg.sender];
        persona.fieldInfo[fieldName] = FieldInfo(fieldData, fieldPrice, category, subCategory, true, ValidationStatus.NotValidated);                                    
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
        _validatorPendingValidation[validator].push(PendingValidation(msg.sender, field, proofUrl));                               
    }
}