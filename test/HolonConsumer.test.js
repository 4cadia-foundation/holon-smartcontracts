const truffleAssert = require('truffle-assertions')
const HolonStorageSC = artifacts.require('HolonStorage')
const HolonConsumerSC = artifacts.require('HolonConsumer')
const HolonSC = artifacts.require('Holon')

contract('HolonConsumer', (accounts) => {
    //accounts created by ganache-cli

    let holonConsumer
    let holonStorage
    let owner = accounts[0]
    let personaAddress = accounts[1]
    let personaAddress2 = accounts[4]
    let consumerAddress =  accounts[2]
    let otherConsumerAddress = accounts[3]

    beforeEach('setup for each test', async () => {
        holonStorage = await HolonStorageSC.deployed({from: owner})
        holonConsumer = await HolonConsumerSC.deployed({from: holonStorage})
        holon = await HolonSC.deployed({from: owner})
        await holonStorage.addPersona('Atlas Quantum', 0, consumerAddress)
        await holonStorage.addPersona('Olivia Watson', 0, personaAddress)
    })

    it('Deploying HolonConsumer contract properly...', async () => {
        assert(holonConsumer.address != '');
    })

    describe('askPersonaField', () => {
        it('Ask to Persona if she wants share your data with consumer', async() => {
            const askPersonaField = await holonConsumer.askPersonaField(personaAddress, 'name', {from: consumerAddress}) 
            truffleAssert.passes(askPersonaField)
        })
        
        it('Fail when field not exist', async() => {
            const personaFieldExists = await holonStorage.personaFieldExists(personaAddress, 'CPF')
            assert.equal(personaFieldExists, false)
        })
        
        it('Fail when Persona not exist', async() => {
            const isPersona = await holonStorage.isPersona(personaAddress2)
            assert.equal(isPersona, false)
        })   
    })

    describe('isPersonaFieldAllowed', () => {
        it('Passes when Persona allows the consumer access to his information', async() => {
            await holonConsumer.askPersonaField(personaAddress, 'name', {from: consumerAddress})
            await holonStorage.allowConsumer(personaAddress, consumerAddress, "name", true)
            const isPersonaFieldAllowed = await holonConsumer.isPersonaFieldAllowed(personaAddress, 'name', {from: consumerAddress}) 
            assert.equal(isPersonaFieldAllowed, true)
        })

        it('Fails when Persona declines the consumer access to his information', async() => {
            await holonConsumer.askPersonaField(personaAddress, 'name', {from: consumerAddress})
            await holonStorage.allowConsumer(personaAddress, consumerAddress, "name", false)
            const isPersonaFieldAllowed = await holonConsumer.isPersonaFieldAllowed(personaAddress, 'name', {from: consumerAddress}) 
            assert.equal(isPersonaFieldAllowed, false)
        })

        it('Fails when a different address try access the Persona info', async() => {
            await holonConsumer.askPersonaField(personaAddress, 'name', {from: consumerAddress})
            await holonStorage.allowConsumer(personaAddress, consumerAddress, 'name', true)
            const isPersonaFieldAllowed = await holonConsumer.isPersonaFieldAllowed(personaAddress, 'name', {from: otherConsumerAddress}) 
            assert.equal(isPersonaFieldAllowed, false)
        })
    })

    describe('getPersonaField', () => {
        it('Share info with allowed consumer', async() => {
            await holonConsumer.askPersonaField(personaAddress, 'name', {from: consumerAddress})
            await holonStorage.allowConsumer(personaAddress, consumerAddress, 'name', true)
            const getPersonaField = await holonConsumer.getPersonaField(personaAddress, 'name', {from: consumerAddress})
            truffleAssert.passes(getPersonaField)
        })
    })
})