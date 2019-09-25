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

    function validate(address _persona, string memory _field, HolonStorage.ValidationChoices _status) public payable returns (bool) {
        HolonStorage.Validator memory validator = HolonStorage._validators[msg.sender];
        HolonStorage.Persona memory persona = HolonStorage._personas[_persona];
        HolonStorage.FieldInfo memory info = persona.fieldInfo[_field];
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
}