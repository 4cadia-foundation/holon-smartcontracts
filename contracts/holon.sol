pragma solidity 0.5.11;

contract HolonStorage {

    //enums
    enum ValidationChoices { Validated, NotValidated, CannotEvaluate, NewData, ValidationPending }
    enum ValidationCostStrategy { ForFree, Charged, Rebate }

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
        address payable validatorAddress;
        ValidationCostStrategy strategy;
        uint price;
        bool exists;
    }

    struct Stamp {
        address validatorAddress;
        ValidationChoices status;
        uint whenDate;
        uint whenBlock;
    }

    //mappings
    mapping (address => Persona) _personas;
    mapping(address => Validator) public _validators;
    address[] public validatorsList;

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

    function addValidator(HolonStorage.ValidationCostStrategy _strategy, uint _price) public payable returns (bool) {
        _validators[msg.sender] = Validator(msg.sender, _strategy, _price, true);
        validatorsList.push(msg.sender);
        return true;
    }

}


contract HolonPersona {

    //private fields
    HolonStorage _holonStorage;

    //modifiers
    modifier isNotPersona {
        require(!_holonStorage.isPersona(msg.sender), "Persona already added!");
        _;
    }
    
    modifier isPersona {
        require(_holonStorage.isPersona(msg.sender), "Persona not exists!");
        _; 
    }

    modifier fieldNotExists(string memory fieldName){
        require(!_holonStorage.personaFieldExists(msg.sender, fieldName), "Field already added!");
        _; 
    }

    modifier fieldExists(string memory fieldName){
        require(_holonStorage.personaFieldExists(msg.sender, fieldName), "Field not exists!");
        _; 
    }
    
    //constructor
    constructor(address storageSmAddress) public {
        _holonStorage = HolonStorage(storageSmAddress);
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


contract HolonValidator {

    //private fields
    uint _validatorStake;
    HolonStorage _holonStorage;
    address _owner;

    //modifiers
    modifier isOwner {
        require(_owner != msg.sender, "Only owner can access!");
        _;
    }

    modifier isNotValidator {
        require(!_holonStorage.isValidator(msg.sender), "Validator already exist!");
        _;
    }

    modifier wasPaid {
        require(msg.value >= _validatorStake, "You have to pay wei to become a validator");
        _;
    }

    modifier isPersona {
        require(_holonStorage.isPersona(msg.sender), "You must be a persona within Holon to become a validator");
        _;
    }

    constructor(address storageSmAddress) public {
        _owner = msg.sender;
        _holonStorage = HolonStorage(storageSmAddress);
    }

    //public functions
    function setStake(uint _stake) public isOwner {
        _validatorStake = _stake;
    }

    function addValidator(HolonStorage.ValidationCostStrategy strategy, uint price) public payable wasPaid isPersona {
        _holonStorage.addValidator(strategy, price);
    }

}