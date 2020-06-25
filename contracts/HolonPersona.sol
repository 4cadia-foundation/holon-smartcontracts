pragma solidity 0.5.11;
import './Holon.sol';

contract HolonPersona is Holon {

    //constructor
    constructor(address storageSmAddress) public {
        BuildHolonStorage(storageSmAddress);
    }

    //modifiers
    modifier fieldNotExists(string memory fieldName) {
        require(!_holonStorage.personaFieldExists(msg.sender, fieldName), "Field already added!");
        _;
    }

    modifier isAskedField(address consumer, string memory fieldName) {
        require(_holonStorage.isAskedField(msg.sender, consumer, fieldName), "Field not asked!");
        _;
    }

    //public functions
    function addPersona(string memory name, uint price) public isNotPersona {
        _holonStorage.addPersona(name, price, msg.sender);
    }

    function addPersonaField(string memory fieldName,
                             string memory fieldData,
                             uint fieldPrice,
                             string memory category,
                             string memory subCategory)
    public isPersona fieldNotExists(fieldName) {
        _holonStorage.addPersonaField(msg.sender, fieldName, fieldData, fieldPrice, category, subCategory);
    }

    function askToValidate(address validator,
                           string memory field,
                           string memory proofUrl)
                           public payable
                           isPersona
                           fieldExists(msg.sender, field)
                           validValidator(validator) {

        HolonStorage.ValidationCostStrategy strategy = _holonStorage.getValidatorCostStrategy(validator);
        if (strategy == HolonStorage.ValidationCostStrategy.Charged) {
            require(msg.value >= _holonStorage.getValidatorPrice(validator), "Invalid validator payment price!");
            address payable payableValidator = address(uint160(validator));
            payableValidator.transfer(msg.value);
        }

        _holonStorage.askToValidate(msg.sender, validator, field, proofUrl);
    }

    function allowConsumer(address consumer,
                           string memory fieldName,
                           bool allow)
                           public
                           validPersona(consumer)
                           isAskedField(consumer, fieldName) {
         _holonStorage.allowConsumer(msg.sender, consumer, fieldName, allow);
    }
}