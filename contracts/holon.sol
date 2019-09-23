pragma solidity 0.5.11;

contract HolonStorage {

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

    //mappings
    mapping (address => Persona) _personas;

    //public functions
    function isPersona(address personaAddress) public view returns (bool) {
        Persona storage persona = _personas[personaAddress];
        return persona.exists;
    }

    function personaFieldExists(address personaAddress, string memory fieldName) public view returns (bool) {
        Persona storage persona = _personas[personaAddress];
        return persona.fieldInfo[fieldName].exists;
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
    public isPersona fieldExists(field){
        
    }
}