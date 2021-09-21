public class Vilao extends Contato {
	
     private String nomeDeVilao;
     private String habilidades;
    
    public Vilao(String nomeDeVilao,  String habilidade){
        super(nomeDeVilao + 'Malvadao', habilidade.replace(' ', '') + '@email.com');
        this.nomeDeVilao = nomeDeVilao;
        this.habilidades = habilidade;
    }
}