# Salesforce-ChatGPT

Welcome to my attempt at a Salesforce-ChatGPT integration!  This will start off as REST callouts from Apex, but could evolve into an inbound call from ChatGPT or other OpenAI product into Salesforce.  I even asked ChatGPT [how to write a Salesforce integration](ChatGPT-Instructions.md)... let's see if it got it right!

# Sample Script
I've written only a few commands so far.

## Describe Models and Insert into SObjects
This will get a list of AI models and insert them as custom SObjects Model__c (will duplicate if already exist)
```
String modelListResultJson = ChatGPT.listModels();
List<Database.SaveResult> saveResults = ChatGPT.insertModels(modelListResultJson);
for(Database.SaveResult sr : saveResults) {a
    System.debug(sr);
}
System.debug('saveResults.size(): ' + saveResults.size());

```

## Generate Image from Prompt
This will take a given prompt, generate an image, and save it to Salesforce as a ContentDocument/ContentVersion
```
String prompt = '[Insert your descriptive image prompt here]';
String imgResJson = ChatGPT.createImage(prompt);
System.debug(imgResJson);

List<ContentVersion> imagesSaved = ChatGPT.saveImages(imgResJson);
for(ContentVersion cv : imagesSaved) {
    System.debug(cv);
}

```
Since this ContentDocument is not in a Library or associated with any records, here's a query that will show you ContentDocuments in your org so you can open the Detail Page from the Developer Console Query Editor and view it in your org.
```
SELECT Id, Title, CreatedDate FROM ContentDocument
```


# Standard SFDX README template
And below you'll find the standard SalesforceDX readme template we all know and love

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
