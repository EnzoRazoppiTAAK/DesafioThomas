public with sharing class AssociatedLocationTriggerHelper {

    public static void handleInsertAccountTeamMember(List<AssociatedLocation__c> newRecordList){
        Set<Id> UsersIds = new Set<Id>();
        for(AssociatedLocation__c iAssociatedLocation : newRecordList){
            UsersIds.add(iAssociatedLocation.User__c);
        }
        List<AccountTeamMember> accountTeamMemberListToInsert = new List<AccountTeamMember>();
        List<AccountTeamMember> accountTeamMemberList = [
            SELECT AccountId, UserId 
            FROM AccountTeamMember 
            WHERE UserId IN: UsersIds
            ];
        for(AssociatedLocation__c inewAssociatedLocation : newRecordList){
            Boolean AlreadyExistInDatabase = false;
            for(AccountTeamMember iAccountTeamMember : accountTeamMemberList){
                if(iAccountTeamMember.UserId == inewAssociatedLocation.User__c && iAccountTeamMember.AccountId == inewAssociatedLocation.Account__c){
                    AlreadyExistInDatabase = true;
                }
            }

            if(!alreadyExistInDatabase) {
                Boolean AlreadyAdd = false;
                for(AccountTeamMember iAccountTeamMember : accountTeamMemberListToInsert){
                    if(iAccountTeamMember.UserId == inewAssociatedLocation.User__c && iAccountTeamMember.AccountId == inewAssociatedLocation.Account__c){
                        AlreadyAdd = true;
                    }
                }
                if(AlreadyAdd == false){
                    AccountTeamMember accountTeamMember = new AccountTeamMember(AccountId = inewAssociatedLocation.Account__c, UserId= inewAssociatedLocation.User__c);
                    accountTeamMemberListToInsert.add(accountTeamMember);
                }
            }
        }
        insert accountTeamMemberListToInsert;
    }
    
    public static void handleUpdateAccountTeamMember(List<AssociatedLocation__c> newRecordList, Map<Id, AssociatedLocation__c> oldRecordMap){
        Set<AssociatedLocation__c> newChangedAssociatedLocationSet = new Set<AssociatedLocation__c>();
        Set<AssociatedLocation__c> oldChangedAssociatedLocationSet = new Set<AssociatedLocation__c>();
        List<AccountTeamMember> accountTeamMemberListToInsert = new List<AccountTeamMember>();
        for(AssociatedLocation__c iNewAssociatedLocation : newRecordList){
            AssociatedLocation__c iOldAssociatedLocation = oldRecordMap.get(iNewAssociatedLocation.Id);
            if(iNewAssociatedLocation.User__c != iOldAssociatedLocation.User__c || iNewAssociatedLocation.Account__c != iOldAssociatedLocation.Account__c){
                newChangedAssociatedLocationSet.add(iNewAssociatedLocation);
                oldChangedAssociatedLocationSet.add(iOldAssociatedLocation);
            }
        }
        Map<String, AssociatedLocation__c> oldChangedAssociatedLocationMap = new Map<String, AssociatedLocation__c>();
        for(AssociatedLocation__c iAssociatedLocation : oldChangedAssociatedLocationSet){
            oldChangedAssociatedLocationMap.put(iAssociatedLocation.User__c+'-'+iAssociatedLocation.Account__c, iAssociatedLocation);
        }
        Set<Id> usersIdsToValidate = new Set<Id>();
        Set<Id> accountsIdsToValidate = new Set<Id>();
        for(AssociatedLocation__c iAssociatedLocation : newChangedAssociatedLocationSet){
            usersIdsToValidate.add(iAssociatedLocation.User__c);
            accountsIdsToValidate.add(iAssociatedLocation.Account__c);
        }
        List<AccountTeamMember> accountTeamMemberListToValidate = [
            SELECT AccountId, UserID 
            FROM AccountTeamMember 
            WHERE UserId IN: usersIdsToValidate 
            AND AccountId IN: accountsIdsToValidate
            ];
        for(AssociatedLocation__c iAssociatedLocation : newChangedAssociatedLocationSet){
            AccountTeamMember accountTeamMemberToValidate = new AccountTeamMember(AccountId = iAssociatedLocation.Account__c, UserId= iAssociatedLocation.User__c);
            if(!accountTeamMemberListToValidate.contains(accountTeamMemberToValidate)){
                accountTeamMemberListToInsert.add(accountTeamMemberToValidate);
            }
        }
        insert accountTeamMemberListToInsert;
        Set<Id> oldAccountsIdsToSearchDuplicates = new Set<Id>();
        Set<Id> oldUsersIdsToSearchDuplicates = new Set<Id>();
        for(AssociatedLocation__c iAssociatedLocation : oldChangedAssociatedLocationMap.values()){
            oldAccountsIdsToSearchDuplicates.add(iAssociatedLocation.Account__c);
            oldUsersIdsToSearchDuplicates.add(iAssociatedLocation.User__c);
        }
        List<AssociatedLocation__c> ExistAnotherInDatabase = [
            SELECT User__c, Account__c 
            FROM AssociatedLocation__c 
            WHERE User__c IN: oldUsersIdsToSearchDuplicates
            AND Account__c IN: oldAccountsIdsToSearchDuplicates
            ];
        for(AssociatedLocation__c iAssociatedLocation : ExistAnotherInDatabase){
            if(oldChangedAssociatedLocationMap.containsKey(iAssociatedLocation.User__c+'-'+iAssociatedLocation.Account__c)){
                oldChangedAssociatedLocationMap.remove(iAssociatedLocation.User__c+'-'+iAssociatedLocation.Account__c);
            }
        }
        Set<Id> accountsIdsToDelete = new Set<Id>();
        Set<Id> usersIdsToDelete = new Set<Id>();
        for(AssociatedLocation__c iAssociatedLocation : oldChangedAssociatedLocationMap.values()){
            accountsIdsToDelete.add(iAssociatedLocation.Account__c);
            usersIdsToDelete.add(iAssociatedLocation.User__c);
        }
        List<AccountTeamMember> accountTeamMemberList = [
            SELECT Id, UserId, AccountId 
            FROM AccountTeamMember 
            WHERE UserId IN: usersIdsToDelete 
            AND AccountId IN: accountsIdsToDelete
            ];
        List<AccountTeamMember> accountTeamMemberListToDelete = new List<AccountTeamMember>();
        for(AccountTeamMember iAccountTeamMember : accountTeamMemberList){
            if(oldChangedAssociatedLocationMap.containsKey(iAccountTeamMember.UserId+'-'+iAccountTeamMember.AccountId)){
                accountTeamMemberListToDelete.add(iAccountTeamMember);
            }
        }
        delete accountTeamMemberListToDelete;
    }

    public static void handleDeleteAccountTeamMember(List<AssociatedLocation__c> oldRecordList){
        List<AssociatedLocation__c> associatedLocationToDelete = new List<AssociatedLocation__c>();
        Map<String, AssociatedLocation__c> associatedLocationMap = new Map<String, AssociatedLocation__c>();
        for(AssociatedLocation__c iAssociatedLocation : oldRecordList){
            associatedLocationMap.put(iAssociatedLocation.User__c+'-'+iAssociatedLocation.Account__c, iAssociatedLocation);
        }
        Set<Id> oldUsersIds = new Set<Id>();
        Set<Id> oldAccountsIds = new Set<Id>();
        for(AssociatedLocation__c iAssociatedLocation : associatedLocationMap.values()){
            oldUsersIds.add(iAssociatedLocation.User__c);
            oldAccountsIds.add(iAssociatedLocation.Account__c);
        }
        List<AssociatedLocation__c> haveAnotherAssociatedLocation = [
            SELECT User__c, Account__c 
            FROM AssociatedLocation__c 
            WHERE User__c IN: oldUsersIds 
            AND Account__c IN: oldAccountsIds
        ];
        for(AssociatedLocation__c iAssociatedLocation : haveAnotherAssociatedLocation){
            if(associatedLocationMap.containsKey(iAssociatedLocation.User__c+'-'+iAssociatedLocation.Account__c)){
                associatedLocationMap.remove(iAssociatedLocation.User__c+'-'+iAssociatedLocation.Account__c);
            }
        }
        Set<Id> usersIdsToDelete = new Set<Id>();
        Set<Id> accountsIdsToDelete = new Set<Id>();
        for(AssociatedLocation__c iAssociatedLocation : associatedLocationMap.values()){
            usersIdsToDelete.add(iAssociatedLocation.User__c);
            accountsIdsToDelete.add(iAssociatedLocation.Account__c);
        }
        List<AccountTeamMember> accountTeamMemberList = [
            SELECT AccountId, UserID 
            FROM AccountTeamMember 
            WHERE UserId IN: usersIdsToDelete 
            AND AccountId IN: accountsIdsToDelete
            ];
        List<AccountTeamMember> accountTeamMemberListToDelete = new List<AccountTeamMember>();
        for (AccountTeamMember iAccountTeamMember : accountTeamMemberList){
            if(associatedLocationMap.containsKey(iAccountTeamMember.UserId+'-'+iAccountTeamMember.AccountId)){
                accountTeamMemberListToDelete.add(iAccountTeamMember);
            }
        }
        delete accountTeamMemberListToDelete;
    }
}