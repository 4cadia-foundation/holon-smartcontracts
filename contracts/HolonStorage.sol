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
        address payable personaAddress;
        bool exists;
        mapping(string => FieldInfo) fieldInfo;
    }

    struct Validator {
        ValidationCostStrategy strategy;
        uint price;
        bool exists;
    }

    struct Stamp {
        address validatorAddress;
        ValidationStatus status;
        uint date;
        uint blockNumber;
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

    function validate(address _persona, string memory _field, ValidationStatus _status) public payable returns (bool) {
        HolonStorage.Validator storage validator = HolonStorage._validators[msg.sender];
        HolonStorage.Persona storage persona = HolonStorage._personas[_persona];
        HolonStorage.FieldInfo storage info = persona.fieldInfo[_field];
        // if (v.strategy == ValidationCostStrategy.Rebate) {
        //     require(msg.value >= i.price, "You must send a correct value");
        // } DON'T REMOVE!!!
        info.lastStatus = _status;
        HolonStorage.Stamp memory validateStamp = HolonStorage.Stamp(msg.sender, _status, block.timestamp, block.number);
        info.validations.push(validateStamp);
        if (_status == HolonStorage.ValidationChoices.CannotEvaluate) {
            return true;
        }
        if (validator.strategy == HolonStorage.Rebate) {
            _persona.transfer(msg.value);
        }
        return true;
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