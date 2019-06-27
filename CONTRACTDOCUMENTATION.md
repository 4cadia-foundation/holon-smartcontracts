------------------------------------
Create accounts for test im MetaMask
------------------------------------
1 - Account 1 - PersonaValidator
2 - Account 2 - PersonaOnly
3 - Account 3 - Consumer


Step 1
-----------------------------------------------------
addInfoCategory - Insert category for persona data
-----------------------------------------------------
Input:
	0 : _index - category id  << 1 >>
	1 : _details - category name << Personal Data >>
Return:
	0 : bool << true >>
Unit Test:
	Any account with balance can create a category

Step 2
--------------------------------------
infoCategories - return Category data
--------------------------------------
Input
    0 : uint256: Category id << 1 >>
Return:
    0 : string: Category data / name << Personal Data>>
Unit Test:
    0 : Create a Category with addInfoCategory Method
    1 : Retrieve Category data with Category id    

Step 3
----------------------------------
addPersona - Insert Persona / data
----------------------------------
Step 3.1 
Premise:
    0 : Use PersonaValidator account
Input:
	0 : _InfoCode - category id << 1 >>
	1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI ) << 0 >>
	2 : _field - field name << Email >>
	3 : _data - field value << email_01@email.com >>
	4 : _price (cost for info/data) - 17 positions << 10000000000000000 >>
Return:
	0 : bool
    1 : event: NewData(msg.sender, _dataCategory, _infoCode, _field);
Unit Test:
	Any account with balance can create your Persona / Persona data
	* addPersona only one address

Step 3.2
Premise:
    0 : Use PersonaOnly account
Input:
	0 : _InfoCode - category id << 1 >>
	1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI ) << 0 >>
	2 : _field - field name << Email >>
	3 : _data - field value << email_02@email.com >>
	4 : _price (cost for info/data) - 17 positions << 11000000000000000 >>
Return:
	0 : bool
    1 : event: NewData(msg.sender, _dataCategory, _infoCode, _field);
Unit Test:
	Any account with balance can create your Persona / Persona data
	* addPersona only one address

Step 3.3
Premise:
    0 : Use Consumer account
Input:
	0 : _InfoCode - category id << 1 >>
	1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI ) << 0 >>
	2 : _field - field name << Email >>
	3 : _data - field value << email_03@email.com >>
	4 : _price (cost for info/data) - 17 positions << 12000000000000000 >>
Return:
	0 : bool
    1 : event: NewData(msg.sender, _dataCategory, _infoCode, _field);
Unit Test:
	Any account with balance can create your Persona / Persona data
	* addPersona only one address

Step 4 - Check PersonalValidator data
----------------------------------------------
members - return persona data
----------------------------------------------
Input:
	0 : address: << PersonalValidator address > 
Return:
	0 : address: personalAddress: << PersonalValidator address >>
    1 : uint: pendingDataDeliver << 0 >>
	2 : bool: exists << true >>
Test    
    0 : Create a Persona data with addPersona method
    1 : Provide Persona address

Step 5 - Check PersonalOnly data
----------------------------------------------
members - return persona data
----------------------------------------------
Input:
	0 : address: << PersonalOnly address >> 
Return:
	0 : address: << PersonalOnly address > 
    1 : uint: pendingDataDeliver << 0 >>
	2 : bool: exists << true >>
Test    
    0 : Create a Persona data with addPersona method
    1 : Provide Persona address

Step 6 - Check Consumer data
----------------------------------------------
members - return persona data
----------------------------------------------
Input:
	0 : address: << Consumer address >> 
Return:
	0 : address: << Consumer address > 
    1 : uint: pendingDataDeliver << 0 >>
	2 : bool: exists << true >>
Test    
    0 : Create a Persona data with addPersona method
    1 : Provide Persona address


step 7
------------------------------------------
addData - Insert data for existing Persona
------------------------------------------
Input:
	0 : _InfoCode - Info code << 1 >>
	1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI ) << 0 >>
	2 : _field - field name << Phone >>
	3 : _data - field value << 55 11 1234-5678 >>
	4 : _price (cost for info) << 20000000000000000 >>
Return:
	0 : bool
    1 : event: NewData(msg.sender, _dataCategory, _infoCode, _field);
Unit Test:
    0 : Add a Persona data with addPersona Method
    1 : Add other Persona data 
	** Any account with balance can create data for your existing Persona
	
Step 8
------------------------------------
getPersonaData - Return Persona data
------------------------------------
Step 8.1
Input: 
	0 : _address - Persona Address << PersonaValidator address >>
	1 : _Field - Data Field name << Email >>
Return
    0 : string: field name 
    1 : string: field / Data Value
    2 : uint8: dataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI )
    3 : uint256: reputation
    4 : uint256: qty data validations
    5 : uint256: data cost
Unit Test:
    0 : Create a Persona data with addPersona method
    1 : Retrieve Persona data with same address

Step 8.2
Input: 
	0 : _address - Persona Address << PersonaValidatorOnly address >>
	1 : _Field - Data Field name << Phone >>
Return
    0 : string: field name 
    1 : string: field / Data Value
    2 : uint8: dataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI )
    3 : uint256: reputation
    4 : uint256: qty data validations
    5 : uint256: data cost
Unit Test:
    0 : Create a Persona data with addPersona method
    1 : Retrieve Persona data with same address

Step 9
----------------------------------
AddValidator - Insert validator
----------------------------------
Premise:
    0 : Use PersonaValidator account
Input:
	0 : _strategy: ValidationCostStrategy: enum (0 - ForFree, 1 - Charged, 2 - Rebate) << 0 >>
	1 : _price: charge validador in ETH (17 positions) << 0 >>
Return:
	0 : bool
Unit Test:
	0 : Add a Persona with addPersona Method (Validator must be a Persona)
    1 : Add Validator data (_strategy and _price)

Step 10
---------------------------------------
holonValidators - return Validator data
---------------------------------------
Input:
	0 : address: validatorAddress << PersonaValidator address >>
Return
	0 : address: validatorAddress 
	1 : uint256: reputation 
	2 : uint8: strategy 
	3 : uint256: price (Validator cost)
	4 : bool: exists 
Unit Test:
    0 : Create a Persona data with addPersona method
    1 : Create a Validator with AddValidator method and same Person address    

Step 11
-----------------------------------------------
validate - validation process for Personal data
-----------------------------------------------
Step 11.1
Input: 
    0 : _persona: address: Persona address << PersonaOnly address >>
    1 : _field: string: Field / Data name << Email >>
    2 : _status: ValidationChoices: enum (0 - Validated, 1 - NotValidated, 2 - CannotEvaluate) << 0 >>
Return:
    0 : bool
    1 : event: ValidationResult(_persona, msg.sender, _field, _status)
Unit Test:
    0 : Create a Persona data with addPersona method
    1 : Set the values (_persona, _field) - use a Persona's address to validate and _status for set result

Step 11.2
Input: 
    0 : _persona: address: Persona address << PersonaOnly address >>
    1 : _field: string: Field / Data name << Phone >>
    2 : _status: ValidationChoices: enum (0 - Validated, 1 - NotValidated, 2 - CannotEvaluate) << 2 >>
Return:
    0 : bool
    1 : event: ValidationResult(_persona, msg.sender, _field, _status)
Unit Test:
    0 : Create a Persona data with addPersona method
    1 : Set the values (_persona, _field) - use a Persona's address to validate and _status for set result

Step 12 - Check
---------------------------------------------------------------------------
getPersonaDataValidatorDetails - Return validation details for Persona Data
---------------------------------------------------------------------------
Step 12.1
Input:
	0 - _address - Persona Address << PersonaOnly address >>
	1 : _field - Validated Field / Data << Email >>
	2 : validatorIndex - Validators index - array << 0 >>
Return:
	0 : string: field / Data Name
	1 : string: field / Data Value
	2 : uint256: Data cost
	3 : address: Validator address
	4 : uint256: reputation
	5 : uint8: ValidationChoices: enum { 0 - Validated, 1 - NotValidated, 2 - CannotEvaluate }
	6 : uint256: Block Date
	7 : uint256: Block
Unit Test:
    0 : Create a Persona data with addPersona method
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator's address

Step 12.2
Input:
	0 - _address - Persona Address << PersonaOnly address >>
	1 : _field - Validated Field / Data << Phone >>
	2 : validatorIndex - Validators index - array << 0 >>
Return:
	0 : string: field / Data Name
	1 : string: field / Data Value
	2 : uint256: Data cost
	3 : address: Validator address
	4 : uint256: reputation
	5 : uint8: ValidationChoices: enum { 0 - Validated, 1 - NotValidated, 2 - CannotEvaluate }
	6 : uint256: Block Date
	7 : uint256: Block
Unit Test:
    0 : Create a Persona data with addPersona method
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator's address

Step 13
--------------------------------------------------------
askToValidate - request data validation by Validator
--------------------------------------------------------
Premises:
    0 : Use PersonalOnly account

Step 13.1 - Validate Email
Input:
    0 : _validator: address: << PersonalValidator Address >>
    1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI) << 0 >>
    2 : _field: string: field / data name << Email >>
    3 : _data: string: field / data value << email_01@email.com >>
Return:
    0 : boolean    
    1 : event: ValidateMe(msg.sender, _validator, _dataCategory, _field, _data)
Test:    
    0 : Create a Persona data with addPersona method
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator's address
    3 : Set the values of data to be Validated

Step 13.2 - Validate Phone
Input:
    0 : _validator: address: << PersonalValidator Address >>
    1 : _dataCategory: DataCategory: enum (0 - PlainText, 1 - IPFSHash, 2 - URI) << 0 >>
    2 : _field: string: field / data name << Phone >>
    3 : _data: string: field / data value << 55 11 1234-5678 >>
Return:
    0 : boolean    
    1 : event: ValidateMe(msg.sender, _validator, _dataCategory, _field, _data)
Unit Test:    
    0 : Create a Persona data with addPersona method
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator's address
    3 : Set the values of data to be Validated

Step 14
------------------------------------------------------
askDecryptedData - request decrypted data from Persona
------------------------------------------------------
Premises:
    0 : Use Consumer Account
Input:
    0 : _address: address: << PersonalOnly address >>
    1 : _field: string: field / data name << Email >>
Return:
    0 : bool
    1 : event: LetMeSeeYourData(msg.sender, _address, _field)
Unit Test:    
    0 : Create a Persona data with addPersona method
    1 : Set the values

Step  15
-----------------------------------------------------------------
deliverDecryptedData - deliver decrypted Persona data to Consumer 
-----------------------------------------------------------------
Premises:
    0 : Use PersonaOnly Account

Step 15.1    
Input:
    0 : _accept: bool: accept / rejected << 1 >>
    1 : _address: address: << Consumer address >>
    2 : _dataCategory: enum ( 0 - PlainText, 1 - IPFSHash, 2 - URI) << 0 >>
    3 : _field: string: field / data name << Email >>
    4 : _data: string: field / data value << email_01@email.com >>
Return:
    0 : bool
    1 : event: DeliverData(_accept, msg.sender, _address, _dataCategory, _field, _data)  
Unit Test:
    0 : Create a Persona data with addPersona method for only be Persona
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator address
    3 : Set the values of data to be Decrypted

Step 15.2 
Input:
    0 : _accept: bool: accept / rejected << 1 >>
    1 : _address: address: << Consumer address >>
    2 : _dataCategory: enum ( 0 - PlainText, 1 - IPFSHash, 2 - URI) << 0 >>
    3 : _field: string: field / data name << Phone >>
    4 : _data: string: field / data value << 55 11 1234-5678 >>
Return:
    0 : bool
    1 : event: DeliverData(_accept, msg.sender, _address, _dataCategory, _field, _data)  
Unit Test:
    0 : Create a Persona data with addPersona method for only be Persona
    1 : Create other Persona data with addPersona method for to be Validator
    2 : Create a Validator with AddValidator method and Validator address
    3 : Set the values of data to be Decrypted








 