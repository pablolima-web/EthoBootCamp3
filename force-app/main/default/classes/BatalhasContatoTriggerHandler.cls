public virtual class BatalhasContatoTriggerHandler {

     public void onAfterInsert(List<BatalhasContato__c> newRecords){
         System.debug('>>Update<<');  
        BatalhasContatoTriggerHelper batalhasContatoTriggerHelper = new BatalhasContatoTriggerHelper(newRecords);    
     }
    
    public void onAfterUpdate(List<BatalhasContato__c> newRecords, Map<Id,BatalhasContato__c> oldMap){		
         System.debug('>>Update<<');  
        BatalhasContatoTriggerHelper batalhasContatoTriggerHelper = new BatalhasContatoTriggerHelper(newRecords, oldMap);    
     }
    
    public void onAfterDelete(List<BatalhasContato__c> oldRecords){        
        System.debug('>>delete<<');
      BatalhasContatoTriggerHelper batalhasContatoTriggerHelper = new BatalhasContatoTriggerHelper(oldRecords); 
    }
}