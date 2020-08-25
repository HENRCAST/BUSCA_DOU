#### PARTE 1: PREPARACAO ####

#Carrega arquivo config
source('config.R')

#Checa se pacotes necessarios estao instalados; se n, instala
packages <- c("rvest", "httr", "xml2", "sjmisc", "utils", 
              "stringr", "stringi", "RPushbullet")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
        install.packages(setdiff(packages, rownames(installed.packages())))  
}

#Carrega pacotes necessarios
library(rvest)
library(httr) 
library(xml2)
library(sjmisc)
library(utils)
library(stringr)
library(RPushbullet)
library(stringi)

analisados.list <- list()

#### PARTE 2: ACESSA INLABS ####

#Inicia sessao no inlabs
inlabs <- html_session("https://inlabs.in.gov.br/acessar.php")

#Gera formulario com usuario e senha. Os objs "user" e "pass" estao especificados em "config.R"
login <- inlabs %>%
        html_node(xpath = "//html//body//div[1]//div[2]//div[2]//form[1]") %>%
        html_form() %>%
        set_values(email = user, password = pass)

#Submete autenticao
submit_form(inlabs, login)

#### PARTE 3: BAIXA DOU DO DIA ####

#Checa data do dia e guarda como "character vector"
hoje <- Sys.Date()
hoje <- as.character(hoje)

#Baixa DOU1
if(str_contains(dou, "1") == TRUE){
        
        #Cria diretorio
        dir.create(hoje)
        
        #Gera nomes necessarios
        dou1_url <- paste("https://inlabs.in.gov.br/index.php?p=",
                          hoje, "&dl=", hoje, "-DO1.zip", sep = "")
        dou1_zip <- paste(hoje, "/", "DO1.zip", sep = "") #p/ arquivo zip baixado
        dou1_dir <- paste(hoje, "/", "-DO1", sep = "") #p/ diretorio de descompactados
        
        #Acoes
        jump_to(inlabs, dou1_url, #vai para url de download...
                config = write_disk(dou1_zip, overwrite = TRUE)) # ...e baixa .zip
        unzip(dou1_zip, #descompacta zip
              exdir = dou1_dir, overwrite = TRUE) #e define diretorio de saida
        unlink(dou1_zip)#deleta .zip
}

#Baixa DOU2
if(str_contains(dou, "2") == TRUE){
        
        #Cria diretorio
        dir.create(hoje)
        
        #Gera nomes necessarios
        dou2_url <- paste("https://inlabs.in.gov.br/index.php?p=",
                          hoje, "&dl=", hoje, "-DO2.zip", sep = "") #define url de teste
        dou2_zip <- paste(hoje, "/", "DO2.zip", sep = "") #p/ arquivo zip baixado
        dou2_dir <- paste(hoje, "/", "-DO2", sep = "") #p/ diretorio de descompactados
        
        #Acoes
        jump_to(inlabs, dou2_url, #vai para url de download...
                config = write_disk(dou2_zip, overwrite = TRUE)) # ...e baixa .zip
        unzip(dou2_zip, #descompacta zip
              exdir = dou2_dir, overwrite = TRUE) #e define diretorio de saida
        unlink(dou2_zip)#deleta .zip
}

#Baixa DOU3
if(str_contains(dou, "3") == TRUE){
        
        #Cria diretorio
        dir.create(hoje)
        
        #Gera nomes necessarios
        dou3_url <- paste("https://inlabs.in.gov.br/index.php?p=",
                          hoje, "&dl=", hoje, "-DO3.zip", sep = "") #define url de teste
        dou3_zip <- paste(hoje, "/", "DO3.zip", sep = "") #p/ arquivo zip baixado
        dou3_dir <- paste(hoje, "/", "-DO3", sep = "") #p/ diretorio de descompactados
        
        #Acoes
        jump_to(inlabs, dou3_url, #vai para url de download...
                config = write_disk(dou3_zip, overwrite = TRUE)) # ...e baixa .zip
        unzip(dou3_zip, #descompacta zip
              exdir = dou3_dir, overwrite = TRUE) #e define diretorio de saida
        unlink(dou3_zip)#deleta .zip
        
}

#### PARTE 4: ANALISA DOU ####

if(exists("dou1_dir") | exists("dou2_dir") | exists("dou3_dir") == TRUE){
        
        #Cria lista de arquivos no diretorio geral e nos seus subdiretorios
        files <- list.files(path=hoje, pattern="*.xml", full.names=TRUE, recursive=TRUE)
        
        #Inicia loop entre arquivos da pasta
        for(i in 1:length(files)){
                
                #Le "i" como html
                dou_html <- read_xml(files[i], as_html = TRUE)
                
                #Busca pelo nodolo "texto" e converte seu conteudos em um "character vector"
                dou_texto <- html_nodes(dou_html, 'texto') #busca nodulo texto
                dou_texto <- as_list(dou_texto) #transforma em lista
                dou_texto <- unlist(dou_texto) #transforma em char vector
                
                #Checa se o "texto" contem a expressao de interesse.
                teste_expres <- str_contains(dou_texto, 
                                             buscar_por, #obj buscar_por esta em config
                                             logic = 'or', #vetor logico "ou" PENSAR EM COMO IMPLEMENTAR OUTROS
                                             ignore.case = TRUE) & 
                        str_contains(dou_texto,
                                     nao_incluir,
                                     logic = "not",
                                     ignore.case = TRUE)
                
                #Inicia se "Texto" incluir expressoes buscadas
                if(teste_expres == TRUE){
                        
                        # le "i" como xml
                        dou_xml <- read_xml(files[i]) # le "i" como xml
                        
                        #Gera nomes necessarios
                        dou_pubName <- xml_attrs(xml_child(dou_xml, 1))[["pubName"]] #Extrai pubName de "i"
                        dou_id <- xml_text(xml_find_all(dou_xml, '//Identifica'), trim = TRUE) #Extrai id de "i"
                        if(dou_id == ""){
                                dou_id <- stri_rand_strings(1, 30)
                        } #se o id estiver vazio, o transforma em um chr string aleatorio
                        dou_id <- str_replace_all(dou_id, "[^[:alnum:]]", " ") %>% str_replace_all(.,"[ ]+", " ") #Remove caracteres proibidos de ID.
                        dou_id <- str_trunc(dou_id, 60, "right") #Limita ID a 60 chars
                        dou_dest <- paste(hoje, '/', dou_pubName, '/', dou_id, '.txt', sep = '') #designacao do destino do arquivo .txt
                        
                        #Cria diretorio de destino a partir de pubName
                        dir.create(paste(hoje, "/", dou_pubName, sep = ''))
                        
                        #Imprime conteudo de "Texto" com nome de arquivo retirado de "Indentifica"
                        texto_final <- file(dou_dest) #cria arquivo no destino designado
                        writeLines(dou_texto, con = texto_final, sep = '
                                   
        ')#insere informacao dentro do arquivo
                        #fecha conexao com arquivo
                        close(texto_final)
                        
                        #insere id na lista final
                        analisados.list <- append(analisados.list, dou_id)
                }
        } #Encerra loop
}

#### PARTE 5: BAIXA DOU EXTRA DO DIA ANTERIOR ####

#checa data do dia anterior e guarda como character vector
ontem <- Sys.Date() - 1
ontem <- as.character(ontem)

#baixa DOU 1 ESPECIAL se dou_e contiver "1"
if(str_contains(dou_e, "1") == TRUE){
        
        #testa se dou especial foi publicado....
        dou1e_url <- paste("https://inlabs.in.gov.br/index.php?p=",
                           ontem, "&dl=", ontem, "-DO1E.zip", sep = "") #define url de teste
        dou1e_url_teste <- jump_to(inlabs, dou1e_url,
                                   httr::config(followlocation = FALSE)) #...impedindo redirecionamentos
        dou1e_url_teste <- as.character(dou1e_url_teste)
        
        if(str_contains(dou1e_url_teste, 'status_code = 200') == TRUE){ #se a resposta contiver "200", inicia processo
                
                #cria diretorio
                ontem_dir <- paste(paste(ontem, "E", sep = ""))
                dir.create(ontem_dir)
                
                #define nomes
                dou1e_zip <- paste(ontem_dir, "/", "DO1E.zip", sep = "") #p/ arquivo zip baixado
                dou1e_dir <- paste(ontem_dir, "/", "-DO1E", sep = "") #p/ diretOrio de descompactados
                
                #Acoes
                jump_to(inlabs, dou1e_url, #vai para url de download...
                        config = write_disk(dou1e_zip, overwrite = TRUE)) # ...e baixa .zip
                unzip(dou1e_zip, #descompacta zip
                      exdir = dou1e_dir, overwrite = TRUE) #e define diretOrio de saida
                unlink(dou1e_zip)#deleta .zip
        }       
}

#baixa DOU 2 ESPECIAL se dou_e contiver "2"
if(str_contains(dou_e, "2") == TRUE){
        
        #testa se dou especial foi publicado....
        dou2e_url <- paste("https://inlabs.in.gov.br/index.php?p=",
                           ontem, "&dl=", ontem, "-DO2E.zip", sep = "") #define url de teste
        dou2e_url_teste <- jump_to(inlabs, dou2e_url,
                                   httr::config(followlocation = FALSE)) #...impedindo redirecionamentos
        dou2e_url_teste <- as.character(dou2e_url_teste)
        
        if(str_contains(dou2e_url_teste, 'status_code = 200') == TRUE){ #se a resposta contiver "200", inicia processo
                
                #cria diretorio
                ontem_dir <- paste(paste(ontem, "E", sep = ""))
                dir.create(ontem_dir)
                
                #define nomes
                dou2e_zip <- paste(ontem_dir, "/", "DO2E.zip", sep = "") #p/ arquivo zip baixado
                dou2e_dir <- paste(ontem_dir, "/", "-DO2E", sep = "") #p/ diretorio de descompactados
                
                #Acoes
                jump_to(inlabs, dou2e_url, #vai para url de download...
                        config = write_disk(dou2e_zip, overwrite = TRUE)) # ...e baixa .zip
                unzip(dou2e_zip, #descompacta zip
                      exdir = dou2e_dir, overwrite = TRUE) #e define diret?rio de sa?da
                unlink(dou2e_zip)#deleta .zip
        }       
}

#baixa DOU 3 ESPECIAL se dou_e contiver "3"
if(str_contains(dou_e, "3") == TRUE){
        
        #testa se dou especial foi publicado....
        dou3e_url <- paste("https://inlabs.in.gov.br/index.php?p=",
                           ontem, "&dl=", ontem, "-DO3E.zip", sep = "") #define url de teste
        dou3e_url_teste <- jump_to(inlabs, dou3e_url,
                                   httr::config(followlocation = FALSE)) #...impedindo redirecionamentos
        dou3e_url_teste <- as.character(dou3e_url_teste)
        
        if(str_contains(dou3e_url_teste, 'status_code = 200') == TRUE){ #se a resposta contiver "200", inicia processo
                
                #cria diretorio
                ontem_dir <- paste(paste(ontem, "E", sep = ""))
                dir.create(ontem_dir)
                
                #define nomes
                dou3e_zip <- paste(ontem_dir, "/", "DO3E.zip", sep = "") #p/ arquivo zip baixado
                dou3e_dir <- paste(ontem_dir, "/", "-DO3E", sep = "") #p/ diretorio de descompactados
                
                #Acoes
                jump_to(inlabs, dou3e_url, #vai para url de download...
                        config = write_disk(dou3e_zip, overwrite = TRUE)) # ...e baixa .zip
                unzip(dou3e_zip, #descompacta zip
                      exdir = dou3e_dir, overwrite = TRUE) #e define diret?rio de sa?da
                unlink(dou3e_zip)#deleta .zip
        }       
}

#### PARTE 6: ANALISA DOU ESPECIAL ####

if(exists("dou1e_dir") | exists("dou2e_dir") | exists("dou3e_dir") == TRUE){
        
        #Cria lista de arquivos no diretorio geral e nos seus subdiret?rios
        files <- list.files(path=ontem_dir, pattern="*.xml", full.names=TRUE, recursive=TRUE)
        
        #Inicia loop entre arquivos da pasta
        for(i in 1:length(files)){
                
                #L? "i" como html
                dou_html <- read_xml(files[i], as_html = TRUE)
                
                #Busca pelo nodolo "texto" e converte seu conte?dos em um "character vector"
                dou_texto <- html_nodes(dou_html, 'texto') #busca n?dulo texto
                dou_texto <- as_list(dou_texto) #transforma em lista
                dou_texto <- unlist(dou_texto) #transforma em char vector
                
                #Checa se o "texto" contem a expressao de interesse.
                teste_expres <- str_contains(dou_texto, 
                                             buscar_por, #obj buscar_por esta em config
                                             logic = 'or', #vetor l?gico "ou" PENSAR EM COMO IMPLEMENTAR OUTROS
                                             ignore.case = TRUE) & 
                        str_contains(dou_texto,
                                     nao_incluir,
                                     logic = "not",
                                     ignore.case = TRUE)
                
                #Inicia se "Texto" incluir express?es buscadas
                if(teste_expres == TRUE){
                        
                        # l? "i" como xml
                        dou_xml <- read_xml(files[i]) # l? "i" como xml
                        
                        #Gera nomes necessarios
                        dou_pubName <- xml_attrs(xml_child(dou_xml, 1))[["pubName"]] #Extrai pubName de "i"
                        dou_id <- xml_text(xml_find_all(dou_xml, '//Identifica'), trim = TRUE) #Extrai id de "i"
                        if(dou_id == ""){
                                dou_id <- stri_rand_strings(1, 30)
                        } #se o id estiver vazio, o transforma em um chr string aleatorio
                        dou_id <- str_replace_all(dou_id, "[^[:alnum:]]", " ") %>% str_replace_all(.,"[ ]+", " ") #Remove caracteres proibidos de ID.
                        dou_id <- str_trunc(dou_id, 60, "right") #Limita ID a 60 chars
                        dou_dest <- paste(ontem, 'E/', dou_pubName, '/', dou_id, '.txt', sep = '') #designa??o do destino do arquivo .txt
                        
                        #Cria diretorio de destino a partir de pubName
                        dir.create(paste(ontem, "E/", dou_pubName, sep = ''))
                        
                        #Imprime conteudo de "Texto" com nome de arquivo retirado de "Indentifica"
                        texto_final <- file(dou_dest) #cria arquivo no destino designado
                        writeLines(dou_texto, con = texto_final, sep = '
                                   
        ')#insere informacao dentro do arquivo
                        
                        #fecha conexao com arquivo
                        close(texto_final)
                        
                        #adiciona na lista
                        analisados.list <- append(analisados.list, dou_id)
                }
        } #Encerra loop
}

#### PARTE 7: DELETA DIRETORIOS COM XMLs ####

#DOU1
if (exists("dou1_dir") == TRUE){
        unlink(dou1_dir, recursive = TRUE)
}

#DOU2
if (exists("dou2_dir") == TRUE){
        unlink(dou2_dir, recursive = TRUE)
}

#DOU3
if (exists("dou3_dir") == TRUE){
        unlink(dou3_dir, recursive = TRUE)
}

#DOU1E
if (exists("dou1e_dir") == TRUE){
        unlink(dou1e_dir, recursive = TRUE)
}

#DOU2E
if (exists("dou2e_dir") == TRUE){
        unlink(dou2e_dir, recursive = TRUE)
}

#DOU3E
if (exists("dou3e_dir") == TRUE){
        unlink(dou3e_dir, recursive = TRUE)
}

#### PARTE 8: ENVIA NOTIFICACAO ####

n_analisados <- as.character(length(analisados.list))

if(chave_pushbullet != ""){
        pbSetup(chave_pushbullet, defdev = "0")
        pbPost(type = "note", title = "BUSCA_DOU",
               body = paste("Busca realizada! Foram encontrados", 
                            n_analisados, "resultados.", sep = " "))
}
