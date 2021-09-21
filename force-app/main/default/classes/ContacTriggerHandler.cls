public class ContacTriggerHandler {
    
    public void onBeforeInsert(List<Contact> newRecords){
		System.debug('onBeforeInsert');        
    }
    
    public void onBeforeUpdate(List<Contact> newRecords, Map<Id, Contact> oldMap){
		System.debug('onBeforeUpdate');   
        for(Contact contato : newRecords){
           // System.debug('Before Contato new LastModifiedDate: ' + contato.LastModifiedDate);
            System.debug('Before Contato new: ' + contato);
            System.debug('Before Contatp old: ' + oldMap.get(contato.Id));
        }
    }
    
    public void onAfterInsert(List<Contact> newRecords){
		System.debug('onAfterInsert');              
        ContactTriggerHelper.criaTarefaParaEncontrarFraquezas(newRecords);
    }
    
    public void onAfterUpdate(List<Contact> newRecords, Map<Id, Contact> oldMap){
        
        for(Contact contato : newRecords){ 
            System.debug('After new Contato NumeroBatalhas: ' + contato.NumeroBatalhas__c);
            System.debug('After Contatp old: ' + oldMap.get(contato.Id));
        }			
    }
    
    public void onBeforeDelete(List<Contact> oldRecords, Map<Id, Contact> oldMap){
        
        ContactTriggerHelper.naoPermiteApagarTaskEmAberto(oldRecords, oldMap);
    }
}