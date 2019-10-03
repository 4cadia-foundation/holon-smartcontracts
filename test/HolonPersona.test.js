const HolonPersona = require('../contracts/HolonPersona.sol');
const truffleAssertions = require('truffle-assertions');

contract('HolonPersona', accounts => {
    beforeEach(async () => {
        this.contract = await HolonPersona.new(name, price, 0)
        this.accountOwner = accounts[0];
    });
    describe('Add Persona', () => {
        it('should persona not exist',async () => {
            const persona = await this.contract(name, price);
            await truffleAssertions.passes(persona.name);
        });
    });
 })