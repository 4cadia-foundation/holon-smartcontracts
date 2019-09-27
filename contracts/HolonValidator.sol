pragma solidity 0.5.11;
pragma experimental ABIEncoderV2;
import './Holon.sol';

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

    modifier isPendingValidation(address personaAddress, string memory fieldName) {
        require(_holonStorage.getPersonaFieldPending(msg.sender, personaAddress, fieldName), "Invalid permissions!");
        _;

    }


    //constructor
    constructor(address storageSmAddress) public {
        BuildHolonStorage(storageSmAddress);
    }


    //public functions
    function setStake(uint stake) public isOwner {
        _validatorStake = stake;
    }

    function addValidator(HolonStorage.ValidationCostStrategy strategy, 
                          uint price) 
                          public payable
                          isNotValidator 
                          hasValidStake 
                          isPersona {
        _holonStorage.addValidator(msg.sender, strategy, price);
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

        _holonStorage.validate(msg.sender, personaAddress, fieldName, status);
    }

    function getPendingValidations() public
                                     view
                                     returns (address[] memory personasAddress,
                                     string[] memory personasNames,
                                     string[] memory fields) {
        
        return _holonStorage.getPendingValidations(msg.sender);
    }

    function getValidators() public 
                             view 
                             returns (address[] memory validatorAddress,
                             string[] memory validatorName) {
        return _holonStorage.getValidators();
    }
}