public virtual class HabilidadeContatoTriggerHandler {

    public void onAfterInsert(List<HabilidadeContato__c> newRecords){
		System.debug('>>Handler After Insert<< ');         
       AtualizaRankingHabilidadeTrigger atualizaRankingHabilidadeTriggernew = new AtualizaRankingHabilidadeTrigger(newRecords);
    }
    
    public void onAfterUpdate(List<HabilidadeContato__c> newRecords, Map<Id, HabilidadeContato__c> oldMap){
        System.debug('>>Handler After Update<< ');      
        AtualizaRankingHabilidadeTrigger atualizaRankingHabilidadeTriggernew = new AtualizaRankingHabilidadeTrigger(newRecords, oldMap);
    }
    
    public void onAfterDelete(List<HabilidadeContato__c> oldRecords, Map<Id, HabilidadeContato__c> oldMap){
        System.debug('>>Handler After Delete<<');  
        AtualizaRankingHabilidadeTrigger atualizaRankingHabilidadeTriggernew = new AtualizaRankingHabilidadeTrigger(oldRecords, oldMap);
    }
    
}