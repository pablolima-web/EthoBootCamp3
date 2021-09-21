@isTest
public class AtualizaRankingHabilidadeTriggerTest {
    
    @testSetup
    public static void setup(){
        // objs utilizados: Contato - Hablidade do Contato - Habilidade
       
       	Contact capitaoAmerica = new Contact(FirstName= 'Steve', LastName= 'Rogers', NomeGuerra__c= 'Capitão America', Status_Candidato__c= 'Aprovado Direto');
        Contact viuvaNegra = new Contact(FirstName= 'Natasha', LastName= 'Romanoff', NomeGuerra__c= 'Viúva Negra', Status_Candidato__c= 'Aprovado Direto');

        List<Contact> herois = new List<Contact>{capitaoAmerica, viuvaNegra};
        insert herois;
        
        Habilidade__c arteMarcial = new Habilidade__c(Name='Arte Marcial');
        Habilidade__c atirador = new Habilidade__c(Name='Atirador');
        Habilidade__c superForca = new Habilidade__c(Name='Super Forçe');
        
        List<Habilidade__c> habilidades = new List<Habilidade__c>{superForca, atirador, arteMarcial};
        insert habilidades;
        
        HabilidadeContato__c habilidadeContato1 = new HabilidadeContato__c();
        habilidadeContato1.Contato__c = capitaoAmerica.Id;
        habilidadeContato1.Habilidade__c = superForca.id;
        habilidadeContato1.Level_Habilidade__c = 90;
        
        HabilidadeContato__c habilidadeContato2 = new HabilidadeContato__c();
        habilidadeContato2.Contato__c = capitaoAmerica.Id;
        habilidadeContato2.Habilidade__c = atirador.id;
        habilidadeContato2.Level_Habilidade__c = 80;
        
        HabilidadeContato__c habilidadeContato3 = new HabilidadeContato__c();
        habilidadeContato3.Contato__c = capitaoAmerica.Id;
        habilidadeContato3.Habilidade__c = arteMarcial.id;
        habilidadeContato3.Level_Habilidade__c = 50;
        
        
        HabilidadeContato__c habilidadeContato4 = new HabilidadeContato__c();
        habilidadeContato4.Contato__c = viuvaNegra.Id;
        habilidadeContato4.Habilidade__c = arteMarcial.id;
        habilidadeContato4.Level_Habilidade__c = 70;
        
        HabilidadeContato__c habilidadeContato5 = new HabilidadeContato__c();
        habilidadeContato5.Contato__c = viuvaNegra.Id;
        habilidadeContato5.Habilidade__c = atirador.id;
        
        HabilidadeContato__c habilidadeContato6 = new HabilidadeContato__c();
        habilidadeContato6.Contato__c = viuvaNegra.Id;
        habilidadeContato6.Habilidade__c = superForca.id; 
             
       
        List<HabilidadeContato__c> habilidadesContato = new List<HabilidadeContato__c>{habilidadeContato1, habilidadeContato2, habilidadeContato3, habilidadeContato4, habilidadeContato5, habilidadeContato6};
        System.debug('habilidadesContato: '+ habilidadesContato);
        insert habilidadesContato;
        
        List<HabilidadeContato__c> habilidadesContatoDelete = new List<HabilidadeContato__c>{habilidadeContato6};
        delete habilidadesContatoDelete;      
        
        habilidadeContato4.Level_Habilidade__c = 83;
        habilidadeContato5.Level_Habilidade__c = 78;
        List<HabilidadeContato__c> habilidadesContatoUpdate = new List<HabilidadeContato__c>{habilidadeContato4,habilidadeContato5};        
        update habilidadesContatoUpdate;
    }
    
    @isTest
    public static void validaNovoRankingAfterInsert(){
        List<HabilidadeContato__c> habilidadesContato = [SELECT id, NomeHabilidade__c, Ranking__c   
                                                        FROM HabilidadeContato__c
                                                         WHERE Contato__r.NomeGuerra__c = 'Capitão America'
                                                        and Ranking__c != null];
        
        for(HabilidadeContato__c habilidadeContato : habilidadesContato){
            
            switch on habilidadeContato.NomeHabilidade__c {
                
                when 'Super Força'{
                    System.assertEquals(1, habilidadeContato.Ranking__c);
                }
                when 'Atirador'{
                    System.assertEquals(2, habilidadeContato.Ranking__c);
                }
                when 'Arte Marcial'{
                    System.assertEquals(3, habilidadeContato.Ranking__c);
                }when else{
                    
                }
            }
        }
       
    }
    
}