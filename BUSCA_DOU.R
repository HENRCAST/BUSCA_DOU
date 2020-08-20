#Script por Henrique Almeida de Castro

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

tryCatch(
        source('Versao_atual.R'),
        error = function(cond) {
                if(chave_pushbullet != ""){
                        pbSetup(chave_pushbullet, defdev = "0")
                        pbPost(type = "note", title = "Monitoramento do DOU",
                               body = paste("Erro na busca. Essa é a mensagem do script:", 
                                            cond, sep = " "))
                }
                return(NA)
        }
)