# Holon Validator

Holon Validator is a smart contract about the Validator

### Smart contracts data
| Smart Contract| Description | 
| ------ | ------ | 
| Holon | Holon Data. Name, Email, Age, etc. | 
| Holon Storage | Persona Data. Name, Email, Age, etc. | 
| Persona | Persona Data. Name, Email, Age, etc. |  
| Validator | Validator Data. Name, Email, Age, etc. | 
| Consumer | Consumer functions.. |  

## Methods / Functions
### addValidator
```sh
Set a Holon Persona to Validator
params:
- ValidationCostStrategy _strategy (enum - ForFree, Charged, Rebate)
- uint _price
```
### validate
```sh
Validate a Persona's field
params:
- address personaAddress,
- string memory field,
- ValidationStatus status
returns
```
### getPendingValidations
```sh
Returns a field's list to Validation (Pending) - to Validator
params:

returns
- address[] memory
- string[] memory
- string[] memory
```
### getValidators
```sh
Return Validator's List
params:

return
- address[] memory
- string[] memory
```
