// CRIAÇÃO DA TRIGGER COM OS EVENTOS NECESSARIOS
trigger HabilidadeContatoTrigger on HabilidadeContato__c (after insert, after update, after delete) {

    //INSTANCIA DA CLASSE PARA TRATAMENTO DOS EVENTOS DML
    HabilidadeContatoTriggerHandler habilidadeContatohandler = new HabilidadeContatoTriggerHandler();
 
    // VERIFICA QUAL EVENTO SERÁ ACIONADO
    Switch on Trigger.operationType{
              
        When AFTER_INSERT{
            habilidadeContatohandler.onAfterInsert(Trigger.new);
        }
        When AFTER_UPDATE{
            habilidadeContatohandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        When AFTER_DELETE{
            habilidadeContatohandler.onAfterDelete(Trigger.new, Trigger.oldMap);
        }     
    } 
}