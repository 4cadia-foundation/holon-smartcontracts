const HolonStorage = artifacts.require("HolonStorage");
const Holon = artifacts.require("Holon");
const HolonPersona = artifacts.require("HolonPersona");
const HolonValidator = artifacts.require("HolonValidator");
const HolonConsumer = artifacts.require("HolonConsumer");

module.exports = async deployer => {
  await deployer.deploy(HolonStorage);
  await deployer.deploy(Holon, HolonStorage.address);
  await deployer.deploy(HolonPersona);
  await deployer.deploy(HolonConsumer);
};