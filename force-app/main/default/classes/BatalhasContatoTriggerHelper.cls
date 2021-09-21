public class BatalhasContatoTriggerHelper {
    
    private List<BatalhasContato__c> lstDataNew; 
    private Map<Id, BatalhasContato__c> mapDataOld;
    private Map<Id, BatalhasContato__c> mapObjFiltered;
    private List<BatalhasContato__c> listObjFiltered;
    private Boolean hasRecords;
    
    public BatalhasContatoTriggerHelper(List<BatalhasContato__c> lstDataNew){      
        System.debug('>>lstDataNew:<< '+ lstDataNew);
     	Map<Id, BatalhasContato__c> mapDataOld = new  Map<Id, BatalhasContato__c>();
        new BatalhasContatoTriggerHelper(lstDataNew, mapDataOld);
    }
    
    public BatalhasContatoTriggerHelper(List<BatalhasContato__c> lstDataNew, Map<Id, BatalhasContato__c> mapDataOld){
        this.lstDataNew = lstDataNew;
        this.mapDataOld = mapDataOld;
        filter();
        this.hasRecords = listObjFiltered != null && !listObjFiltered.isEmpty();
        totalizaNumerosDeBatalha();
    }
        
    private void filter() {
     	 System.debug('>>Filter:<< ');
          if(this.lstDataNew != null){       
               listObjFiltered = new List<BatalhasContato__c>();
              for(BatalhasContato__c itemNew : this.lstDataNew)            
              {                
                 
                  //System.debug('>>Mapa DataOld:<< '+ mapDataOld);                
                  BatalhasContato__c itemOld = this.mapDataOld.get(itemNew.Id);  
                  System.debug('>>item New IdContato:<< '+ itemNew); 
                  System.debug('>>item Old IdContato:<< '+ itemOld); 
                  
                  if(itemOld == null){ //insert     
                      System.debug('insert');
                      listObjFiltered.add(itemNew);
                  }else if(itemNew.Contato__c != itemOld.Contato__c){ //update && alteração no proprietátio 
                      System.debug('update');
                      listObjFiltered.add(itemNew);
                      listObjFiltered.add(itemOld);                 
                  }                                     
              }              
          }else{ //delete           
            for(BatalhasContato__c itemOld : this.mapDataOld.values()){
            	
                listObjFiltered.add(itemOld);
            }
        } 
        System.debug('>>List Obj Filtered:<< '+ listObjFiltered);  
     }
   
    public void totalizaNumerosDeBatalha(){
        System.debug('>>hasRecords:<< '+ hasRecords);
    	if (hasRecords) 
        {
            Set<Id> idsContato = new Set<Id>();           
            for(BatalhasContato__c batalhaContato : listObjFiltered)
            {
                idsContato.add(batalhaContato.Contato__c);
            }
          
            System.debug('>>Ids Contato:<< '+ idsContato);
            
            List<Contact> lstContato  = new List<Contact> (); 
        
            for (AggregateResult arResul : [SELECT Contato__c, count(id) qtd
                                        FROM BatalhasContato__c 
                                        where Contato__c IN : idsContato
                                        GROUP BY Contato__c]) 
        
            {
                Contact contato = new Contact();
                contato.Id = String.valueOf(arResul.get('Contato__c'));
                contato.NumeroBatalhas__c =  Integer.valueOf(arResul.get('qtd')); 
                lstContato.add(contato);       
            }             
        
            if(lstContato.size()>0){
            update lstContato;
            }              
        }
    }
}