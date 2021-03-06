render_instituicoesPlot <- function(x,y) {
  
 #x <- oasisbrDF
  
  ## Validação para busca sem registros
  shiny::validate(need(x$resultCount>0, paste("A sua busca não corresponde a nenhum registro.")))  
  
  instituicoes_facet <- x$facets$institution
  #author_facet
  
  
  ## Validação para informação vazia.
  shiny::validate(need(is.null(instituicoes_facet)==FALSE, paste("Não existem informações sobre esse(s) registro(s).")))
  
  
  ## Validação para número de termos exibidos
  shiny::validate(need((y>0 & y<=25), paste("O número de termo exibidos precisa estar entre 0 e 25.")))
  
  
  ## Ordena coluna 'count'
  instituicoes_facet <- instituicoes_facet[with(instituicoes_facet, order(-count)),]
  
  ## Retira registro 'sem informação' da coluna 'value'
  instituicoes_facet <- instituicoes_facet[instituicoes_facet$value!='sem informação',]
  
  ## Adiciona % do total
  instituicoes_facet <- instituicoes_facet %>% mutate(pctTotal=count/x$resultCount)
  
  ## Seleciona top 10
  instituicoes_facet <- head(instituicoes_facet, n=y)
  
  #esquisser(author_facet)
  
  ## Gráfico de top 10 Autore(a)s
  
  instituicoesPlot <- ggplot(instituicoes_facet) +
    aes(x = reorder(value, count), group = value, weight = count, 
        text=paste('<b style="font-family: Lato !important; align=left; font-size:14px; font-weight:400; color:gray">Instituição:</b>',
                   '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',value,"</b>",
                   "<br><br>",
                   '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray">Total de documentos:</b>',
                   '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',comma(count),"</b>",
                   "<br><br>",
                   '<b style="font-family: Lato !important; align=left; font-size:14px font-weight:400; color:gray"">% do total:</b>',
                   '<b style="font-family: Lato !important; align=left; font-size:16px; font-weight:600 color: black">',scales::percent(pctTotal),"</b>"
        )
        #text=paste("Autor(a):",value,"<br>","Quantidade",comma(count))
    ) +
    geom_bar(fill = "#112446") +
    
    scale_y_continuous(labels = scales::comma)+
    labs(x = "<b style='color:gray'>Instituição</b><br><br><b style='color:white'>.", 
         y = "<b style='color:gray; font-size:14px'>Total de documentos", title = NULL) +
    
    theme_minimal() +
    theme(axis.title.x = element_text(size = 14L)) +
    coord_flip()
  
  instituicoesPlot <- ggplotly(instituicoesPlot, tooltip="text")
  
  instituicoesPlot %>%
    
    layout(font=t, 
           margin = list(l=50,b = 55),
           hoverlabel=list(bgcolor="white")
    ) %>% config(displayModeBar = F) 
  
  
  
  
}
