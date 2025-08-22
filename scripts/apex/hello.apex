// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Account account = new Account(Name='Enzo');
insert account;

AssociatedLocation__c AL = new AssociatedLocation__c(Account__c = account.Id, User__c = UserInfo.getUserId());
insert AL;