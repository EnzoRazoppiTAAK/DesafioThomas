public with sharing class AssociatedLocationTriggerHelper {

    public static void handleInsertAccountTeamMember(List<AssociatedLocation__c> newRecordList) {
        List<Id> usersIds = new List<Id>();
        for(AssociatedLocation__c iAssociatedLocation : newRecordList) {
            usersIds.add(iAssociatedLocation.User__c);
        }

        List<AccountTeamMember> accountTeamMemberListToInsert = new List<AccountTeamMember>();
        List<AccountTeamMember> accountTeamMemberList = [SELECT AccountId, UserId FROM AccountTeamMember WHERE UserId IN: usersIds];
        for(AssociatedLocation__c newAL : newRecordList) {
            Boolean alreadyExistInDatabase = false;
            for(AccountTeamMember iAccountTeamMember : accountTeamMemberList) {
                if(iAccountTeamMember.UserId == newAL.User__c && iAccountTeamMember.AccountId == newAL.Account__c){
                    alreadyExistInDatabase = true;
                }
            }

            if(!alreadyExistInDatabase) {
                Boolean AlreadyAdd = false;
                for(AccountTeamMember iAccountTeamMember : accountTeamMemberListToInsert) {
                    if(iAccountTeamMember.UserId == newAL.User__c && iAccountTeamMember.AccountId == newAL.Account__c){
                        AlreadyAdd = true;
                    }
                }
                if(AlreadyAdd == false){
                    AccountTeamMember atm = new AccountTeamMember(AccountId = newAL.Account__c, UserId= newAL.User__c);
                    accountTeamMemberListToInsert.add(atm);
                }
            }
        }
        insert accountTeamMemberListToInsert;
    }
    
    public static void handleUpdateAccountTeamMember(List<AssociatedLocation__c> newRecordList, Map<Id, AssociatedLocation__c> oldRecordMap){
        //refazer!!!
        List<AccountTeamMember> accountTeamMemberListToInsert = new List<AccountTeamMember>();
        List<AssociatedLocation__c> changedAssociatedLocationList = new List<AssociatedLocation__c>();
        List<AssociatedLocation__c> associatedLocationListToDelete = new List<AssociatedLocation__c>();
        List<AccountTeamMember> accountTeamMemberListToDelete = new List<AccountTeamMember>();
        
        for(AssociatedLocation__c newAL : newRecordList) {
            Boolean changed = false;
            for(AssociatedLocation__c OldAL: oldRecordMap.values()){
                if(newAL.Id == OldAL.Id && newAL.User__c != OldAL.User__c){
                    changed = true;
                    changedAssociatedLocationList.add(OldAL);
                }
            }
            if(changed == true){
                accountTeamMemberListToInsert.add(new AccountTeamMember(AccountId = newAL.Account__c, UserId= newAL.User__c));
            }
        }

        //Etapa 3

        List<AssociatedLocation__c> alThatHaveChangedAccounts = new List<AssociatedLocation__c>();
        List<AssociatedLocation__c> newALs = new List<AssociatedLocation__c>();
        List<Id> oldAccountsIds = new List<Id>();
        List<Id> oldUsersIds = new List<Id>();

        for(AssociatedLocation__c newAL : newRecordList){
            Boolean changed = false;
            for(AssociatedLocation__c oldAL: oldRecordMap.values()){
                if(newAL.Id == oldAL.Id && newAL.Account__c != oldAL.Account__c){
                    changed = true;
                    alThatHaveChangedAccounts.add(oldAL);
                    oldAccountsIds.add(oldAL.Account__c);
                    oldUsersIds.add(oldAL.User__c);
                    newALs.add(newAL);
                }
            }
        }
        List<AssociatedLocation__c> searchForOldUsersAndAccounts = [SELECT Account__c, User__c FROM AssociatedLocation__c 
        WHERE Account__c IN: oldAccountsIds AND User__c IN: oldUsersIds];
        for(AssociatedLocation__c AL: alThatHaveChangedAccounts){
            Boolean haveAnotherLA = false;
            for(AssociatedLocation__c search: searchForOldUsersAndAccounts){
                if(AL.Account__c == search.Account__c && AL.User__c == search.User__c){
                    haveAnotherLA = true;
                }
            }
            if(haveAnotherLA == false){
                associatedLocationListToDelete.add(AL);
                for(AssociatedLocation__c newAL: newALs){
                    if(AL.Id == newAL.Id){
                        accountTeamMemberListToInsert.add(new AccountTeamMember(AccountId = newAL.Account__c, UserId= newAL.User__c));
                    }
                }
            }
        }
        List<AccountTeamMember> accountTeamMemberList1 = [SELECT AccountId, UserId FROM AccountTeamMember 
        WHERE AccountId IN: oldAccountsIds AND UserId IN: oldUsersIds];
        for(AssociatedLocation__c AL : associatedLocationListToDelete){
            for(AccountTeamMember accountTeamMember : accountTeamMemberList1){
                if(accountTeamMember.AccountId == AL.Account__c && accountTeamMember.UserId == AL.User__c){
                    accountTeamMemberListToDelete.add(accountTeamMember);
                }
            }
        }
        //fim da etapa 3

        insert accountTeamMemberListToInsert;

        List<Id> UsersIds = new List<Id>();
        for(AssociatedLocation__c AL : changedAssociatedLocationList){
            UsersIds.add(AL.User__c);
        }
        List<Id> AccountsIds = new List<Id>();
        for(AssociatedLocation__c AL : changedAssociatedLocationList){
            AccountsIds.add(AL.Account__c);
        }

        List<AssociatedLocation__c> haveOtherLA = [SELECT Account__c, User__c FROM AssociatedLocation__c 
        WHERE Account__c IN: AccountsIds AND User__c IN: UsersIds];
        for(AssociatedLocation__c changedAL : changedAssociatedLocationList){
            Boolean haveAnotherLA = false;
            for(AssociatedLocation__c AL : haveOtherLA){
                if(changedAL.Account__c == AL.Account__c && changedAL.User__c == AL.User__c){
                    haveAnotherLA = true;
                }
            }
            if(haveAnotherLA == false){
                associatedLocationListToDelete.add(changedAL);
            }
        }
        List<AccountTeamMember> accountTeamMemberList2 = [SELECT AccountId, UserId FROM AccountTeamMember 
        WHERE AccountId IN: AccountsIds AND UserId IN: UsersIds];
        for(AssociatedLocation__c AL : associatedLocationListToDelete){
            for(AccountTeamMember accountTeamMember : accountTeamMemberList2){
                if(accountTeamMember.AccountId == AL.Account__c && accountTeamMember.UserId == AL.User__c){
                    accountTeamMemberListToDelete.add(accountTeamMember);
                }
            }
        }

        delete accountTeamMemberListToDelete;
    }

    public static void handleDeleteAccountTeamMember(List<AssociatedLocation__c> oldRecordList){
        List<Id> UsersIds = new List<Id>();
        for(AssociatedLocation__c a : oldRecordList){
            UsersIds.add(a.User__c);
        }
        List<Id> AccountsIds = new List<Id>();
        for(AssociatedLocation__c a : oldRecordList){
            AccountsIds.add(a.Account__c);
        }

        List<AccountTeamMember> accountTeamMemberList = [SELECT AccountId, UserID FROM AccountTeamMember 
        WHERE UserId IN: UsersIds AND AccountId IN: AccountsIds];

        List<AccountTeamMember> accountTeamMemberListToDelete = new List<AccountTeamMember>();

        for (AccountTeamMember accountTeamMember : accountTeamMemberList){
            for(AssociatedLocation__c oldAL : oldRecordList){
                if(accountTeamMember.AccountId == oldAL.Account__c && accountTeamMember.UserId == oldAL.User__c){
                    accountTeamMemberListToDelete.add(accountTeamMember);
                    break;
                }
            }
        }
        delete accountTeamMemberListToDelete;
    }
}