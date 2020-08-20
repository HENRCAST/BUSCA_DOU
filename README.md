# BUSCA_DOU: Script em R para monitoramento do Diário Oficial da União

Escrito por Henrique A. Castro (Doutorando na Faculdade de Direito da Universidade de São Paulo, pesquisador visitante na Harvard Kennedy School) 

Contato: henrique.almeida.castro@usp.br 

LATTES: http://buscatextual.cnpq.br/buscatextual/visualizacv.do?id=K4992004E4 

*Esse script é gratuito e vem sem garantia alguma. É direcionado a fins acadêmicos. Jamais pague por ele.

## Apresentação

O BUSCA_DOU é um script de programação que desempenha a função de buscar e separar, em relação aos dias em que for executado, publicações no Diário Oficial da União (DOU) que correspondam a parâmetros de pesquisa definidos pelo usuário. Não tem como propósito buscar publicações em edições passadas, mas sim monitorar diariamente o DOU. Ele emprega a linguagem de programação R, comumente usada no meio acadêmico para a obtenção e processamento de dados.

O script foi escrito com a automação em mente. Ou seja, é possível, com as ferramentas dos sistemas operacionais de computador, fazer com que o script rode diariamente de maneira automática (sem a necessidade de ações do usuário) – desde que o computador esteja ligado e conte com acesso à internet. Pode-se, ainda, utilizar um sistema de notificações por celular, o qual avisa o usuário sobre os resultados da pesquisa (avisando, inclusive, a ocorrência de erros).

Escrevi o script para minhas próprias pesquisas, mas tentei o tornar o mais acessível possível a usuários sem conhecimento da linguagem R (eu mesmo estou muito longe de um grande entendido no assunto). De qualquer maneira, como não é um programa com interface de usuário própria, diversos aspectos de seu funcionamento podem ser contraintuitivos para a maior parte dos pesquisadores. Por isso, recomenda-se atenção às instruções contidas no manual de uso.

Se tiver sugestões para melhorar o script, ou identificar erros sistemáticos no seu funcionamento, pode me contatar em henrique.almeida.castro@usp.br.

## Processo e produto do script

O BUSCA_DOU executa suas funções através de uma série de passos:
- Acessa o site endereço https://inlabs.in.gov.br/, o qual distribui diariamente o DOU em formato .xml.
- Realiza login a partir do e-mail e da senha do usuário.
- A partir das definições das edições do DOU (regular e/ou extra) e das partes (1, 2, e/ou 3) a serem buscadas, faz o download os arquivos .xml (cada qual contendo um ato) relativos... 
  - à edição regular do DOU do dia em que for executado, e
  - à edição extra do DOU do dia anterior àquele em que for executado.
- Busca, entre os arquivos .xml, aqueles cujos textos correspondam aos parâmetros de pesquisa.
- Extrai os textos dos arquivos .xml selecionados, colocando-os em arquivos .txt
- Deleta os arquivos .xml

O produto (se tudo ocorrer bem) são pastas contendo os arquivos .txt produzidos, salvas no mesmo diretório onde se encontrar o script. 

## Como usar

- Baixe e instale os programas “R” e “R Studio”. Ambos são gratuitos.
  - “R” está disponível em: https://cran.r-project.org/. 
  - “R Studio” está disponível em: https://rstudio.com/products/rstudio/. 
- Registre-se no site https://inlabs.in.gov.br/acessar.php. 
- Baixe o pacote do BUSCA_DOU em seu repositório no GitHub.
  - O pacote está disponível em: https://github.com/HENRCAST/BUSCA_DOU. 
  - Para baixar, clique em “CODE -> Dowload ZIP”
- Extraia o arquivo .zip, e coloque a pasta resultante onde desejar.
- Preencha o arquivo “config.R” com os parâmetros de busca, conforme as instruções contidas no manual.
- Agende a execução do script utilizando os recursos de seu sistema operacional (no caso do Windows, o “Agendador de Tarefas”, conforme as instruções contidas no manual).
- OPCIONAL: caso queira utilizar o sistema de notificações no celular, instale o app “Pushbullet”, cadastre-se no serviço, e preencha o arquivo “config.R”, conforme as instruções contidas no manual.
