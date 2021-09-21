public class Heroi extends Contato {
	
    public String habilidade;
    public String nomeDeHeroi;
     
    public Heroi(String nomeDeHeroi,  String habilidade){
        super(nomeDeHeroi + 'Bonzinho', nomeDeHeroi.replace(' ', '') + '@email.com');
        this.nomeDeHeroi = nomeDeHeroi;
        this.habilidade = habilidade;
    }
}