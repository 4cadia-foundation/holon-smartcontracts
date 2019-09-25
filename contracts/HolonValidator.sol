pragma solidity 0.5.11;
import './holon.sol';

contract HolonValidator is Holon {

    //private fields
    uint _validatorStake;

    //modifiers
    modifier hasValidStake {
        require(msg.value >= _validatorStake, "Sent stake less than minimum stake accepted");
        _;
    }
    
    modifier fieldExists(address persona, string memory fieldName) {
        require(_holonStorage.personaFieldExists(msg.sender, fieldName), "Field not exists!");
        _;
    }
    modifier isPendingValidation(address personaAddress, string memory fieldName){
        require(_holonStorage.getPersonaFieldPending(msg.sender, personaAddress, fieldName), "Invalid permissions!");
        _;
    }
    //constructor
    constructor(address storageSmAddress) public {
        _owner = msg.sender;
        _holonStorage = HolonStorage(storageSmAddress);
    }

    //public functions
    function setStake(uint stake) public isOwner {
        _validatorStake = stake;
    }

    function addValidator(HolonStorage.ValidationCostStrategy strategy, uint price) public payable hasValidStake isPersona {
        _holonStorage.addValidator(strategy, price);
    }

    function validate(address personaAddress, 
                      string memory fieldName, 
                      HolonStorage.ValidationStatus status) 
                      public payable 
                      isValidator
                      validPersona(personaAddress)
                      fieldExists(personaAddress, fieldName)
                      isPendingValidation(personaAddress, fieldName) {

        HolonStorage.ValidationCostStrategy strategy = _holonStorage.getValidatorCostStrategy(msg.sender);
        if (strategy == HolonStorage.ValidationCostStrategy.Rebate) {
            require(msg.value >= _holonStorage.getValidatorPrice(msg.sender), "Invalid validator payment price!");
            address payable payablePersona = address(uint160(personaAddress));
            payablePersona.transfer(msg.value);
        }

        _holonStorage.validate(personaAddress, fieldName, status);
    }
}