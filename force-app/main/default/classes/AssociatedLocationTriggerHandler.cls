public with sharing class AssociatedLocationTriggerHandler {
    private static Boolean isEnabled;
	static {
		isEnabled = true;
	}
	public static Boolean isTriggerEnabled() {
		return isEnabled;
	}
	public static Boolean disableTrigger() {
		return isEnabled = false;
	}
	public static Boolean enableTrigger() {
		return isEnabled = true;
	}

	List<AssociatedLocation__c> oldRecordList { get; set; }
	List<AssociatedLocation__c> newRecordList { get; set; }
	Map<Id, AssociatedLocation__c> oldRecordMap { get; set; }
	Map<Id, AssociatedLocation__c> newRecordMap { get; set; }

	public AssociatedLocationTriggerHandler(
		List<AssociatedLocation__c> oldRecordList,
		List<AssociatedLocation__c> newRecordList,
		Map<Id, AssociatedLocation__c> oldRecordMap,
		Map<Id, AssociatedLocation__c> newRecordMap
	) {
		this.oldRecordList = oldRecordList;
		this.newRecordList = newRecordList;
		this.oldRecordMap = oldRecordMap;
		this.newRecordMap = newRecordMap;
	}

    public void afterInsert() {
		AssociatedLocationTriggerHelper.handleInsertAccountTeamMember(this.newRecordList);
	}
	public void afterUpdate() {
        AssociatedLocationTriggerHelper.handleUpdateAccountTeamMember(this.newRecordList, this.oldRecordMap);
	}
	public void afterDelete() {
        AssociatedLocationTriggerHelper.handleDeleteAccountTeamMember(this.oldRecordList);
	}
}