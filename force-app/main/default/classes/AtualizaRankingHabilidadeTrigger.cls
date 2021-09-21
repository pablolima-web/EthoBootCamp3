public class AtualizaRankingHabilidadeTrigger {

    private List<HabilidadeContato__c> lstDataNew; 
    private Map<Id, HabilidadeContato__c> mapDataOld;
    private Map<Id, HabilidadeContato__c> mapObjFiltered;
    private Boolean hasRecords;
    
    public AtualizaRankingHabilidadeTrigger(List<HabilidadeContato__c> lstDataNew){      
        System.debug('>>lstDataNew:<< '+ lstDataNew);
     	Map<Id, HabilidadeContato__c> mpDtOld = new  Map<Id, HabilidadeContato__c>();
        new AtualizaRankingHabilidadeTrigger(lstDataNew, mpDtOld);
    }
    
    public AtualizaRankingHabilidadeTrigger(List<HabilidadeContato__c> lstDataNew, Map<Id, HabilidadeContato__c> mapDataOld){
        this.lstDataNew = lstDataNew;
        this.mapDataOld = mapDataOld;
        filter();
        this.hasRecords = mapObjFiltered != null && !mapObjFiltered.isEmpty();
        run();
    }
   
    private void filter() {
        System.debug('>>filter:<< ');
        if(this.lstDataNew != null){
            
            for(HabilidadeContato__c itemNew : this.lstDataNew)
            {
                System.debug('>>mapDataOld:<< '+ mapDataOld);
                HabilidadeContato__c itemOld = this.mapDataOld.get(itemNew.Id);
                if(
                    (itemOld == null && itemNew.Level_Habilidade__c != null) //insert && Level preenchido
                    ||
                    (itemOld != null && itemNew.Level_Habilidade__c != itemOld.Level_Habilidade__c) //update && Level preenchido
                ){
                    addMapFiltered(itemNew);
                }
                System.debug('>>Item Antigo:<< '+ itemOld);
            }
        }else{ //delete
            
            for(HabilidadeContato__c itemOld : this.mapDataOld.values()){
            	
                if(itemOld.Level_Habilidade__c != null) //possuia Level preenchido
                { 
                    addMapFiltered(itemOld);
                }
                
            }
        } 
    }
    
    private void addMapFiltered(HabilidadeContato__c item){
        if(mapObjFiltered == null)
            mapObjFiltered = new Map<Id, HabilidadeContato__c>();
        
        mapObjFiltered.put(item.Id, item);
    }
    
    public void run(){
         System.debug('>>hasRecords:<< '+ hasRecords);
    	if (hasRecords) 
        {
            Set<Id> idsContato = new Set<Id>();
            
            //for(Id idHabilidadeContato : this.mapObjFiltered.keySet())
           // {
              //  idsContato.add(this.mapObjFiltered.get(idHabilidadeContato).Contato__c);
            //}
            
            for(HabilidadeContato__c habilidadeContato : this.mapObjFiltered.values())
            {
                idsContato.add(habilidadeContato.Contato__c);
            }
            
            Map<Id,Contact> mapContatosRevisarRanking = new Map<Id,Contact>([SELECT Id, 
                                                                                 (SELECT Id, Name, Level_Habilidade__c
                                                                                  FROM Habilidades_do_Contato__r
                                                                                  WHERE Level_Habilidade__c!= null 
                                                                                  ORDER BY Level_Habilidade__c DESC, NomeHabilidade__c) 
                                                                             FROM Contact WHERE Id IN : idsContato]);
            
            
            System.debug('>>mapContatosRevisarRanking:<< '+ mapContatosRevisarRanking);
            List<HabilidadeContato__c> habilidadesParaAtualizarRanking = new List<HabilidadeContato__c>();
            for(Contact contato : mapContatosRevisarRanking.values())
            {
                if(!contato.Habilidades_do_Contato__r.isEmpty())
                {
                    Integer ranking = 1;
                    for(HabilidadeContato__c habilidadeContato : contato.Habilidades_do_Contato__r)
                    {
                        habilidadeContato.Ranking__c = ranking++;
                        habilidadesParaAtualizarRanking.add(habilidadeContato);
                    }
                }
            }
            
            update habilidadesParaAtualizarRanking;
        }        
    }
}