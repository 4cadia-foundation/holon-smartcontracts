pragma solidity 0.5.10;
pragma experimental ABIEncoderV2;

contract Repository {

    // Validator
    struct Validator {
        address payable validatorAddress;
        uint reputation;
        ValidationCostStrategy strategy;
        uint price;
        bool exists;
    }

    // Data's Validations 
    struct Stamp {
        address validatorAddress;
        ValidationChoices status;
        uint whenDate;
        uint whenBlock;
    }

    // Persona's Data / Info
    struct Info {
        uint infoCategoryCode;
        string field;
        string data;
        uint price;
        bool exists;
        Stamp[] validations;
        ValidationChoices lastStatus;
        mapping(address => Validator) validators;
    }

    // Persona
    struct Persona {
        address payable personalAddress;
        bool exists;
        mapping(string => Info) personaInfo;
        string[] fields;        
    }

    // Enums
    enum ValidationCostStrategy { ForFree, Charged, Rebate }
    enum ValidationChoices { Validated, NotValidated, CannotEvaluate, NewData, ValidationPending }

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Owner account is required");
        _;
    }   
    modifier priceCorrect() {
        require(_price >= 0, "You must inform correct value");
        _;
    }
    modifier personaRegistered() {
        require(p.exists, "This persona is not registered");
        _;
    }    
    modifier fieldNotExist() {
        require(!i.exists, "This field is already registered");
        _;
    }  
    modifier minimumStake() {
        require(msg.value >= 1 ether, "You have to pay 1 ether to become a validator");
        _;
    }  
    // Functions
function addPersona(uint _infoCategoryCode, string memory _field, string memory _data, uint _price) 
        public 
        priceCorrect
        returns (bool)
    {
         Persona storage p = members[msg.sender];
        p.personalAddress = msg.sender;
        p.exists = true;
        p.fields.push(_field);
        
        Info storage i = p.personalInfo[_field];
        i.infoCategoryCode = _infoCategoryCode;
        i.field = _field;
        i.data = _data;
        i.price = _price;
        i.exists = true;
        i.lastStatus = ValidationChoices.NewData;
        return true;
    }    

   function addData(uint _infoCategoryCode, string memory _field, string memory _data, uint _price) 
        public
        priceCorrect
        personaRegistered,
        fieldNotExist
        returns (bool)
    {
        Persona storage p = members[msg.sender];
        Info storage i = p.personalInfo[_field];
        i.infoCategoryCode = _infoCategoryCode;
        i.field = _field;
        i.dataCategory = _dataCategory;
        i.data = _data;
        i.price = _price;
        i.exists = true;
        i.lastStatus = ValidationChoices.NewData;
        p.fields.push(_field);
        return true;
    }

    function addValidator(ValidationCostStrategy _strategy, uint _price) 
        public
        payable
        personaRegistered 
        minimumStake
        returns (bool)
    {
        Persona memory p = members[msg.sender];
        holonValidators[msg.sender] = Validator(msg.sender, 0, _strategy, _price, true);
        holonValidatorsList.push(msg.sender);
        return true;
    }

    function getPersonaData(address _address, string memory _field)
        public
        view
        returns (string memory, string memory, DataCategory, uint, uint, uint)
    {
        Persona storage p = members[_address];
        Info memory i = p.personalInfo[_field];
        return (i.field, i.data, i.infoCategoryCode, i.validations.length, i.price);
    }  
}