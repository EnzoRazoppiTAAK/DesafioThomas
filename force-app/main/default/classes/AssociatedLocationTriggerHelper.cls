public with sharing class AssociatedLocationTriggerHelper {

    public static void handleInsertAccountTeamMember(List<AssociatedLocation__c> newRecordList){
        
        List<Id> UsersIds = new List<Id>();
        for(AssociatedLocation__c a : newRecordList){
            UsersIds.add(a.User__c);
        }

        List<AccountTeamMember> accountTeamMemberListToInsert = new List<AccountTeamMember>();
        List<AccountTeamMember> accountTeamMemberList = [SELECT AccountId, UserId FROM AccountTeamMember WHERE UserId IN: UsersIds];
        for(AssociatedLocation__c a : newRecordList){
            Boolean AlreadyExist = false;
            for(AccountTeamMember atm : accountTeamMemberList){
                if(atm.UserId == a.User__c && atm.AccountId == a.Account__c){
                    AlreadyExist = true;
                }
            }
            if(AlreadyExist == false){
                AccountTeamMember atm = new AccountTeamMember(AccountId = a.Account__c, UserId= a.User__c);
                accountTeamMemberListToInsert.add(atm);
            }
        }
        insert accountTeamMemberListToInsert;
    }
    public static void handleUpdateAccountTeamMember(List<AssociatedLocation__c> newRecordList, Map<Id, AssociatedLocation__c> oldRecordMap){
        List<AccountTeamMember> accountTeamMemberListToInsert = new List<AccountTeamMember>();
        for(Associated_Location__c ALNew : newRecordList){
            Boolean changed = false;
            for(Associated_Location__c ALOld: oldAssociatedLocationList){
                if(ALNew.User__c != ALOld.User__c && ALNew.Name == ALOld.Name){
                    changed = true;
                }
            }
            if(changed == true){
                accountTeamMemberListToInsert.add(new AccountTeamMember(AccountId = ALNew.Account__c, UserId= ALNew.User__c));
            }
        }
        insert accountTeamMemberListToInsert;
        Associated_Location__c AL = [SELECT Account__c, User__c FROM Associated_Location__c WHERE User__c LIMIT 1];
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

        for (AccountTeamMember atm : accountTeamMemberList){
            for(AssociatedLocation__c a : oldRecordList){
                if(atm.AccountId == a.Account__c && atm.UserId == a.User__c){
                    accountTeamMemberListToDelete.add(atm);
                    break;
                }
            }
        }
        delete accountTeamMemberListToDelete;
    }
}