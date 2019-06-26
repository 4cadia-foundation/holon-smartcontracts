
-----------------------------------------------------
addInfoCategory - Insert category for persona data
-----------------------------------------------------
Input:
	0 : _index - category id
	1 : _details - category name
Return:
	0 : bool
Test:
	Any account with balance can create a category

----------------------------------
addPersona - Insert Persona / data
----------------------------------
Input:
	0 : _InfoCode - category id 
	1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI )
	2 : _field - field name
	3 : _data - field value
	4 : _price (cost for info/data) - 17 positions
Return:
	0 : bool
    1 : event: NewData(msg.sender, _dataCategory, _infoCode, _field);
Test:
	Any account with balance can create your Persona / Persona data
	* addPersona only one address

------------------------------------------
addData - Insert data for existing Persona
------------------------------------------
Input:
	0 : _InfoCode - Info code
	1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI )
	2 : _field - field name
	3 : _data - field value
	4 : _price (cost for info)
Return:
	0 : bool
    1 : event: NewData(msg.sender, _dataCategory, _infoCode, _field);
Test:
    0 : Add a Persona data with addPersona Method
    1 : Add other Persona data 
	** Any account with balance can create data for your existing Persona
	
----------------------------------
AddValidator - Insert validator
----------------------------------
Input:
	0 : _strategy: ValidationCostStrategy: enum (0 - ForFree, 1 - Charged, 2 - Rebate)
	1 : _price: charge validador in ETH (17 positions)
Return:
	0 : bool
Test:
	0 : Add a Persona with addPersona Method (Validator must be a Persona)
    1 : Add Validator data (_strategy and _price)

------------------------------------
getPersonaData - Return Persona data
------------------------------------
Input: 
	0 : _address - Persona Address
	1 : _Field - Data Field name 
Return
    0 : string: field name
    1 : string: field / Data Value
    2 : uint8: dataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI )
    3 : uint256: reputation
    4 : uint256: qty data validations
    5 : uint256: data cost
Test:
    0 : Create a Persona data with addPersona method
    1 : Retrieve Persona data with same address

---------------------------------------------------------------------------
getPersonaDataValidatorDetails - Return validation details for Persona Data
---------------------------------------------------------------------------
Input:
	0 - _address - Persona Address
	1 : _field - Validated Field / Data
	2 : validatorIndex - Validators index - array
Return:
	0 : string: field / Data Name
	1 : string: field / Data Value
	2 : uint256: Data cost
	3 : address: Validator address
	4 : uint256: reputation
	5 : uint8: ValidationChoices: enum { 0 - Validated, 1 - NotValidated, 2 - CannotEvaluate }
	6 : uint256: Block Date
	7 : uint256: Block
Test:
    0 : Create a Persona data with addPersona method
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator's address


-----------------------------------------------
validate - validation process for Personal data
-----------------------------------------------
Input: 
    0 : _persona: address: Persona address
    1 : _field: string: Field / Data name
    2 : _status: ValidationChoices: enum (0 - Validated, 1 - NotValidated, 2 - CannotEvaluate)
Return:
    0 : bool
    1 : event: ValidationResult(_persona, msg.sender, _field, _status)
Test:
    0 : Create a Persona data with addPersona method
    1 : Set the values (_persona, _field) - use a Persona's address to validate and _status for set result

---------------------------------------
holonValidators - return Validator data
---------------------------------------
Input:
	0 : address: validatorAddress 
Return
	0 : address: validatorAddress 
	1 : uint256: reputation 
	2 : uint8: strategy 
	3 : uint256: price (Validator cost)
	4 : bool: exists 
Test:
    0 : Create a Persona data with addPersona method
    1 : Create a Validator with AddValidator method and same Person address

--------------------------------------
infoCategories - return Category data
--------------------------------------
Input
    0 : address: Category address
Return:
    0 : string: Category data / name
Test:
    0 : Create a Category with addInfoCategory Method
    1 : Retrieve Category data with Category id

----------------------------------------------
members - return persona data
----------------------------------------------
Input:
	0 : address: personalAddress 
Return:
	0 : address: personalAddress 
    1 : uint: pendingDataDeliver
	2 : bool: exists 
Test    
    0 : Create a Persona data with addPersona method
    1 : Provide Persona address

--------------------------------------------------------
askToValidate - request data validation by Validator
--------------------------------------------------------
Input:
    0 : _validator: address: Validator Address
    1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI)
    2 : _field: string: field / data name
    3 : _data: string: field / data value
Return:
    0 : boolean    
    1 : event: ValidateMe(msg.sender, _validator, _dataCategory, _field, _data)
Test:    
    0 : Create a Persona data with addPersona method
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator's address
    3 : Set the values of data to be Validated


------------------------------------------------------
askDecryptedData - request decrypted data from Persona
------------------------------------------------------
Input:
    0 : _address: address: Persona address
    1 : _field: string: field / data name
Return:
    0 : bool
    1 : event: LetMeSeeYourData(msg.sender, _address, _field)
Test:    
    0 : Create a Persona data with addPersona method
    1 : Set the values

-----------------------------------------------------------------
deliverDecryptedData - deliver decrypted Persona data to Consumer 
-----------------------------------------------------------------
Input:
    0 : _accept: bool: accept / rejected
    1 : _address: address: Consumer address
    2 : _dataCategory: enum ( 0 - PlainText, 1 - IPFSHash, 2 - URI)
    3 : _field: string: field / data name
    4 : _data: string: field / data value
Return:
    0 : bool
    1 : event: DeliverData(_accept, msg.sender, _address, _dataCategory, _field, _data)  
Test:
    0 : Create a Persona data with addPersona method for only be Persona
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator address
    3 : Set the values of data to be Decrypted










 