trigger Cotact on Contact (before insert, after insert, before update, after update, before delete) {
//EVENTOS DISPONIBILIZADOS PELA TRIGGER insert / update / delete / undelete
    
    // BEFORE --> Antes
    // AFTER --> Depois
	// new --> Antes de salvar no banco
	// old --> Depois de slavar no banco
	
    //CLASSE PARA TRATAMENTO DOS EVENTOS DML
    ContacTriggerHandler handler = new ContacTriggerHandler();
    
    Switch on Trigger.operationType{
        When BEFORE_INSERT{
            handler.onBeforeInsert(Trigger.new);
        }        
        When BEFORE_UPDATE{
            //BOA PRATICA TRABALHAR COM MAP, FACILITA O TRATAMENTO
            handler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
        }        
        When AFTER_INSERT{
            handler.onAfterInsert(Trigger.new);
        }
        When AFTER_UPDATE{
            handler.onAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        When BEFORE_DELETE{
            handler.onBeforeDelete(Trigger.old, Trigger.oldMap);
        }     
    }
}