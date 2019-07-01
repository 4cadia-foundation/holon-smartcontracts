package main

import (
	"bufio"
	"context"
	"flag"
	"log"
	"math/big"
	"os"

	"bitbucket.org/janusplatform/holon.contracts/pistolaholon/proxycontract"

	"github.com/jeffprestes/goethereumhelper"
)

var isZoeiraModeOn bool
var stageStep int

func main() {

	stage := flag.Int("stage", 10, "Defines the limit where the Bot should reach")
	showHelp := flag.Bool("help", false, "Show Bot's help")
	zueiraMode := flag.Bool("zueira", false, "Show Bot's help")
	configPath := flag.String("destConfigFile", "/home/jeffprestes/projetos/", "Defines where plugin's config file is")
	flag.Parse()

	isZoeiraModeOn = *zueiraMode
	stageStep = *stage

	file, err := os.Open("banner3.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	for scanner.Scan() { // internally, it advances token based on sperator
		log.Println(scanner.Text()) // token in unicode-char
	}
	log.Println("")
	log.Println("                                Bravo Pistola Mock Data Generator")
	log.Println("")

	if *showHelp {
		showHelpMessage()
	}

	if isZoeiraModeOn {
		log.Println("")
		log.Println("Senta que lá vem história....")
		log.Println("")
	}

	log.Println("ConfigPath ", *configPath)

	log.Println("")
	log.Println("Connecting to Pistola Local Network...")
	log.Println("")
	// client, err := goethereumhelper.GetCustomNetworkClient("http://127.0.0.1:8545")
	client, err := goethereumhelper.GetRinkebyClient()
	if err != nil {
		log.Fatalln("Error: ", err.Error())
		return
	}
	networkID, err := client.NetworkID(context.Background())
	if err != nil {
		log.Fatalln("Error getting network ID: ", err.Error())
		return
	}
	log.Println("Connected to network ID ", networkID)

	log.Println("")
	log.Println("Loading testing data...")
	log.Println("")
	err = loadConfig()
	if err != nil {
		log.Fatalln("Error: ", err.Error())
		return
	}
	log.Println("Accounts loaded.")
	// log.Printf("Accounts: %#v\n", HolonConfigData)

	log.Println("Deploying contract...")
	auth, err := getTransactor(client, "masteraccount")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	contractAddr, trx, holon, err := proxycontract.DeployHolon(auth, client)
	if err != nil {
		log.Fatalln("It was not possible to deploy the contract. Error: ", err.Error())
	}
	log.Println("Contract deployed at: ", contractAddr.Hex())
	txReceipt, err := goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to deploy the contract. Error: ", err.Error())
	}
	log.Printf("Contract was succefully deployed at: %s with status %d\n", contractAddr.Hex(), txReceipt.Status)

	stageStep = moveFowardStage(stageStep)

	/*

		Adding info category

	*/
	testAddInfoCategory(client, holon)

	stageStep = moveFowardStage(stageStep)

	/*

		Adding new Persona

	*/
	log.Println("Adding Persona", HolonConfigData.Personas[0].Address.Hex(), "....")
	auth, err = getTransactor(client, "persona01")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	trx, err = holon.AddPersona(auth, big.NewInt(1), uint8(0), "email", "vicvictoriabarcelona@gmail.com", big.NewInt(0))
	if err != nil {
		log.Fatalln("It was not possible to submit a new persona. Error: ", err.Error())
		return
	}
	txReceipt, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to add a new persona. Error: ", err.Error())
		return
	}
	persona01, err := holon.Members(nil, HolonConfigData.Personas[0].Address)
	if err != nil {
		log.Fatalln("It was not possible to get the new added persona. Error: ", err.Error())
		return
	}
	log.Printf("Persona Address %s\n", persona01.PersonalAddress.Hex())
	/*

		Querying Persona's data

	*/
	pData, err := queryPersonaData(holon, persona01.PersonalAddress, "email")
	if err != nil {
		log.Fatalln("It was not possible to get the email from the new added persona. Error: ", err.Error())
		return
	}

	stageStep = moveFowardStage(stageStep)

	/*

		Adding data

	*/
	log.Println("Adding Data to Persona", HolonConfigData.Personas[0].Address.Hex(), "....")
	auth, err = getTransactor(client, "persona01")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	trx, err = holon.AddData(auth, big.NewInt(1), uint8(0), "name", "Victoria Almodovar", big.NewInt(0))
	if err != nil {
		log.Fatalln("It was not possible to submit a new data to a persona. Error: ", err.Error())
		return
	}
	txReceipt, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to add a new data to a persona. Error: ", err.Error())
		return
	}
	pData, err = queryPersonaData(holon, persona01.PersonalAddress, "name")
	if err != nil {
		log.Fatalln("It was not possible to get the email from the new added persona. Error: ", err.Error())
		return
	}
	log.Printf("Persona %s name included to her profile %#v\n", HolonConfigData.Personas[0].Address.Hex(), pData)

	stageStep = moveFowardStage(stageStep)

	/*

		Adding new Validator as Persona

	*/
	log.Println("Adding Validator as Persona", HolonConfigData.Validators[0].Address.Hex(), "....")
	auth, err = getTransactor(client, "validator01")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	trx, err = holon.AddPersona(auth, big.NewInt(1), uint8(0), "email", "compliance@atlasproj.com", big.NewInt(0))
	if err != nil {
		log.Fatalln("It was not possible to submit a new persona. Error: ", err.Error())
		return
	}
	txReceipt, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to add a new persona. Error: ", err.Error())
		return
	}
	validatorPersona01, err := holon.Members(nil, HolonConfigData.Validators[0].Address)
	if err != nil {
		log.Fatalln("It was not possible to get the new added persona. Error: ", err.Error())
		return
	}
	/*

		Querying Validator's data

	*/
	pData, err = queryPersonaData(holon, validatorPersona01.PersonalAddress, "email")
	if err != nil {
		log.Fatalln("It was not possible to get the email from the new added persona. Error: ", err.Error())
		return
	}
	log.Printf("Validator's Data %#v\n", pData)

	stageStep = moveFowardStage(stageStep)

	/*

		Making the second Persona as Validator

	*/
	log.Println("Adding Validator as Validator", HolonConfigData.Validators[0].Address.Hex(), "....")
	auth, err = getTransactor(client, "validator01")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	auth.Value = big.NewInt(1000000000000)
	trx, err = holon.AddValidator(auth, 0, big.NewInt(0))
	if err != nil {
		log.Fatalln("It was not possible to submit a new validator. Error: ", err.Error())
		return
	}
	txReceipt, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to add a new validator. Error: ", err.Error())
		return
	}
	validator01, err := holon.HolonValidators(nil, validatorPersona01.PersonalAddress)
	if err != nil {
		log.Fatalln("It was not possible to get new validator's data. Error: ", err.Error())
		return
	}
	log.Printf("Validator added %#v\n", validator01)

	if isZoeiraModeOn {
		log.Println("")
		log.Println("Ainda tá aí? Dorme não....")
		log.Println("")
	}

	stageStep = moveFowardStage(stageStep)

	/*

		Persona asks to Validator to validate his data

	*/
	log.Printf("Persona %s asking to validator %s to validate her email...\n", HolonConfigData.Personas[0].Address.Hex(), HolonConfigData.Validators[0].Address.Hex())
	auth, err = getTransactor(client, "persona01")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	trx, err = holon.AskToValidate(auth, validatorPersona01.PersonalAddress, 0, "email", "vicvictoriabarcelona@gmail.com")
	if err != nil {
		log.Fatalln("It was not possible to submit a new validator. Error: ", err.Error())
		return
	}
	_, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to persona to ask to a validator to validate a data. Error: ", err.Error())
		return
	}

	stageStep = moveFowardStage(stageStep)

	/*

		Validator validate a data

	*/
	log.Printf("Validator %s validating persona %s email\n", HolonConfigData.Validators[0].Address.Hex(), HolonConfigData.Personas[0].Address.Hex())
	auth, err = getTransactor(client, "validator01")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	trx, err = holon.Validate(auth, persona01.PersonalAddress, "email", 0)
	if err != nil {
		log.Fatalln("It was not possible to submit a new validation. Error: ", err.Error())
		return
	}
	_, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to validator to validate persona's data. Error: ", err.Error())
		return
	}
	log.Println("Data validated.")
	log.Println("Querying persona's profile to check the changes...")
	pData, err = queryPersonaData(holon, persona01.PersonalAddress, "email")
	if err != nil {
		log.Fatalln("It was not possible to get the email from the new added persona. Error: ", err.Error())
		return
	}
	log.Printf("Persona %s email data record after validation %#v\n", HolonConfigData.Personas[0].Address.Hex(), pData)
	/*

		Querying Validator's profile after the validation

	*/
	log.Println("Querying Validator's profile after the validation...")
	validator01, err = holon.HolonValidators(nil, validatorPersona01.PersonalAddress)
	if err != nil {
		log.Fatalln("It was not possible to get new validator's data. Error: ", err.Error())
		return
	}
	log.Printf("Validator new status %#v\n", validator01)

	stageStep = moveFowardStage(stageStep)

	/*

		Consumer asking data to persona

	*/
	log.Printf("Consumer %s asking to persona %s to access her email\n", HolonConfigData.Consumers[0].Address.Hex(), HolonConfigData.Personas[0].Address.Hex())
	auth, err = getTransactor(client, "consumer01")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	trx, err = holon.AskDecryptedData(auth, persona01.PersonalAddress, "email")
	if err != nil {
		log.Fatalln("It was not possible to submit a new data order to persona. Error: ", err.Error())
		return
	}
	_, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to consumer to ask persona's data. Error: ", err.Error())
		return
	}
	log.Println("Data ordered.")

	stageStep = moveFowardStage(stageStep)

	/*

		Persona delivering data to consumer

	*/
	log.Printf("Persona %s delivering email data to consumer %s\n", HolonConfigData.Personas[0].Address.Hex(), HolonConfigData.Consumers[0].Address.Hex())
	auth, err = getTransactor(client, "persona01")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	trx, err = holon.DeliverDecryptedData(auth, true, HolonConfigData.Consumers[0].Address, 0, "email", "vicvictoriabarcelona@gmail.com")
	if err != nil {
		log.Fatalln("It was not possible to submit the data ordered by the consumer. Error: ", err.Error())
		return
	}
	_, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
	if err != nil {
		log.Fatalln("It was not possible to consumer to ask persona's data. Error: ", err.Error())
		return
	}
	log.Println("Data delivered.")

	if isZoeiraModeOn {
		log.Println("")
		log.Println("É TETRA!! É TETRA!! É TETRA!! É TETRA!! É TETRA!! É TETRA!! É TETRA!! É TETRA!! É TETRA!! É TETRA!! É TETRA!! É TETRA!!")
		log.Println("")
	}

	finishTests()
}

func finishTests() {
	log.Println("")
	log.Println("Tests finished.")
	log.Println("")
	os.Exit(0)
}

func moveFowardStage(stage int) int {
	// log.Println(" ******* [moveFowardStage] antes ", stage)
	stage--
	if stage == 0 {
		finishTests()
	}
	// log.Println(" ******* [moveFowardStage] depois ", stage)
	return stage
}

func showHelpMessage() {
	log.Println(" ")
	log.Println(" Parameter options: ")
	log.Println(" ")
	log.Println("--stage defines the point where you want the Bot's generated mock data")
	log.Println("  There are 10 steps: ")
	log.Println("    _ 01 Deploy contract")
	log.Println("    _ 02 Add info category personal data")
	log.Println("    _ 03 Add new Persona")
	log.Println("    _ 04 Add data to the new Persona")
	log.Println("    _ 05 Add new Persona to be a Validator")
	log.Println("    _ 06 Transforming new Persona into Validator")
	log.Println("    _ 07 Persona asks to Validator to validate her data")
	log.Println("    _ 08 Validator validates her data")
	log.Println("    _ 09 Consumer asks to Persona to consume her data")
	log.Println("    _ 10 Persona delivers her data to Consumer")
	log.Println(" ")
	log.Println("--configFile Defines where plugin's config file is")
	log.Println(" ")
	log.Println("--zoeira Defines whether jokes message should appear while Bot is working")
	log.Println(" ")
	os.Exit(0)
}
