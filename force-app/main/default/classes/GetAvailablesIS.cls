/*Lista todos os heróis que ñ estão alocados em batalhas e 
 * ter opção de buscar todos, por habilidade e por nível do heroi 
 */
//@RestResource -> ASSINATURA PARA SER ACESSIVEL VIA API
//urlMapping ->CAMINHO QUE VAMOS CHAMAR NOSSO ENDPOIT PARA DEVOLVER A INFORMAÇÃO 
@RestResource(urlMapping='/marvel/vailablesheroes/*') // MAPAPEI O SERVIÇO PARA AS APIs
global class GetAvailablesIS {
        
    //SERVIÇO DO TIPO GET
    @HttpGet // INFORMA QUAL O MÉTODO SERA USADO,  
    global static AvailableHeroes doGet(){
        
       
        // lista para receber o resultado da query
        List<HabilidadeContato__c> lstHabContatos = new List<HabilidadeContato__c>();
        
        //mapa de string, contato 
        Map<String,Hero> mapHerois = new Map<String,Hero>();
        
        //PARAMETROS RECEBIDOS DA API
        String habilidadeParam = RestContext.request.params.get('habilidade');
        String nivelParam = RestContext.request.params.get('niveil');
        
        //query
        String dynamicQuery = 'SELECT Id, Contato__r.NomeGuerra__c, Contato__r.Name,Contato__r.NivelHerio__c, Habilidade__r.Name, Level_Habilidade__c '+
            			'FROM HabilidadeContato__c ' +
            			'WHERE Contato__r.RecordType.DeveloperName = \'Heroi\' '+
            			'AND Contato__c NOT IN (select Contato__c from BatalhasContato__c)';
        
        if(!String.isBlank(habilidadeParam)){
            //cria uma lista para receber um ou + parametros 
            List<String> listHabilidadesParam = habilidadeParam.split(',');
            //add + uma condição na query
            dynamicQuery += ' and Habilidade__r.Name IN : listHabilidadesParam';
        }
        if(!String.isBlank(nivelParam)){
             List<String> listNiveisParam = nivelParam.split(',');
            dynamicQuery += ' and Contato__r.NivelHerio__c IN : listNiveisParam';
        }
        
        system.debug('dynamicQuery: '+ dynamicQuery);
        
        //obtem o retorno da query
        lstHabContatos = DataBase.query(dynamicQuery);
       
        for(HabilidadeContato__c habilidadeContato : lstHabContatos){

            Skill habilidade = new Skill(habilidadeContato.Habilidade__r.Name,String.valueOf(habilidadeContato.Level_Habilidade__c));
        	Hero heroi;
             //VERIFICA SE EXISTE ESSE ID DO CONTATO NO MAP
            if( mapHerois.containsKey( habilidadeContato.Contato__r.Name ) ){
                //RECUPERAR O VALOR DO MAPA PASSANDO A CHAVE
                heroi = mapHerois.get( habilidadeContato.Contato__r.Name );
                //ADD HABILIDADE PARA O CONTATO RECUPERADO
                heroi.habilidades.add(habilidade);                
            }else{
                //INSTANCIA DO NOVO HEROI
                heroi =  new Hero();
                //ATRIBIU OS VALORES PARA OS ATRIBUTOS
                heroi.nome = habilidadeContato.Contato__r.Name;
                heroi.nivel = habilidadeContato.Contato__r.NivelHerio__c;
                heroi.habilidades = new List<Skill>{habilidade};             
            }
             // ADD OS NOVOS VALORES AO MAPA
             mapHerois.put( habilidadeContato.Contato__r.Name, heroi); 
        }
                
         system.debug('Mapa Herois: '+ mapHerois);
        
        //return availableHeroes;
        return new AvailableHeroes (mapHerois.values());
    }
    
    //ESTRUTURA PARA Ñ EXPOR IFORMAÇÕES DESNECESSARIAS NA API
    global class AvailableHeroes{
        public List<Hero> herois;
        public Integer total;
        public AvailableHeroes(List<Hero> herois){
            this.herois = herois;
            this.total = herois.size();
        }
    } 
    global class Hero{
        String nome;
        String nivel;
        public List<Skill> habilidades;
    }
    global class Skill{
        String nome;
        String nivel;        
        Skill(String nome, String nivel){
            this.nome = nome;
            this.nivel = nivel != null ? nivel : 'Não avaliado';
        }
    }
}