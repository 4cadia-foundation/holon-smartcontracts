pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;

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

    struct PersonaAskedFields {
        address consumer;
        string field;
    }


    //mappings
    mapping (address => Persona) public _personas;
    mapping (address => Validator)  _validators;
    mapping (address => PendingValidation[]) _validatorPendingValidation;

    //validator
    mapping (address => mapping (address => mapping (string => bool))) _validatorHasPersonaFieldPending;
    mapping (address => mapping (address => mapping (string => uint))) _validatorPersonaFieldPendingIndex;
    address[] public _holonValidatorsList;


    //consumer
    mapping (address => PersonaAskedFields[]) _personaAskedFields;
    mapping (address => mapping (address => mapping (string => bool))) _isPersonaFieldAsked;
    mapping (address => mapping (address => mapping (string => uint))) _personaAskedFieldIndex;
    mapping (address => mapping (address => mapping (string => bool))) _isPersonaFieldAllowed;



    //private functions
    function removePendingValidation(address validatorAddress, uint index) private {
        PendingValidation[] storage pendingValidation = _validatorPendingValidation[validatorAddress];
        if (pendingValidation.length > 1)
            pendingValidation[index] = pendingValidation[pendingValidation.length - 1];

        pendingValidation.length--;
    }

    function removeAskedField(address personaAddress, uint index) private {
        PersonaAskedFields[] storage askedFields = _personaAskedFields[personaAddress];
        if (askedFields.length > 1)
            askedFields[index] = askedFields[askedFields.length - 1];

        askedFields.length--;
    }


    //public functions
    function getPersonaFieldPending(address validatorAddress,
                                    address personaAddress,
                                    string memory field)
                                    public view
                                    returns (bool) {
        return _validatorHasPersonaFieldPending[validatorAddress][personaAddress][field];
    }

    function setPersonaFieldPending(address validatorAddress,
                                    address personaAddress,
                                    string memory field,
                                    bool pending)
                                    public
                                    returns (bool) {
        _validatorHasPersonaFieldPending[validatorAddress][personaAddress][field] = pending;
    }

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

    function addPersona(string memory name, uint price, address personaAddress) public {
        Persona storage newPersona = _personas[personaAddress];
        newPersona.exists = true;

        FieldInfo storage nameField = newPersona.fieldInfo["name"];
        nameField.data = name;
        nameField.price = price;
        nameField.category = "Plain text";
        nameField.subCategory = "Personal info";
        nameField.exists = true;
        nameField.lastStatus = ValidationStatus.NotValidated;
    }

    function addPersonaField(address personaAddress,
                             string memory fieldName,
                             string memory fieldData,
                             uint fieldPrice,
                             string memory category,
                             string memory subCategory) public {
        Persona storage persona = _personas[personaAddress];
        persona.fieldInfo[fieldName] = FieldInfo(fieldData, fieldPrice, category, subCategory, true, ValidationStatus.NotValidated);
    }

    function addValidator(address validatorAddress, ValidationCostStrategy _strategy, uint _price) public {
        _validators[validatorAddress] = Validator(_strategy, _price, true);
        _holonValidatorsList.push(msg.sender);
    }

    function getValidatorPrice(address validatorAddress) public view returns (uint) {
         Validator storage validator = _validators[validatorAddress];
         return validator.price;
    }

    function getValidatorCostStrategy(address validatorAddress) public view returns (ValidationCostStrategy) {
         Validator storage validator = _validators[validatorAddress];
         return validator.strategy;
    }

    function getValidators() public 
                             view 
                             returns (address[] memory validatorAddress,
                             string[] memory validatorName) {
        
        for (uint validatorIndex = 0; validatorIndex < _holonValidatorsList.length; validatorIndex++) {
            address vAddress = _holonValidatorsList[validatorIndex];
            Persona storage validator = _personas[vAddress];

            validatorAddress[validatorIndex] = vAddress;
            validatorName[validatorIndex] = validator.fieldInfo["name"].data;
        }
        return (validatorAddress, validatorName);
    }

    function askToValidate(address persona,
                           address validator,
                           string memory field,
                           string memory proofUrl) public {
        uint length = _validatorPendingValidation[validator].push(PendingValidation(persona, field, proofUrl));
        setPersonaFieldPending(validator, persona, field, true);
        _validatorPersonaFieldPendingIndex[validator][persona][field] = length - 1;
    }

    function validate(address validatorAddress,
                      address personaAddress,
                      string memory field,
                      ValidationStatus status)
                      public {
        _personas[personaAddress].fieldInfo[field].lastStatus = status;
        setPersonaFieldPending(validatorAddress, personaAddress, field, false);
        uint fieldIndex = _validatorPersonaFieldPendingIndex[validatorAddress][personaAddress][field];
        removePendingValidation(validatorAddress, fieldIndex);
    }

    function getPendingValidations (address validatorAddress) 
                                    public view 
                                    returns (address[] memory, 
                                    string[] memory, 
                                    string[] memory) {

        PendingValidation[] memory onlyPendingValidations = _validatorPendingValidation[validatorAddress];
        uint length = onlyPendingValidations.length;
        address[] memory personasAddress = new address[](length);
        string[] memory personasNames = new string[](length);
        string[] memory fields = new string[](length);

        for (uint pendingValidationsIndex = 0; pendingValidationsIndex < length; pendingValidationsIndex++) {
            address personaAddress = onlyPendingValidations[pendingValidationsIndex].personaAddress;
            Persona storage personaRequester = _personas[personaAddress];
            string memory personaNameRequester = personaRequester.fieldInfo["name"].data;
            personasAddress[pendingValidationsIndex] = personaAddress;
            personasNames[pendingValidationsIndex] = personaNameRequester;
            fields[pendingValidationsIndex] = onlyPendingValidations[pendingValidationsIndex].field;
        }
        return (personasAddress, personasNames, fields);
    }

    function askPersonaField(address consumerAddress,
                             address personaAddress,
                             string memory fieldName)
                             public {
        uint length = _personaAskedFields[personaAddress].push(PersonaAskedFields(consumerAddress, fieldName));
        _personaAskedFieldIndex[personaAddress][consumerAddress][fieldName] = length - 1;
        _isPersonaFieldAsked[personaAddress][consumerAddress][fieldName] = true;
    }

    function isAskedField(address personaAddress,
                          address consumer,
                          string memory fieldName)
                          public view
                          returns (bool) {
        return _isPersonaFieldAsked[personaAddress][consumer][fieldName];
    }

    function allowConsumer(address personaAddress,
                           address consumer,
                           string memory fieldName,
                           bool allow)
                           public {

        _isPersonaFieldAllowed[personaAddress][consumer][fieldName] = allow;
        _isPersonaFieldAsked[personaAddress][consumer][fieldName] = false;
        uint fieldIndex = _personaAskedFieldIndex[personaAddress][consumer][fieldName];
        removeAskedField(personaAddress, fieldIndex);
    }

    function isAllowedField(address consumerAddress,
                            address personaAddress,
                            string memory fieldName)
                            public view
                            returns (bool) {
        return _isPersonaFieldAllowed[personaAddress][consumerAddress][fieldName];
    }

    function getPersonaField(address consumerAddress,
                             address personaAddress,
                             string memory fieldName)
                             public
                             payable
                             returns (string memory) {
        Persona storage persona = _personas[personaAddress];
        _isPersonaFieldAllowed[personaAddress][consumerAddress][fieldName] = false;
        return persona.fieldInfo[fieldName].data;
    }

    function getPersonaFieldPrice(address personaAddress,
                                  string memory fieldName)
                                  public view 
                                  returns (uint) {
        Persona storage persona = _personas[personaAddress];
        return persona.fieldInfo[fieldName].price;
    }
}