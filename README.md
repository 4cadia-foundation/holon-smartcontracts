# Holon Storage

Holon Storage is a smart contract part where the data is storage and some functions is alocated.

### Smart contracts data
| Smart Contract| Description | 
| ------ | ------ | 
| Holon | Holon Data. Name, Email, Age, etc. | 
| Holon Storage | Persona Data. Name, Email, Age, etc. | 
| Persona | Persona Data. Name, Email, Age, etc. |  
| Validator | Validator Data. Name, Email, Age, etc. | 
| Consumer | Consumer functions.. |  

## Methods / Functions

### removePendingValidation (private)
```sh
Removes pending validation for a data field asked from persona to validator
params:
- address validatorAddress
- uint index

```

### removeAskedField (private)
```sh
Removes asked fields when validator sets the result of validation
params:
- address personaAddress
- uint index

```

### getPersonaFieldPending
```sh
Return field to validation for a Validator
params:
- address validatorAddress
- address personaAddress
- string memory field
returns
- bool
```

### setPersonaFieldPending
```sh
Set field to pending status
params:
- address validatorAddress
- address personaAddress
- string memory field
returns
- bool
```

### isPersona
```sh
Verify if address is Holon Persona
params:
- address personaAddress
returns
- bool
```

### personaFieldExists
```sh
Verify if Persona field exists
params:
- address personaAddress
- string memory fieldName
returns
- bool
```

### isValidator
```sh
Verify if Persona is validator
params:
- address validatorAddress
returns
- bool
```

### addPersona
```sh
Add a Holon Persona with a name field
params:
- memory name
- uint price
- address personaAddress
returns
- bool
```

### addPersonaField
```sh
Add a Holon Persona field 
params:
- address personaAddress,
- string memory fieldName,
- string memory fieldData,
- uint fieldPrice,
- string memory category,
- string memory subCategory
```

### addValidator
```sh
Set a Holon Persona to Validator
params:
- address validatorAddress
- ValidationCostStrategy _strategy (enum - ForFree, Charged, Rebate)
- uint _price
```

### getValidatorPrice
```sh
Return price for a Validator 
params:
- address validatorAddress
returns
- uint 
```

### getValidatorCostStrategy
```sh
Return strategy cost for a Validator 
params:
- address validatorAddress
returns
- ValidationCostStrategy  (enum - ForFree, Charged, Rebate)
```

### getValidators
```sh
Return Validator's List
params:

return
- address[] memory
- string[] memory
```

### askToValidate
```sh
Set a field for validation to Validator
params:
- address persona,
- address validator
- string memory field
- string memory proofUrl
returns

```

### validate
```sh
Validate a Persona's field
params:
- address validatorAddress,
- address personaAddress,
- string memory field,
- ValidationStatus status
returns

```
### getPendingValidations
```sh
Returns a field's list to Validation (Pending) - to Validator
params:
- address validatorAddress) 
- public view 
returns
- address[] memory
- string[] memory
- string[] memory

```

### askPersonaField
```sh
Set a Persona's field to get information
params:
- address consumerAddress
- address personaAddress
- string memory fieldName
returns
```
### isAskedField
```sh
Returns if a Persona's field is asked
params:
- address personaAddress,
- address consumer,
- string memory fieldName
returns
- bool
```

### allowConsumer
```sh
Allow access to a Persona's field information by a Consumer
params:
- address personaAddress,
- address consumer,
- memory fieldName,
- bool allow
returns
```

### isAllowedField
```sh
Returns if Persona's field is allowed by a Consumer
params:
- address consumerAddress,
- address personaAddress,
- string memory fieldName
returns
- bool
```
### getPersonaField
```sh
Returns Persona's field
params:
- address consumerAddress
- address personaAddress
- string memory fieldName
returns
- bool
```
### getPersonaFieldPrice
```sh
Returns Persona's field price
params:
- address personaAddress
- string memory fieldName
returns
- uint
```
