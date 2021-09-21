public class HabilidadeContatoTriggerHelper {
	
     public static void naoPermiteApagarTaskEmAberto(List<Contact> oldRecords, Map<Id, Contact> oldMap){
    	
        List<Task> tasks = [SELECT id, status, WhoId FROM task WHERE WhoId IN :oldRecords AND Status  != 'Completed']; 
        
         for(Task tarefa : tasks){
            oldMap.get(tarefa.whoId).addError('Não é possível deletar com tarefas em abert!!!');
        }
        
    }
}