trigger AssociatedLocationTrigger on AssociatedLocation__c (after insert, after update, after delete) {
    System.debug('AssociatedLocation__c Trigger Start => ' + Trigger.operationType);
	AssociatedLocationTriggerHandler handler = new AssociatedLocationTriggerHandler(
		Trigger.old,
		Trigger.new,
		Trigger.oldMap,
		Trigger.newMap
	);

    if (AssociatedLocationTriggerHandler.isTriggerEnabled()) {
		switch on Trigger.operationType {
			when AFTER_INSERT {
				handler.afterInsert();
			}
			when AFTER_UPDATE {
				handler.afterUpdate();
			}
			when AFTER_DELETE {
				handler.afterDelete();
			}
		}
	}
}