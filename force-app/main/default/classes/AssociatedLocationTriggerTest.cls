@isTest
private with sharing class AssociatedLocationTriggerTest {

    @isTest
    static void testAssociatedLocationInsert() {
        AssociatedLocation__c AssociatedLocation1 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));
        AssociatedLocation__c AssociatedLocation2 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));
        List<AssociatedLocation__c> AssociatedLocations = new List<AssociatedLocation__c>{AssociatedLocation1, AssociatedLocation2};

        insert AssociatedLocations;

        List<AccountTeamMember> accountTeamMemberList = [SELECT Id, UserId, AccountId FROM AccountTeamMember ];
        System.assertEquals(1,accountTeamMemberList.size());

        AssociatedLocation__c AssociatedLocation3 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));

        insert AssociatedLocation3;
    }

    @isTest
    static void testAssociatedLocationUpdateCaseOne(){
        //adiciona dois LAs iguais maa so um accountTeamMember vai ser criado, depois atualiza um e como ha outro la igual nao exclui o antigo e nem cria um novo
        AssociatedLocation__c AssociatedLocation1 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));
        AssociatedLocation__c AssociatedLocation2 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));
        List<AssociatedLocation__c> AssociatedLocations = new List<AssociatedLocation__c>{AssociatedLocation1, AssociatedLocation2};

        insert AssociatedLocations;

        AssociatedLocations[0].Account__c = Id.valueOf('001ak00001JQAYLAA5');

        update AssociatedLocations;

        List<AccountTeamMember> accountTeamMemberList1 = [SELECT Id, UserId, AccountId FROM AccountTeamMember ];
        System.assertEquals(1,accountTeamMemberList1.size());
    }

    @isTest
    static void testAssociatedLocationUpdateCaseTwo(){
        //atualiza um LA que nao tem outro LA igual, ou seja, vai deletar o AccountTeamMember antigo e criar um novo
        AssociatedLocation__c AssociatedLocation1 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));

        insert AssociatedLocation1;

        AssociatedLocation1.Account__c = Id.valueOf('001ak00001JQAYLAA5');

        update AssociatedLocation1;

        List<AccountTeamMember> accountTeamMemberList1 = [SELECT Id, UserId, AccountId FROM AccountTeamMember ];
        System.assertEquals(1,accountTeamMemberList1.size());
    }

    @isTest
    static void testAssociatedLocationUpdateCaseThree(){
       //Mudar um User de um LA para outro, ou seja, vai criar um AccountTeamMember e deletar o antigo
        AssociatedLocation__c AssociatedLocation1 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));
        AssociatedLocation__c AssociatedLocation2 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));
        List<AssociatedLocation__c> AssociatedLocations = new List<AssociatedLocation__c>{AssociatedLocation1, AssociatedLocation2};

        insert AssociatedLocations;

        AssociatedLocations[0].User__c = Id.valueOf('005ak00000KC3ufAAD');

        update AssociatedLocations;

        List<AccountTeamMember> accountTeamMemberList1 = [SELECT Id, UserId, AccountId FROM AccountTeamMember ];
        System.assertEquals(2,accountTeamMemberList1.size());
    }

    @isTest
    static void testAssociatedLocationUpdateCaseFour(){
       //Mudar um User de um LA para outro, ou seja, vai criar um AccountTeamMember e deletar o antigo
        AssociatedLocation__c AssociatedLocation1 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));

        insert AssociatedLocation1;

        AssociatedLocation1.User__c = Id.valueOf('005ak00000KC3ufAAD');

        update AssociatedLocation1;

        List<AccountTeamMember> accountTeamMemberList1 = [SELECT Id, UserId, AccountId FROM AccountTeamMember ];
        System.assertEquals(1,accountTeamMemberList1.size());
    }

    @isTest
    static void testAssociatedLocationDelete(){
        AssociatedLocation__c AssociatedLocation1 = new AssociatedLocation__c(Account__c = Id.valueOf('001ak00001JQAYKAA5'), User__c = Id.valueOf('005ak00000K81EjAAJ'));

        insert AssociatedLocation1;

        delete AssociatedLocation1;

        List<AccountTeamMember> accountTeamMemberList = [SELECT Id, UserId, AccountId FROM AccountTeamMember ];
        System.assertEquals(0, accountTeamMemberList.size());
    }

}