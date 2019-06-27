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
        uint reputation;
        DataCategory dataCategory;
        bool exists;
        Stamp[] validations;
        mapping(address => Validator) validators;
    }
    
    struct Persona {
        address payable personalAddress;
        uint pendingDataDeliver;
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
    enum DataCategory { PlainText, IPFSHash, URI }
    
    event NewData(address persona, DataCategory dataCategory, uint infoCategory, string field);
    event ValidateMe(address requester, address validator, DataCategory dataCategory, string field, string data);
    event ValidationResult(address persona, address validator, string field, ValidationChoices result);
    event LetMeSeeYourData(address requester, address persona, string field);
    event DeliverData(bool accepted, address persona, address consumer, DataCategory dataCategory, string field, string data);
    
    mapping(uint => string) public infoCategories;    
    mapping(address => Persona) public members;
    mapping(address => Validator) public holonValidators;
    
    constructor () public payable {
        
    }
    
    function addPersona(uint _infoCode, DataCategory _dataCategory, string memory _field, string memory _data, uint _price) 
        public
        returns (bool)
    {
        require(_price >= 0, "You must inform correct value");
        Persona storage p = members[msg.sender];
        p.personalAddress = msg.sender;
        p.pendingDataDeliver = 0;
        p.exists = true;
        
        Info storage i = p.personalInfo[_field];
        i.infoCategoryCode = _infoCode;
        i.dataCategory = _dataCategory;
        i.field = _field;
        i.data = _data;
        i.price = _price;
        i.exists = true;
        emit NewData(msg.sender, _dataCategory, _infoCode, _field);
        return true;
    }
    
    function addData(uint _infoCode, DataCategory _dataCategory, string memory _field, string memory _data, uint _price) 
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
        i.dataCategory = _dataCategory;
        i.data = _data;
        i.price = _price;
        i.exists = true;
        emit NewData(msg.sender, _dataCategory, _infoCode, _field);
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
    
    function addInfoCategory(uint _index, string memory _details) 
        public
        returns (bool)
    {
        require(bytes(infoCategories[_index]).length<1, "This category code already exists");
        infoCategories[_index] = _details;
        return true;
    }
    
    function askToValidate(address _validator, DataCategory _dataCategory, string memory _field, string memory _data) 
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
        emit ValidateMe(msg.sender, _validator, _dataCategory, _field, _data);
        return true;
    }
    
    function validate(address _persona, string memory _field, ValidationChoices _status) 
        public
        payable
        returns (bool)
    {
        Validator memory v = holonValidators[msg.sender];
        if (v.strategy == ValidationCostStrategy.Charged) {
            require(correctPrice(v.strategy, msg.value), "You must send a correct value");
        }
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
        if (v.strategy == ValidationCostStrategy.Rebate && msg.value > 0) {
            p.personalAddress.transfer(msg.value);
        }
        if (_status == ValidationChoices.Validated) {
            i.reputation++;
        }
        v.reputation++;
        return true;
    }
    
    function getPersonaData(address _address, string memory _field)
        public
        view
        returns (string memory, string memory, DataCategory, uint, uint, uint)
    {
        Persona storage p = members[_address];
        Info memory i = p.personalInfo[_field];
        return (i.field, i.data, i.dataCategory, i.reputation, i.validations.length, i.price);
    }
    
    function getPersonaDataValidatorDetails(address _address, string memory _field, uint validatorIndex)
        public
        view
        returns (string memory, string memory, DataCategory, uint, uint, address, uint, ValidationChoices, uint, uint)
    {
        Persona storage p = members[_address];
        Info storage i = p.personalInfo[_field];
        Stamp memory s = i.validations[validatorIndex];
        Validator memory v = i.validators[s.validatorAddress];
        return (i.field, i.data, i.dataCategory, i.reputation, i.price, v.validatorAddress, v.reputation, s.status, s.whenDate, s.whenBlock);
    }
    
    function askDecryptedData(address _address, string memory _field)
        public
        payable
        returns (bool)
    {
        Persona storage p = members[_address];
        require(p.exists, "This persona is not registered");
        Info memory i = p.personalInfo[_field];
        require(msg.value >= i.price, "You must pay");
        p.pendingDataDeliver++;
        emit LetMeSeeYourData(msg.sender, _address, _field);
        return true;
    }
    
    function deliverDecryptedData(bool _accept, address payable _address, DataCategory _dataCategory, string memory _field, string memory _data) 
        public
        returns (bool)
    {
        Persona storage p = members[msg.sender];
        require(p.exists, "This persona is not registered");
        Info memory i = p.personalInfo[_field];
        if (i.price > 0) {
            if (!_accept) {
                _address.transfer(i.price);
            } else {
                p.personalAddress.transfer(i.price);
            }
        }
        p.pendingDataDeliver--;
        emit DeliverData(_accept, msg.sender, _address, _dataCategory, _field, _data);
        return true;
    }
        
}