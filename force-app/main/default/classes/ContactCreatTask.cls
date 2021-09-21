global class ContactCreatTask {
	
    @InvocableMethod(label = 'Criar Tarefa para Contato')
    public Static void ContactCreateTask(List<CreateTaskRequest> requests){
        System.debug('>>> requests ::' + requests);
        
        List<Id> lstCotatctIds = new List<Id>();
        for(CreateTaskRequest request : requests)
            lstCotatctIds.add(request.contactId);
        
        System.debug('>>> lstCotatctIds ::' + lstCotatctIds);
        
        //CRIA E POPULA UMA LISTA DAS HABILIDADES DO CONTATO
        List<HabilidadeContato__c> lstHabContatos = [select Id, Contato__c, Habilidade__r.Name from HabilidadeContato__c where Contato__c in : lstCotatctIds];
          
        //CRIA UM MAP
        Map<Id, List<String>> mapContatoHabilidades = new Map<Id, List<String>>(); 
        
        //PERCORRE AS HABILIDADES 
        for( HabilidadeContato__c habilidadeContato : lstHabContatos ){    
            
            //VERIFICA SE EXISTE ESSE ID DO CONTATO NO MAP
            if( mapContatoHabilidades.containsKey( habilidadeContato.Contato__c ) ){
                //ADD HABILIDADE PARA O ID EXISTENTE
                mapContatoHabilidades.get( habilidadeContato.Contato__c ).add( habilidadeContato.Habilidade__r.Name );
            }else{
                //ADD UMA LISTA DE STRING NO ID DO MAP
                mapContatoHabilidades.put( habilidadeContato.Contato__c, new List<String>{habilidadeContato.Habilidade__r.Name});               
            }
            System.debug('>>> mapContatoHabilidades DENTRO ::' + mapContatoHabilidades);            
        }        
        System.debug('>>> mapContatoHabilidades FORA ::' + mapContatoHabilidades);
        
        CreatTasks(requests, mapContatoHabilidades); 	 	 	 
    }
       
    //"CreatTasks" ASSUME A VISIBILIDADE DO MÉTODO CHAMADO POR ELE
    public static void CreatTasks(List<CreateTaskRequest> requests, Map<Id, List<String>> mapContatoHabilidades){
        
        System.debug('>>> requests ::' + requests);
        List<task> tasksToInsert = new List<Task>();
        
         for(CreateTaskRequest request : requests){
            Task tarefa = new Task(); 	 
                tarefa.Subject 		= request.subject;
                tarefa.WhoId 		= request.contactId;
                tarefa.OwnerId 		= request.ownerId;
                tarefa.Status 		= 'Open';
             	tarefa.Description 	= 'Por favor avalie este heroi. Suas habilidades são: '+ String.valueOf(mapContatoHabilidades.get(request.contactId));
             tasksToInsert.add(tarefa);
             
             if( !tasksToInsert.isEmpty() )
            insert tasksToInsert;
        }
    }   

    //CLASSE PARA RECEBER OS DADOS DO PORCESS BUILDER USANDO A VISIBILIDADE "global"
    global class CreateTaskRequest{
         //"@InvocableVariable" ASSINATURA PARA VARIAVEL SER USADA NO PROCESS BUILDER
         //(required = true) FORÇA O PREENCHIMENTO NO PROCESS BUILDER
         @InvocableVariable(required = true)
         global String contactId;
         @InvocableVariable(required = true)
         global String ownerId;
         @InvocableVariable
         global String subject;
    }
}