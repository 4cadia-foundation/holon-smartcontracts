const HolonStorage = artifacts.require("HolonStorage");
const Holon = artifacts.require("Holon");
const HolonPersona = artifacts.require("HolonPersona");
const HolonValidator = artifacts.require("HolonValidator");
const HolonConsumer = artifacts.require("HolonConsumer");

module.exports = async deployer => {
  await deployer.deploy(HolonStorage);
  await deployer.deploy(Holon);
  await deployer.deploy(HolonPersona, HolonStorage.address);
  await deployer.deploy(HolonValidator, HolonStorage.address);
  await deployer.deploy(HolonConsumer, HolonStorage.address);
};