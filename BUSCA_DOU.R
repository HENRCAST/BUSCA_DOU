#Script por Henrique Almeida de Castro

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

tryCatch(
        source('Script_corpo.R'),
        error = function(cond) {
                if(chave_pushbullet != ""){
                        pbSetup(chave_pushbullet, defdev = "0")
                        pbPost(type = "note", title = "BUSCA_DOU",
                               body = paste("Erro na busca. Segue a mensagem do script:", 
                                            cond, sep = " "))
                }
                return(NA)
        }
)