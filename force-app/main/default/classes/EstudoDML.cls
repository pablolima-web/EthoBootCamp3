public class EstudoDML {
    
    public static void mainDML(){

        
        List<Contact> contatos = new List<Contact>();
        
        Contact contato1 = new Contact(
            firstName = 'Cotato1',
            lastName = 'Marvel CLONE0',
        	NomeGuerra__c = 'CLONE ETAPA UPDATE0'
        );
        
         Contact contato2 = new Contact(
            firstName = 'Cotato2',
            lastName = 'Marvel',
        	NomeGuerra__c = 'Goku 3'
        );
        
         Contact contato3 = new Contact(
            firstName = 'Cotato3',
            lastName = 'Marvel Mr. Satan',
        	NomeGuerra__c = 'Mr Satan'
        );
               
        contatos.add(contato1);
        contatos.add(contato2);
        contatos.add(contato3);
       
		/*List<Contact> contactsToday = [select id, firstname, lastname, nomeguerra__c from contact WHERE createddate = today];
		System.debug('>>>contactsToday ::'+contactsToday);
        for(integer i=0; i < contactsToday.size(); i++){
            contactsToday[i].NomeGuerra__c ='CLONE ETAPA UPDATE' + i;
        }*/
       
        List<Contact> contactsToDelete = [select id, firstname, lastname, nomeguerra__c, Email, Description, Phone, MobilePhone from contact WHERE createddate = today and nomeguerra__c LIKE 'Goku%'];
        System.debug('>>> contactsToDelete :: ' + contactsToDelete);
        
        //inserContact(contatos, true);
        //updateContact(contactsToday, true);
        //upsertContact(contatos, true);
        //unDeletContact(contactsToDelete, false);
        Contact contato = contactsToDelete[0];
        contactsToDelete.remove(0);
        mergeContacts(contato, contactsToDelete, true);
    }
    
    public static void mergeContacts(Contact ctt1,List<Contact> ctts, Boolean dbMethod){      
        if(dbMethod){
            //MESMO SE ALGUNS DADOS DA LISTA FALHAREM, OS QUE Ñ TIVERAM FALHAS SERÃO RETAURADOS COM "allOrNone = false"
            Database.MergeResult[]  results = Database.merge(ctt1, ctts, false);
             System.debug('>>>results ::'+ results);
        }else{
            //SE UM DADO DA LISTA FALHAR NENHUM DADO É AFETADO
            /*merge ctt1 ctt2; 
            System.debug('>>>contatos ::'+ ctt1, ctt2);*/
        }
    }
     
    public static void unDeletContact(List<Contact> contatos, Boolean dbMethod){
        
        if(dbMethod){
            //MESMO SE ALGUNS DADOS DA LISTA FALHAREM, OS QUE Ñ TIVERAM FALHAS SERÃO RETAURADOS COM "allOrNone = false"
            Database.UndeleteResult[] results = Database.undelete(contatos, false);
             //trataErroResult(results);
            System.debug('>>>contatos ::'+ contatos);
        }else{
            //SE UM DADO DA LISTA FALHAR NENHUM DADO É AFETADO
            undelete contatos;  
            System.debug('>>>contatos ::'+ contatos);
        }
    }
    
    public static void deletContact(List<Contact> contatos, Boolean dbMethod){
        
        if(dbMethod){
            //MESMO SE ALGUNS DADOS DA LISTA FALHAREM, OS QUE Ñ TIVERAM FALHAS SERÃO DELETADOS COM "allOrNone = false"
            Database.DeleteResult[] results = Database.delete(contatos, false);
             //trataErroResult(results);
            System.debug('>>>contatos ::'+ contatos);
        }else{
            //SE UM DADO DA LISTA FALHAR NENHUM DADO É AFETADO
            delete contatos;  
            System.debug('>>>contatos ::'+ contatos);
        }
     }
    
    public static void upsertContact(List<Contact> contatos, Boolean dbMethod){
        
        if(dbMethod){
            //MESMO SE ALGUNS DADOS DA LISTA FALHAREM, OS QUE Ñ TIVERAM FALHAS SERÃO ALTUALIZADOS OU INSERIDOS COM "allOrNone = false"
            Database.UpsertResult[] results = Database.upsert(contatos, Contact.NomeGuerra__c, false);
             trataUpsertResult(results);
        }else{
            //SE UM DADO DA LISTA FALHAR NENHUM DADO É AFETADO
            upsert contatos NomeGuerra__c; 
            System.debug('>>>contatos ::'+ contatos);
        }
    }
    
    public static void updateContact(List<Contact> contatos, Boolean dbMethod){
        System.debug('>>> entrou ::');
        if(dbMethod){
            //MESMO SE ALGUNS DADOS DA LISTA FALHAREM, OS QUE Ñ TIVERAM FALHAS SERÃO ALTERADOS COM "allOrNone = false"
            Database.SaveResult[] results = Database.update(contatos, false);
            System.debug('>>> results ::' + results);
             trataErroResult(results);
        }else{
            //SE UM DADO DA LISTA FALHAR NENHUM DADO É AFETADO
            update contatos;
        }
    }
    
    public static void inserContact(List<Contact> contatos, Boolean dbMethod){
        
        if(dbMethod){
            //MESMO SE ALGUNS DADOS DA LISTA FALHAREM, OS QUE Ñ TIVERAM FALHAS SERÃO INSERIDOS COM "allOrNone = false"
            Database.SaveResult[] results = Database.insert(contatos, false);
             trataErroResult(results);
        }else{
            // SE UM DADO DA LISTA FALHAR NENHUM DADO É AFETADO
            insert contatos;   
        }
    }
    
    public static void trataErroResult(Database.SaveResult[] results){
        
         for(Database.SaveResult result : results){
             // VERIFICA O INSERT COM O MÉTODO issuccess DE Database.Result
             if(result.isSuccess()){
                 //PEGA I ID DO REGISTRO SALVO
                 System.debug('>>> Success Id do Registro ::' + result.getId());
             }else{
                 //PERCORRE A LISTA DE ERRO PARA TRATAMENTO
                 for(Database.Error erro : result.getErrors()){
                     System.debug('>>> ERRO ::' + erro);
                 }
                 
             }
			
        }
    }
    
    public static void trataUpsertResult(Database.UpsertResult[] results){
        
         for(Database.UpsertResult result : results){
             // VERIFICA O INSERT COM O MÉTODO issuccess DE Database.Result
             if(result.isSuccess()){
                 //PEGA I ID DO REGISTRO SALVO
                 System.debug('>>> Success Id do Registro ::' + result.getId());
             }else{
                 //PERCORRE A LISTA DE ERRO PARA TRATAMENTO
                 for(Database.Error erro : result.getErrors()){
                     System.debug('>>> ERRO ::' + erro);
                 }
                 
             }
			
        }
    }
}