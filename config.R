#Arquivo de configuracao
#Script por Henrique Almeida de Castro

# 1.LOGIN E SENHA

user <- ""
pass <- ""

        #Designe para as variaveis "user" e "pass" seu e-mail e 
        #senha cadastrados no site https://inlabs.in.gov.br/
        
        #Tanto o e-mail quanto a senha devem estar entre aspas.
        #Ex.: user <- "exemplo@gmail.com"; pass <- "senhaindevassavel"

# 2.TERMOS DE BUSCA

buscar_por <- c("")
nao_incluir <- c("")

        #Designe para a variavel "buscar_por" os termos de busca. 
        #Serao selecionados atos que contiverem qualquer um dos termos
        
        #Designe para a variavel "nao_incluir" os termos de exclusao.
        #Atos que contiverem qualquer um desses termos serao excluidos
        
        #Os termos devem estar entre aspas. 
        #Se houver mais de um termo, devem estar
        #contidos em "c(INSIRA_AQUI)" e separados por virgula
        #Ex.1: buscar_por <- "Conselho Nacional"
        #Ex.2: buscar_por <- c("Conselho Nacional", "portaria", "lei")
        #A busca desconsidera a caixa dos caracteres 
        #("CNPq" e "cnpq" dao na mesma)
        #Na ausencia de termos, mantenha as aspas vazias no lugar
        #Ex.: nao_incluir <- ""


# 3.DEFINIR SECAO E EDICAO DO DOU

dou <- c("")
dou_e <- c("")
        
        #Designe para a variavel "dou" os numeros 
        #das secoes do DOU que pretende buscar
        #Designe para a variavel "dou_e" os numeros das secoes 
        #da edicao extra do DOU que pretende buscar
        
        #Os termos devem estar entre aspas. 
        #Se houver mais de um termo, devem estar
        #contidos em "c(INSIRA_AQUI)" e separados por virgula
        #Ex1.: dou <- "2" #(busca apenas secao 2)
        #Ex2.: dou <- c("1", "2", "3") #(busca todas as secoes)
        #Na ausencia de termos, mantenha as aspas vazias no lugar
        #Ex.: dou_e <- ""

# 4. LIGAR NOTIFICACOES (OPCIONAL)         

chave_pushbullet <- ""

        #Caso pretenda usar o sistema do notificacoes, 
        #designe para a variavel "chave_pushbullet" o seu token de acesso.
        #O token deve estar entre aspas
        #Ex.: chave_pushbullet <- "a.asdffsdIHFSAD198scfF2Gdfg234GvFVYP"
        #Se nao quiser utilizar o sistema, mantenha as aspas vazias
        #Ex.: chave_pushbullet <- ""