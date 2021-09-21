global class IdentificarnNivelHeroiFlow {
    
    @InvocableMethod(label = 'Identificar Nível do Herói')
    public Static List<Contact> identificaNivelHeroi(List<contactRequest> requests){

        System.debug('requests :' + requests);
        List<Contact> contatos = new List<Contact>();
        
        //PERCORRENDO CADA CONTATO
        for(contactRequest request : requests){
            Decimal media = 0;
            Decimal somaLevel = 0;
            
            System.debug('request.habilidadesContato :'+ request.habilidadesContato);
            //PERCORRENDO CADA HABILIDADE DO CANTADO
            for(HabilidadeContato__c habilidadeContato : request.habilidadesContato){
               	somaLevel += habilidadeContato.Level_Habilidade__c; 
                System.debug('2º for - somaLevel :' + somaLevel);
                
            }
            
            media = somaLevel/request.habilidadesContato.size();
            System.debug('media :' + media);
          
             String nivel = '';
            if(media >= 80){
            	nivel = 'Sênior'; 	   
            }else if(media >= 50){
                nivel = 'Pleno';
            }else{
                nivel = 'Junior';
            }
            
            
            System.debug('nivel :' + nivel);
           // contatos.add(new Contact(Id = request.contactId, NivelHerio__c = nivel, ));
            System.debug('Habilidades Contato :'+ request);
            request.contact.NivelHerio__c = nivel;
           // request.contact.Status_Candidato__c = 'Aprovado no Treinamento';
            contatos.add(request.contact);
        }
        
        update contatos;
        return contatos;
    }

     global class contactRequest{
         @InvocableVariable(required = true)
         global Contact contact;
         @InvocableVariable(required = true)
         global List<HabilidadeContato__c> habilidadesContato;
    }
}