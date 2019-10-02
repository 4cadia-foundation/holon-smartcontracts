const Holon = artifacts.require('Holon');
const HolonStorage = artifacts.require('HolonStorage');
const HolonPersona = artifacts.require('HolonPersona');
const HolonValidator = artifacts.require('HolonValidator');
var owner = null;
var owner2 = null;
var holon = null;
var holonValidator = null;

var accountPersona = null;
var accountWithoutBalance =  null;
var accountWithBalance = null; 
var accountValidator = null;

// PersonaStorage
contract('HolonStorage', (accounts) => {
  before( async () => {
    holonStorage = await HolonStorage.deployed({from: owner});
  });
  it('1 - Should deploy HolonStorage contract properly...', async () =>{
    assert(holonStorage.address != '');
  });
})

// Holon
contract('Holon', (accounts) => {
  owner = accounts[0];
  holon = null;
  holonValidator = null;

  accountPersona = accounts[1];
  accountValidatorWithBalance = accounts[2];
  accountValidatorWithoutBalance = accounts[3];
  accountValidator = accounts[4];

 before( async () => {
    holon = await Holon.deployed({from: holonStorage.address});
 });
 it('2 - Should deploy Holon contract properly...', async () =>{
  assert(holon.address != '');
  });
})

// Persona
contract('HolonPersona', (accounts) => {
  before( async () => {
    holonPersona = await HolonPersona.deployed({from: holonStorage.address});

  });
  it('3 - Should deploy HolonPersona contract properly...', async () =>{
    assert(holonPersona.address != '');
  });
  it('3.1 - Add Persona Only', async () =>{
    await holonPersona.addPersona('Persona Only', '0', {from: accountPersona});
    assert.isOk(holonStorage.isPersona(accountPersona));
  });

})
// Validator
contract('HolonValidator', (accounts) => {
    let holonOwner = accounts[0];  
    before( async () => {
        holonValidator = await HolonValidator.deployed({from: holonStorage.address});
    } );

    it('4 - Should deploy HolonValidator contract properly...', async () =>{
        assert(holonValidator.address != '');
    });

  
    it('4.1 - AddValidator', async() => {
      try {
            // Add Persona (Persona only)
            await holonPersona.addPersona('Persona', '0', {from: accountPersona}); 
            // Add Persona Field
            await holonPersona.addPersonaField('email','accountPersona@email.com',0,'Personal Data','email', {from: accountPersona })
            // Add Persona (Validator)
            await holonPersona.addPersona('Validator', '0', {from: accountValidator}); 
            // Add Validator
            assert.isOk(await holonValidator.addValidator(1, 0, {from: accountValidator, value: 1000}));
        } catch (e) {
          assert.fail(null, null, e + `: ${accountValidator} not addValidator`);
        }
    });

  
    it('4.2 - Validate', async() => {
        try {
            // Ask to Validate
              await holonPersona.askToValidate(accountValidator,'email','UrlEmail_',{from: accountPersona , value: 0});
            // Validate
              assert.isOk(await holonValidator.validate(accountPersona, 'email',2, {from: accountValidator, value: 0}));
  
          } catch (e) {
            assert.fail(null, null, e + `$: {accountValidator} not Validate`);
          }
      });

    //------------------------------


    it('5 - Owner account: Should be OWNER to set a validators Stake...', async () => {
      try {
            assert.isOk(await holonValidator.setStake(0, {from: holonOwner}));
          } catch (e) {
            assert.fail(null, null, e + `: ${holonOwner} is not owner`)
          }
    });

    it('6 - getPendingValidations...', async () => {
      try {
            assert.isOk(await holonValidator.getPendingValidations({from: accountValidator}));
          } catch (e) {
            assert.fail(null, null, e + `: ${accountValidator} has no pending validations`)
          }
    });

    it('7 - getValidators...', async () => {
      try {
            assert.isOk(await holonValidator.getValidators({from: accountValidator}));
          } catch (e) {
            assert.fail(null, null, e + `: ${accountValidator} has no validators`)
          }
    });

})