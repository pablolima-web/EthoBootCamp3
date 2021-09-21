// CRIAÇÃO DA TRIGGER, COM ALGUNS EVENTOS
trigger BatalhasContatoTrigger on BatalhasContato__c (after insert, after update, after delete) {

    //INSTANCIA DA CLASSE PARA TRATAMENTO DOS EVENTOS DML
    BatalhasContatoTriggerHandler batalhasContatoTriggerHandler = new BatalhasContatoTriggerHandler();
    
     // VERIFICA QUAL EVENTO SERÁ ACIONADO
    Switch on Trigger.operationType{
              
        When AFTER_INSERT{
            batalhasContatoTriggerHandler.onAfterInsert(Trigger.new);
        }
         When AFTER_UPDATE{
            batalhasContatoTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        When AFTER_DELETE{
            batalhasContatoTriggerHandler.onAfterDelete(Trigger.old);
        }     
    }  
}