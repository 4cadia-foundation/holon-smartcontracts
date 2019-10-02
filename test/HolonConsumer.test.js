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
    let consumerAddress2 = accounts[3]

    beforeEach('setup for each test', async () => {
        holonStorage = await HolonStorageSC.deployed({from: owner})
        holonConsumer = await HolonConsumerSC.deployed({from: holonStorage})
        holon = await HolonSC.deployed({from: owner})
    })

    it('Deploying HolonConsumer contract properly...', async () => {
        assert(holonConsumer.address != '');
    })

    describe('askPersonaField', () => {

        it('Ask to persona if she wants share your data with consumer', async() => {
            await holonStorage.addPersona('Vic', 0, personaAddress)
            await holonStorage.addPersona('Atlas Quantum', 0, consumerAddress)
            const askPersonaField = await holonConsumer.askPersonaField(personaAddress, 'name', {from: consumerAddress}) 
            truffleAssert.passes(askPersonaField)
        })
        
        it('Fail when field not exist', async() => {
            await holonStorage.addPersona('Vic', 0, personaAddress)
            await holonStorage.addPersona('Atlas Quantum', 0, consumerAddress)
            const personaFieldExists = await holonStorage.personaFieldExists(personaAddress, 'CPF')
            assert.equal(personaFieldExists, false)
        })
        
        it('Fail when persona not exist', async() => {
            await holonStorage.addPersona('Atlas Quantum', 0, consumerAddress)
            const isPersona = await holonStorage.isPersona(personaAddress2)
            assert.equal(isPersona, false)
        })
        
    })
})


