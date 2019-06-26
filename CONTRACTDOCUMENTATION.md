Logar no https://twitter.com/
tweetar o endereço da carteira
Copiar link para tweet - na seta pra baixo do tweet
acessar:
https://faucet.rinkeby.io/
Colar o link -> GIVE ME ETHER


1 - Selecione Conta MM com Saldo (Conta 1) - Rinkeby
2 - Deploy do Contrato - Injected Web3 
3 - AddCategory  (1 - Personal Data, etc) - Confirmar no MM
4 - Teste: infoCategories (Informe o ID - 1)
5 - addPersona (Dados do Persona)
5.1 - _InfoCode (Categoria cadastrada anteriormente - 1 Personal Data)
5.2 - _Field (Email)
5.3 - _Data (email@email.com)
5.4 - _price (Valor a ser cobrado pelo dado - em 17 posições: 50000000000000000) - Informar no quadro superior o value: ex: 1
6 - getPersonaData (Verificar os dados)
_address (endereço da persona)
_field (campo cadastrado pra persona - Email no exemplo)
Retorno:
	0: string: Email <-------------- Nome do dado
	1: string: email_01@email.com <--------------- Dado
	2: uint256: 0 <-------------------- Qtde de Validadores
	3: uint256: 50000000000000000 <----------------- Valor do dado
--------------
Adicione mais uma persona (Conta 2)
1 - Mude a conta e repita os passos de addPersona (Alterando os dados)
2 - Teste usando getPersonaData com o endereço da conta 2
3 - getPersonaData (Verificar os dados)
_address (endereço da persona)
_field (campo cadastrado pra persona - Email no exemplo)
Retorno:
	0: string: Email <-------------- Nome do dado
	1: string: email_02@email.com <--------------- Dado
	2: uint256: 0 <-------------------- Qtde de Validadores
	3: uint256: 50000000000000000 <----------------- Valor do dado


-----------------------------------------------------
addInfoCategory - Insert category for persona data
-----------------------------------------------------
Input:
	1 : _index - category id
	2 : _datails - category name
Returns:
	bool
Test:
	Any account with balance can create a category

----------------------------------
addPersona - Insert Persona / data
----------------------------------
Input:
	1 : _InfoCode - Info code
	2 : _dataCategory - (0 - PlainText, 1 - IPFSHash, 2 - URI )
	3 : _field - field name
	4 : _data - field value
	4 : _price (cost for info)
Returns:
	bool
Test:
	Any account with balance can create your Persona / Persona data
	* addPersona only one address

------------------------------------------
addData - Insert data for existing Persona
------------------------------------------
Input:
	1 : _InfoCode - Info code
	2 : _dataCategory - (0 - PlainText, 1 - IPFSHash, 2 - URI )
	3 : _field - field name
	4 : _data - field value
	4 : _price (cost for info)
Returns:
	bool
Test:
	Any account with balance can create data for your existing Persona
	
----------------------------------
AddValidator - Insert validator
----------------------------------
Input:
	1 : _strategy: (0 - ForFree, 1 - Charged, 2 - Rebate)
	2 : _price: charge validador in ETH (17 positions)
Retorno:
	bool
Test:
	Validator must be a Persona

------------------------------------
getPersonaData - Return Persona data
------------------------------------
Input: 
	1 : _address - Persona Address
	2 : _Field - Data Field name
Return




1 : 
Premissa:
Existir como persona
* Necessário informar na parte superior das variáveis o Value da Operação = 1 ether
Entrada:
	1 - _strategy: (0 - ForFree, 1 - Charged, 2 - Rebate)
	2 - _price: charge validador in ETH (17 positions)
Retorno
	bool

----------------------------------
validade - valida dado da persona
----------------------------------
Validador 1 valida dados da persona 2
1 - Copie endereço da persona a ser validada - Conta 2 no caso
2 - _persona - Informe endereço do validador (Conta 1)
3 - _field - dados a ser validado (Email no caso)
4 - _status - (0 - Validated, 1 - NotValidated, 2 - CannotEvaluate)
5 - Confirme no MM

----------------------------------------------------------------------
getPersonaDataValidatorDetails - Verificar dados validados do persona
----------------------------------------------------------------------
Entrada:
	1 - _address - Endereço da Persona
	2 - _field - Campo a ser validado (Email no caso)
	3 - validatorIndex - ìndice do(s) validador(es) - array
Retorno:
	0: string: Email <---- Nome do dados
	1: string: email_02@email.com <---- Valor do dados
	2: uint256: 30000000000000000 <--------- Custo do dado
	3: address: 0xc3d8DFCA4b2387D1d0Bf8A7C4D7B361a26863AAC <---- Endereço do validador
	4: uint256: 0 <--- Reputação
	5: uint8: 0 <---- Status (0 - Validated)
	6: uint256: 1561488751 <---- Data
	7: uint256: 4623930 <----- Bloco

--------------------------------------------------------
holonValidators - retorna dados do endereço do validador
--------------------------------------------------------
Entrada:
	0: address: validatorAddress 0x0000000000000000000000000000000000000000
Retorno
	0: address: validatorAddress 0x0000000000000000000000000000000000000000
	1: uint256: reputation 0
	2: uint8: strategy 0
	3: uint256: price 0
	4: bool: exists false

----------------------------------------------
members - retorna dados do endereço da persona
----------------------------------------------
Entrada:
	0: address: personalAddress 0x1c5fBDf725C093c52A8464d226d7cf68c2605Ec0
Retorno:
	0: address: personalAddress 0x1c5fBDf725C093c52A8464d226d7cf68c2605Ec0
	1: bool: exists true

----------------------------------------------
infoCategories - Retorna os dados da categoria
----------------------------------------------
Entrada:
	0: address: personalAddress 0x1c5fBDf725C093c52A8464d226d7cf68c2605Ec0
Retorno:
	0: address: personalAddress 0x1c5fBDf725C093c52A8464d226d7cf68c2605Ec0
	1: bool: exists true








 