 const HolonStorage = artifacts.require('HolonStorage.sol');
 const HolonPersona = artifacts.require('HolonPersona.sol');
 const truffleAssertions = require('truffle-assertions');

 contract('HolonPersona', (accounts) => {

    let owner = accounts[0]
    let personaAddress = accounts[1]
    let personaAddress2 = accounts[2]

    beforeEach('setup for each test', async () => {
        holonStorage = await HolonStorage.deployed({from: owner})
        holonPersona = await HolonPersona.deployed({from: owner})
    })

    describe('Add Persona', () => {

        it('Deploying HolonStorage contract properly...', async () =>{
            assert(HolonPersona.personaAddress != '');
        })
    
        it('Persona not exist', async () => {
            const isPersona = await holonStorage.isPersona(personaAddress)
            assert.equal(isPersona, false)
        })
    
        it('Persona add', async () => {
            const addPersona = await holonPersona.addPersona('Yasmim', 0)
            truffleAssertions.passes(addPersona);
            
        })
    
        it('Persona exist', async () => {
            const addPersona = await holonPersona.addPersona('Yasmim', 0, {from: personaAddress} )
            truffleAssertions.passes(addPersona);
            const isPersona = await holonStorage.isPersona(personaAddress)
            assert.equal(isPersona, true)
    
        })
    })

    describe('AddPersonaField', () => {
    
        it('Should add info', async () => {
            const addPersonaField = await holonPersona.addPersonaField('Vic', '8172812256', 0, 'Plain text', 'Personal info')
            truffleAssertions.passes(addPersonaField);
        })
    })
 })