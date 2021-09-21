public class ContactTriggerHelper {

    public static void criaTarefaParaEncontrarFraquezas(List<Contact> newRecords){
         
        List<task> tasksToInsert = new List<Task>();        
         for(Contact contato : newRecords){
             //RECUPERA O ID DO CONTATO PELO NOME DO TIPO DE REGISTRO ATRAVES DO (Schema). NESSE CASSO VILÃO
             Id vilaoId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Vilao').getRecordTypeId();
             if(contato.RecordTypeId == vilaoId){
          		Task tarefa = new Task(); 	 
                    tarefa.Subject 		= 'Descobrir fraquezas do vilão';
                    tarefa.WhoId 		= contato.Id;
                    tarefa.OwnerId 		= contato.ownerId;
                    tarefa.Status 		= 'Open';
                tasksToInsert.add(tarefa);
             }
         }
        
         if( !tasksToInsert.isEmpty() ){
                 insert tasksToInsert;
             }    
    }
    
    public static void naoPermiteApagarTaskEmAberto(List<Contact> oldRecords, Map<Id, Contact> oldMap){
    	
        List<Task> tasks = [SELECT id, status, WhoId FROM task WHERE WhoId IN :oldRecords AND Status  != 'Completed']; 
        
         for(Task tarefa : tasks){
            oldMap.get(tarefa.whoId).addError('Não é possível deletar com tarefas em abert!!!');
        }
        
    }
}