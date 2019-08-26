pragma solidity 0.5.10;

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
        ValidationChoices lastStatus;
        mapping(address => Validator) validators;
    }
    
    struct Persona {
        address payable personalAddress;
        uint pendingDataDeliver;
        bool exists;
        mapping(string => Info) personalInfo;
        string[] fields;        
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
    
    enum ValidationChoices { Validated, NotValidated, CannotEvaluate, NewData, ValidationPending }
    enum ValidationCostStrategy { ForFree, Charged, Rebate }
    enum DataCategory { PlainText, IPFSHash, URI }
    event NewData(address indexed persona, DataCategory dataCategory, uint infoCategory, string field);
    event ValidationResult(address indexed persona, address indexed validator, string field, ValidationChoices result);
    event LetMeSeeYourData(address indexed requester, address indexed persona, string field);
    event DeliverData(bool accepted, address indexed persona, address indexed consumer, DataCategory dataCategory, string field, string data);
    
    mapping(uint => string) public infoCategories;    
    mapping(address => Persona) public members;
    mapping(address => Validator) public holonValidators;
    address[] public holonValidatorsList;
    
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
        p.fields.push(_field);
        
        Info storage i = p.personalInfo[_field];
        i.infoCategoryCode = _infoCode;
        i.dataCategory = _dataCategory;
        i.field = _field;
        i.data = _data;
        i.price = _price;
        i.exists = true;
        i.lastStatus = ValidationChoices.NewData;
        
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
        i.lastStatus = ValidationChoices.NewData;
        p.fields.push(_field);
        emit NewData(msg.sender, _dataCategory, _infoCode, _field);
        return true;
    }
    
    function addValidator(ValidationCostStrategy _strategy, uint _price) 
        public
        payable 
        returns (bool)
    {
        require(correctPrice(_strategy, _price), "Your charge or rewards strategy does not match with the price informed");
        //descomentar
        // require(msg.value >= 1 szabo, "You have to pay 1 ether to become a validator");
        Persona memory p = members[msg.sender];
        require(p.exists, "You must be a persona within Holon to become a validator");
        holonValidators[msg.sender] = Validator(msg.sender, 0, _strategy, _price, true);
        holonValidatorsList.push(msg.sender);
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
        
        Persona storage persona = members[msg.sender];
        require(persona.exists, "Persona not found");

        Info storage fieldInfo = persona.personalInfo[_field];
        require(fieldInfo.exists, "Persona field not found");

        fieldInfo.lastStatus = ValidationChoices.ValidationPending;
        Stamp memory pendingStamp = Stamp(msg.sender, fieldInfo.lastStatus, block.timestamp, block.number);
        fieldInfo.validations.push(pendingStamp);

        return true;
    }

    function GetFieldLastStatus(string memory _field)
        public
        view
        returns (ValidationChoices)
        {        
            //aki
            Persona storage persona = members[msg.sender];
            require(persona.exists, "Persona not found");

            Info storage fieldInfo = persona.personalInfo[_field];
            require(fieldInfo.exists, "Persona field not found");

            return fieldInfo.lastStatus;
        }

    function validate(address _persona, string memory _field, ValidationChoices _status) 
        public
        payable
        returns (bool)
    {
        Validator storage v = holonValidators[msg.sender];
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
        i.lastStatus = _status;
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

    function getPersonaDataByFieldIndex(address _address, uint _fieldIndex)
        public
        view
        returns (string memory, string memory, DataCategory, uint, uint, uint)
    {
        Persona storage p = members[_address];
        string memory field = p.fields[_fieldIndex];
        Info memory i = p.personalInfo[field];
        return (i.field, i.data, i.dataCategory, i.reputation, i.validations.length, i.price);
    }

    function getPersonaNumberOfFields(address _address)
        public
        view
        returns (uint)
    {
        Persona storage p = members[_address];        
        return (p.fields.length);
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

    function score(address _personaAddress)
        public
        view
        returns (uint, uint) 
    {
        Persona storage p = members[_personaAddress];
        require(p.exists, "This persona is not registered");
        uint validations = 0;
        Info memory info;
        for (uint i=0; i<p.fields.length; i++) {
            string memory field = p.fields[i]; 
            info = p.personalInfo[field];
            validations = validations + info.validations.length;
        }
        return (p.fields.length, validations);
    }

    function getTotalValidators()
        public
        view
        returns (uint) 
    {        
        return holonValidatorsList.length;
    }

        
}