# Holon Comsumer

Holon Comsumer is a smart contract part where the a Consumer gets data about Persona

### Smart contracts data
| Smart Contract| Description | 
| ------ | ------ | 
| Holon | Holon Data. Name, Email, Age, etc. | 
| Holon Storage | Persona Data. Name, Email, Age, etc. | 
| Persona | Persona Data. Name, Email, Age, etc. |  
| Validator | Validator Data. Name, Email, Age, etc. | 
| Consumer | Consumer functions.. |  

## Methods / Functions
### askPersonaField
```sh
Set a Persona's field to get information
params:
- address personaAddress
- string memory fieldName
returns
```
### isPersonaFieldAllowed
```sh
Returns if Persona's field is allowed by a Consumer
params:
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
