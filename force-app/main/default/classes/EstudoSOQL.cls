public class EstudoSOQL {
	
    public static List<Contact> getAllContatcts(){
        List<Contact> contatos = [SELECT id, Name FROM contact];
        return contatos;
    }
    
    public static Contact getContactById(Id contactId){
        Contact contato = [SELECT id, Name, NomeGuerra__c FROM contact where id = :contactId];
       // return contato;        
        //List<Contact> contatos = [SELECT id, Name, NomeGuerra__c FROM contact where id = :contactId];
        
        if(contato != null){
            return contato;
        }else{
        	return null;    
        }
    }
    public static Map<String, Decimal> getAvgContact(){
        //USADO PARA TER MAIS FACILIDADE COM RESULTADOS AGRUPADOS 
        AggregateResult[] results = [SELECT Contato__r.NomeGuerra__c NomeGuerra, AVG(Level_Habilidade__c) MediaLevel
                                    FROM HabilidadeContato__c 
                                    GROUP BY Contato__r.NomeGuerra__c
                                    HAVING AVG(Level_Habilidade__c) > 0
                                    ORDER BY AVG(Level_Habilidade__c) DESC];                                        
       
        Map<String, Decimal> mapa = new Map<String, Decimal>();
        for(AggregateResult agResult : results){
            //
            String nomeGuerra = (String) agResult.get('NomeGuerra');
            Decimal madiaLevel = (Decimal) agResult.get('MediaLevel'); 
            
            mapa.put(nomeGuerra,madiaLevel);
        }
        
       return mapa;
    }
    
    public static List<HabilidadeContato__c> getHabilidaddePorContatoOrHabilidade(String nomeGuerra, String nomeHabilidade){
        String query = 'select id, Habilidade__r.Name, Level_Habilidade__c from HabilidadeContato__c where ';
        
        if(!String.isEmpty(nomeGuerra)){
            query += 'Contato__r.NomeGuerra__c = : nomeGuerra';
        }else{
            query += 'Habilidade__r.Name = :nomeHabilidade';
		}
         System.debug('>>> query ::' + query);
        List<HabilidadeContato__c> habilidadeContato = dataBase.query(query);
  
        System.debug('>>> return ::' + habilidadeContato);
        return habilidadeContato;
    }
}

/* MACETE => MAPA RECEBENDO UMA CONSULTA DIRETA
Map<Id, Contact> mapContatosRevisarRanking = new Map<Id, Contact>([SELECT id,
                                                                               (SELECT id, Name, Level_Habilidade__c 
                                                                                FROM Habilidades_do_Contato__r 
                                                                                WHERE Level_Habilidade__c != null 
                                                                                ORDER BY Level_Habilidade__c DESC, NomeHabilidade__c)
                                                                               FROM Contact 
                                                                               WHERE Id in : idsContato])

 */