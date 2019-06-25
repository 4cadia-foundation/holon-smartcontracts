pragma solidity 0.5.9;

contract Holon {
    
    struct Validator {
        address validatorAddress;
        uint reputation;
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
    
    struct Info {
        uint infoCategoryCode;
        string field;
        string data;
        uint price;
        bool exists;
        Stamp[] validations;
        mapping(address => Validator) validators;
    }
    
    struct Persona {
        address payable personalAddress;
        bool exists;
        mapping(string => Info) personalInfo;
        
    }
    
    function correctPrice (ValidationCostStrategy _strategy, uint valueInformed) 
        public 
        pure
        returns (bool)
    {
        if (_strategy == ValidationCostStrategy.ForFree && valueInformed>0) {
            return false;
        } else if (_strategy != ValidationCostStrategy.ForFree && valueInformed<1) {
            return false;
        }
        return true;
    }
    
    enum ValidationChoices { Validated, NotValidated, CannotEvaluate }
    enum ValidationCostStrategy { ForFree, Charged, Rebate }
    
    event ValidateMe(address requester, address validator, string field);
    event ValidationResult(address persona, address validator, string field, ValidationChoices result);
    event LetMeSeeYourData(address requester, address persona, string field);
    
    mapping(uint => string) public infoCategories;    
    mapping(address => Persona) public members;
    mapping(address => Validator) public holonValidators;
    
    constructor () public payable {
        
    }
    
    function addPersona(uint _infoCode, string memory _field, string memory _data, uint _price) 
        public
        returns (bool)
    {
        require(_price >= 0, "You must inform correct value");
        Persona storage p = members[msg.sender];
        p.personalAddress = msg.sender;
        p.exists = true;
        
        Info storage i = p.personalInfo[_field];
        i.infoCategoryCode = _infoCode;
        i.field = _field;
        i.data = _data;
        i.price = _price;
        i.exists = true;
        return true;
    }
    
    function addData(uint _infoCode, string memory _field, string memory _data, uint _price) 
        public
        returns (bool)
    {
        require(_price >= 0, "You must inform correct value");
        Persona storage p = members[msg.sender];
        require(p.exists, "This persona is not registered");
        Info storage i = p.personalInfo[_field];
        require(!i.exists, "This field is already registered");
        i.infoCategoryCode = _infoCode;
        i.field = _field;
        i.data = _data;
        i.price = _price;
        i.exists = true;
        return true;
    }
    
    function addValidator(ValidationCostStrategy _strategy, uint _price) 
        public
        payable 
        returns (bool)
    {
        require(correctPrice(_strategy, _price), "Your charge or rewards strategy does not match with the price informed");
        require(msg.value >= 1 ether, "You have to pay 1 ether to become a validator");
        Persona memory p = members[msg.sender];
        require(p.exists, "You must be a persona within Holon to become a validator");
        holonValidators[msg.sender] = Validator(msg.sender, 0, _strategy, _price, true);
        return true;
    }
    
    function addCategory(uint _index, string memory _details) 
        public
        returns (bool)
    {
        require(bytes(infoCategories[_index]).length<1, "This category code already exists");
        infoCategories[_index] = _details;
        return true;
    }
    
    function askToValidate(address _validator, string memory _field) 
        public
        payable
        returns (bool)
    {
        Validator memory v = holonValidators[_validator];
        require(v.exists, "Validator informed is not registered");
        require(correctPrice(v.strategy, msg.value), "You must send a correct value");
        bool check = true;
        if (v.strategy == ValidationCostStrategy.Charged && msg.value<v.price) {
            check = false;
        }
        require(check, "You must send a correct value");
        emit ValidateMe(msg.sender, _validator, _field);
        return true;
    }
    
    function validate(address _persona, string memory _field, ValidationChoices _status) 
        public
        payable
        returns (bool)
    {
        Validator memory v = holonValidators[msg.sender];
        require(correctPrice(v.strategy, msg.value), "You must send a correct value");
        bool check = true;
        if (v.strategy == ValidationCostStrategy.Rebate && msg.value<v.price) {
            check = false;
        }
        require(check, "You must send a correct value");
        Persona storage p = members[_persona];
        Info storage i = p.personalInfo[_field];
        i.validators[msg.sender] = v;
        Stamp memory s = Stamp(msg.sender, _status, block.timestamp, block.number);
        i.validations.push(s);
        emit ValidationResult(_persona, msg.sender, _field, _status);
        if (_status == ValidationChoices.CannotEvaluate) {
            return true;
        }
        if (v.strategy == ValidationCostStrategy.Rebate) {
            p.personalAddress.transfer(msg.value);
        } 
        return true;
    }
    
    function getPersonaData(address _address, string memory _field)
        public
        view
        returns (string memory, string memory, uint)
    {
        Persona storage p = members[_address];
        Info memory i = p.personalInfo[_field];
        return (i.field, i.data, i.validations.length);
    }
    
    function getPersonaDataValidatorDetails(address _address, string memory _field, uint validatorIndex)
        public
        view
        returns (string memory, string memory, address, uint, ValidationChoices, uint, uint)
    {
        Persona storage p = members[_address];
        Info storage i = p.personalInfo[_field];
        Stamp memory s = i.validations[validatorIndex];
        Validator memory v = i.validators[s.validatorAddress];
        return (i.field, i.data, v.validatorAddress, v.reputation, s.status, s.whenDate, s.whenBlock);
    }
    
    function askDecryptedPersonaDataValidatorDetails(address _address, string memory _field)
        public
        payable
        returns (string memory, string memory, uint)
    {
        Persona storage p = members[_address];
        require(p.exists, "This persona is not registered");
        Info memory i = p.personalInfo[_field];
        emit LetMeSeeYourData(msg.sender, _address, _field);
        return (i.field, i.data, i.validations.length);
    }
        
}